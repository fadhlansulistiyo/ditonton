import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_airing_today_tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetAiringTodayTv, GetPopularTv, GetTopRatedTv])
void main() {
  late TvListNotifier provider;
  late MockGetAiringTodayTv mockGetAiringTodayTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetAiringTodayTv = MockGetAiringTodayTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();
    provider = TvListNotifier(
      getAiringTodayTv: mockGetAiringTodayTv,
      getPopularTv: mockGetPopularTv,
      getTopRatedTv: mockGetTopRatedTv,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTv = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvList = <Tv>[tTv];

  group('Airing Today Tv', () {
    test('initialState should be Empty', () {
      expect(provider.airingTodayState, equals(RequestState.Empty));
    });

    test('Should get data from the useCase', () async {
      /*
      * arrange */
      when(mockGetAiringTodayTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      /*
      * act */
      provider.fetchAiringTodayTv();
      /*
      * assert */
      verify(mockGetAiringTodayTv.execute());
    });

    test('Should change state to Loading when useCase is called', () {
      /*
      * arrange */
      when(mockGetAiringTodayTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      /*
      * act */
      provider.fetchAiringTodayTv();
      /*
      * assert */
      expect(provider.airingTodayState, RequestState.Loading);
    });

    test('Should change tv when data is gotten successfully', () async {
      /*
      * arrange */
      when(mockGetAiringTodayTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      /*
      * act */
      await provider.fetchAiringTodayTv();
      /*
      * assert */
      expect(provider.airingTodayState, RequestState.Loaded);
      expect(provider.airingTodayTv, tTvList);
      expect(listenerCallCount, 2);
    });

    test('Should return error when data is unsuccessful', () async {
      /*
      * arrange */
      when(mockGetAiringTodayTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      /*
      * act */
      await provider.fetchAiringTodayTv();
      /*
      * assert */
      expect(provider.airingTodayState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv', () {
    test('Should change state to loading when useCase is called', () async {
      /*
      * arrange */
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      /*
      * act */
      provider.fetchPopularTv();
      /*
      * assert */
      expect(provider.popularTvState, RequestState.Loading);
    });

    test('should change tv data when data is gotten successfully',
        () async {
      /*
      * arrange */
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      /*
      * act */
      await provider.fetchPopularTv();
      /*
      * assert */
      expect(provider.popularTvState, RequestState.Loaded);
      expect(provider.popularTv, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      /*
      * arrange */
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      /*
      * act */
      await provider.fetchPopularTv();
      /*
      * assert */
      expect(provider.popularTvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tv', () {
    test('should change state to loading when useCase is called', () async {
      /*
      * arrange */
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      /*
      * act */
      provider.fetchTopRatedTv();
      /*
      * assert */
      expect(provider.topRatedTvState, RequestState.Loading);
    });

    test('should change tv data when data is gotten successfully',
        () async {
      /*
      * arrange */
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      /*
      * act */
      await provider.fetchTopRatedTv();
      /*
      * assert */
      expect(provider.topRatedTvState, RequestState.Loaded);
      expect(provider.topRatedTv, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      /*
      * arrange */
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      /*
      * act */
      await provider.fetchTopRatedTv();
      /*
      * assert */
      expect(provider.topRatedTvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
