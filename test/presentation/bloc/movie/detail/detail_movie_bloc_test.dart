import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../dummy_data/dummy_objects.dart';
import 'detail_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getRecommendationMovies: mockGetMovieRecommendations,
      saveWatchlistMovie: mockSaveWatchlist,
      removeWatchlistMovie: mockRemoveWatchlist,
      getWatchListStatusMovie: mockGetWatchListStatus,
    );
  });

  const tId = 1;

  group('Get Detail Movie', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [MovieDetailLoading, MovieDetailLoaded, Recommendation '
      'Loading, RecommendationLoaded] when get detail movie and '
      'recommendation movies success',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testMovieList));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.loading,
        ),
        MovieDetailState.initial().copyWith(
          movieRecommendationsState: RequestState.loading,
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
        ),
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
          movieRecommendationsState: RequestState.loaded,
          movieRecommendations: testMovieList,
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        const FetchMovieDetail(tId).props;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [MovieDetailError] when get detail movie failed',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testMovieList));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.loading,
        ),
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        const FetchMovieDetail(tId).props;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [MovieDetailLoading, MovieDetailLoaded, '
      'RecommendationEmpty] when get recommendation movies empty',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Right([]));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.loading,
        ),
        MovieDetailState.initial().copyWith(
          movieRecommendationsState: RequestState.loading,
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
        ),
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
          movieRecommendationsState: RequestState.empty,
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        const FetchMovieDetail(tId).props;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [MovieDetailLoading, Recommendation Loading, '
      'MovieDetailLoaded, RecommendationError] when get recommendation '
      'movies failed',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.loading,
        ),
        MovieDetailState.initial().copyWith(
          movieRecommendationsState: RequestState.loading,
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
        ),
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
          movieRecommendationsState: RequestState.error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        const FetchMovieDetail(tId).props;
      },
    );
  });

  group('Load Watchlist Status Movie', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [WatchlistStatus] is true',
      build: () {
        when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusMovie(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
      verify: (_) => [
        verify(mockGetWatchListStatus.execute(tId)),
        const LoadWatchlistStatusMovie(tId).props,
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [WatchlistStatus] is false',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusMovie(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(isAddedToWatchlist: false),
      ],
      verify: (_) => [
        verify(mockGetWatchListStatus.execute(tId)),
        const LoadWatchlistStatusMovie(tId).props,
      ],
    );
  });

  group('Added To Watchlist Movie', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [WatchlistMessage, isAddedToWatchlist] when success added to watchlist',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistMovie(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
        ),
        MovieDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
        AddWatchlistMovie(testMovieDetail).props;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [WatchlistMessage] when failed added to watchlist',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistMovie(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
        AddWatchlistMovie(testMovieDetail).props;
      },
    );
  });

  group('Remove From Watchlist Movie', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [WatchlistMessage, isAddedToWatchlist] when success removed from watchlist',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistMovie(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
        RemoveFromWatchlistMovie(testMovieDetail).props;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [WatchlistMessage] when failed removed from watchlist',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistMovie(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
        RemoveFromWatchlistMovie(testMovieDetail).props;
      },
    );
  });
}
