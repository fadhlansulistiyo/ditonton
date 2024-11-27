import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_object_tv.dart';
import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late TvDetailNotifier provider;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    provider = TvDetailNotifier(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  const tId = 1;

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

  /*
  * Initial Arrange
  */
  void arrangeUseCase() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    when(mockGetTvRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTvList));
  }

  group('Get Tv Detail', () {
    test('should get data from the useCase', () async {
      /*
      * arrange */
      arrangeUseCase();
      /*
      * act */
      await provider.fetchTvDetail(tId);
      /*
      * assert */
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
    });

    test('should change state to Loading when useCase is called', () {
      /*
      * arrange */
      arrangeUseCase();
      /*
      * act */
      provider.fetchTvDetail(tId);
      /*
      * assert */
      expect(provider.tvState, RequestState.loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv when data is gotten successfully', () async {
      /*
      * arrange */
      arrangeUseCase();
      /*
      * act */
      await provider.fetchTvDetail(tId);
      /*
      * assert */
      expect(provider.tvState, RequestState.loaded);
      expect(provider.tv, testTvDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation tv list when data is gotten successfully',
        () async {
      /*
      * arrange */
      arrangeUseCase();
      /*
      * act */
      await provider.fetchTvDetail(tId);
      /*
      * assert */
      expect(provider.tvState, RequestState.loaded);
      expect(provider.tvRecommendations, tTvList);
    });
  });

  group('Get Tv Recommendations', () {
    test('should get data from the useCase', () async {
      /*
      * arrange */
      arrangeUseCase();
      /*
      * act */
      await provider.fetchTvDetail(tId);
      /*
      * assert */
      verify(mockGetTvRecommendations.execute(tId));
      expect(provider.tvRecommendations, tTvList);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      /*
      * arrange */
      arrangeUseCase();
      /*
      * act */
      await provider.fetchTvDetail(tId);
      /*
      * assert */
      expect(provider.recommendationState, RequestState.loaded);
      expect(provider.tvRecommendations, tTvList);
    });

    test('should update error message when request in successful', () async {
      /*
      * arrange */
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      /*
      * act */
      await provider.fetchTvDetail(tId);
      /*
      * assert */
      expect(provider.recommendationState, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      /*
      * arrange */
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      /*
      * act */
      await provider.loadWatchlistStatus(1);
      /*
      * assert */
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      /*
      * arrange */
      when(mockSaveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Right('Success'));
      when(mockGetWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);
      /*
      * act */
      await provider.addWatchlist(testTvDetail);
      /*
      * assert */
      verify(mockSaveWatchlist.execute(testTvDetail));
    });

    test('should execute remove watchlist when function called', () async {
      /*
      * arrange */
      when(mockRemoveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Right('Removed'));
      when(mockGetWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      /*
      * act */
      await provider.removeFromWatchlist(testTvDetail);
      /*
      * assert */
      verify(mockRemoveWatchlist.execute(testTvDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      /*
      * arrange */
      when(mockSaveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);
      /*
      * act */
      await provider.addWatchlist(testTvDetail);
      /*
      * assert */
      verify(mockGetWatchlistStatus.execute(testTvDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      /*
      * arrange */
      when(mockSaveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      /*
      * act */
      await provider.addWatchlist(testTvDetail);
      /*
      * assert */
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      /*
      * arrange */
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvList));
      /*
      * act */
      await provider.fetchTvDetail(tId);
      /*
      * assert */
      expect(provider.tvState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
