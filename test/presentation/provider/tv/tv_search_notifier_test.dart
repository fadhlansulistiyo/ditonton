import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv.dart';
import 'package:ditonton/presentation/provider/tv/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late TvSearchNotifier provider;
  late MockSearchTv mockSearchTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTv = MockSearchTv();
    provider = TvSearchNotifier(searchTv: mockSearchTv)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTvModel = Tv(
    adult: false,
    backdropPath: "/sYXLeu5usz6yEz0k00FYvtEdodD.jpg",
    genreIds: const [16, 10765, 10759, 9648],
    id: 94605,
    originalName: "Arcane",
    overview:
        "Amid the stark discord of twin cities Piltover and Zaun, two sisters fight on rival sides of a war between magic technologies and clashing convictions.",
    popularity: 1964.981,
    posterPath: "/fqldf2t8ztc9aiwn3k6mlX3tvRT.jpg",
    firstAirDate: "2021-11-06",
    name: "Arcane",
    voteAverage: 8.8,
    voteCount: 4335,
  );
  
  final tTvList = <Tv>[tTvModel];

  const tQuery = 'Arcane';

  group('search Tvs', () {
    test('should change state to loading when useCase is called', () async {
      /*
      * arrange */
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      /*
      * act */
      provider.fetchTvSearch(tQuery);
      /*
      * assert */
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchTvSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      /*
      * arrange */
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      /*
      * act */
      await provider.fetchTvSearch(tQuery);
      /*
      * assert */
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
