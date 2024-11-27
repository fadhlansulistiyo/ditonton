import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_airing_today_tv.dart';
import 'package:ditonton/presentation/provider/tv/airing_today_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetAiringTodayTv])
void main() {
  late AiringTodayTvNotifier notifier;
  late MockGetAiringTodayTv mockGetAiringTodayTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetAiringTodayTv = MockGetAiringTodayTv();
    notifier = AiringTodayTvNotifier(getAiringTodayTv: mockGetAiringTodayTv)
      ..addListener(() {
        listenerCallCount++;
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

  test('should change state to loading when useCase is called', () async {
    /*
    * arrange */
    when(mockGetAiringTodayTv.execute())
        .thenAnswer((_) async => Right(tTvList));
    /*
    * act */
    notifier.fetchAiringTodayTv();
    /*
    * assert */
    expect(notifier.state, RequestState.loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv data when data is gotten successfully', () async {
    /*
    * arrange */
    when(mockGetAiringTodayTv.execute())
        .thenAnswer((_) async => Right(tTvList));
    /*
    * act */
    await notifier.fetchAiringTodayTv();
    /*
    * assert */
    expect(notifier.state, RequestState.loaded);
    expect(notifier.tv, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    /*
    * arrange */
    when(mockGetAiringTodayTv.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    /*
    * act */
    await notifier.fetchAiringTodayTv();
    /*
    * assert */
    expect(notifier.state, RequestState.error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
