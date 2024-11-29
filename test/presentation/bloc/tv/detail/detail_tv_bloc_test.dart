import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/tv/detail/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../dummy_data/dummy_object_tv.dart';
import 'detail_tv_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    tvDetailBloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getRecommendationTv: mockGetTvRecommendations,
      saveWatchlistTv: mockSaveWatchlist,
      removeWatchlistTv: mockRemoveWatchlist,
      getWatchListStatusTv: mockGetWatchListStatus,
    );
  });

  const tId = 1;

  group('Get Detail Tv', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [TvDetailLoading, TvDetailLoaded, Recommendation '
      'Loading, RecommendationLoaded] when get detail tv and '
      'recommendation Tv success',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvList));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.loading,
        ),
        TvDetailState.initial().copyWith(
          tvRecommendationsState: RequestState.loading,
          tvDetailState: RequestState.loaded,
          tvDetail: testTvDetail,
        ),
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.loaded,
          tvDetail: testTvDetail,
          tvRecommendationsState: RequestState.loaded,
          tvRecommendations: testTvList,
        ),
      ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
        const FetchTvDetail(tId).props;
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [TvDetailError] when get detail tv failed',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvList));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.loading,
        ),
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
        const FetchTvDetail(tId).props;
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [TvDetailLoading, TvDetailLoaded, '
      'RecommendationEmpty] when get recommendation Tv empty',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => const Right([]));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.loading,
        ),
        TvDetailState.initial().copyWith(
          tvRecommendationsState: RequestState.loading,
          tvDetailState: RequestState.loaded,
          tvDetail: testTvDetail,
        ),
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.loaded,
          tvDetail: testTvDetail,
          tvRecommendationsState: RequestState.empty,
        ),
      ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
        const FetchTvDetail(tId).props;
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [TvDetailLoading, Recommendation Loading, '
      'TvDetailLoaded, RecommendationError] when get recommendation '
      'Tv failed',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.loading,
        ),
        TvDetailState.initial().copyWith(
          tvRecommendationsState: RequestState.loading,
          tvDetailState: RequestState.loaded,
          tvDetail: testTvDetail,
        ),
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.loaded,
          tvDetail: testTvDetail,
          tvRecommendationsState: RequestState.error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
        const FetchTvDetail(tId).props;
      },
    );
  });

  group('Load Watchlist Status Tv', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [WatchlistStatus] is true',
      build: () {
        when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusTv(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
      verify: (_) => [
        verify(mockGetWatchListStatus.execute(tId)),
        const LoadWatchlistStatusTv(tId).props,
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [WatchlistStatus] is false',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusTv(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(isAddedToWatchlist: false),
      ],
      verify: (_) => [
        verify(mockGetWatchListStatus.execute(tId)),
        const LoadWatchlistStatusTv(tId).props,
      ],
    );
  });

  group('Added To Watchlist Tv', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [WatchlistMessage, isAddedToWatchlist] when success added to watchlist',
      build: () {
        when(mockSaveWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTv(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
        ),
        TvDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testTvDetail));
        verify(mockGetWatchListStatus.execute(testTvDetail.id));
        AddWatchlistTv(testTvDetail).props;
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [WatchlistMessage] when failed added to watchlist',
      build: () {
        when(mockSaveWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTv(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testTvDetail));
        verify(mockGetWatchListStatus.execute(testTvDetail.id));
        AddWatchlistTv(testTvDetail).props;
      },
    );
  });

  group('Remove From Watchlist Tv', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [WatchlistMessage, isAddedToWatchlist] when success removed from watchlist',
      build: () {
        when(mockRemoveWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistTv(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(testTvDetail));
        verify(mockGetWatchListStatus.execute(testTvDetail.id));
        RemoveFromWatchlistTv(testTvDetail).props;
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [WatchlistMessage] when failed removed from watchlist',
      build: () {
        when(mockRemoveWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistTv(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(testTvDetail));
        verify(mockGetWatchListStatus.execute(testTvDetail.id));
        RemoveFromWatchlistTv(testTvDetail).props;
      },
    );
  });
}
