import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/state_enum.dart';
import '../../../../domain/entity/movie/movie.dart';
import '../../../../domain/entity/movie/movie_detail.dart';
import '../../../../domain/usecases/movie/get_movie_detail.dart';
import '../../../../domain/usecases/movie/get_movie_recommendations.dart';
import '../../../../domain/usecases/movie/get_watchlist_status.dart';
import '../../../../domain/usecases/movie/remove_watchlist.dart';
import '../../../../domain/usecases/movie/save_watchlist.dart';

part 'movie_detail_event.dart';

part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getRecommendationMovies;
  final SaveWatchlist saveWatchlistMovie;
  final RemoveWatchlist removeWatchlistMovie;
  final GetWatchListStatus getWatchListStatusMovie;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getRecommendationMovies,
    required this.saveWatchlistMovie,
    required this.removeWatchlistMovie,
    required this.getWatchListStatusMovie,
  }) : super(MovieDetailState.initial()) {
    /*
    * Fetch Movie Detail */
    on<FetchMovieDetail>((event, emit) async {
      emit(state.copyWith(movieDetailState: RequestState.loading));

      final id = event.id;
      final detailMovieResult = await getMovieDetail.execute(id);
      final recommendationMoviesResult =
          await getRecommendationMovies.execute(id);

      detailMovieResult.fold(
        (failure) => emit(
          state.copyWith(
            movieDetailState: RequestState.error,
            message: failure.message,
          ),
        ),
        (movieDetail) {
          emit(
            state.copyWith(
              movieRecommendationsState: RequestState.loading,
              movieDetailState: RequestState.loaded,
              movieDetail: movieDetail,
              watchlistMessage: '',
            ),
          );
          recommendationMoviesResult.fold(
            (failure) => emit(
              state.copyWith(
                movieRecommendationsState: RequestState.error,
                message: failure.message,
              ),
            ),
            (movieRecommendations) {
              if (movieRecommendations.isEmpty) {
                emit(
                  state.copyWith(
                    movieRecommendationsState: RequestState.empty,
                  ),
                );
              } else {
                emit(
                  state.copyWith(
                    movieRecommendationsState: RequestState.loaded,
                    movieRecommendations: movieRecommendations,
                  ),
                );
              }
            },
          );
        },
      );
    });

    /*
    * Check watchlist movie status */
    on<LoadWatchlistStatusMovie>((event, emit) async {
      final status = await getWatchListStatusMovie.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status));
    });

    /*
    * Add movie to watchlist */
    on<AddWatchlistMovie>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await saveWatchlistMovie.execute(movieDetail);

      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusMovie(movieDetail.id));
    });

    /*
    * Remove movie from watchlist */
    on<RemoveFromWatchlistMovie>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await removeWatchlistMovie.execute(movieDetail);

      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusMovie(movieDetail.id));
    });
  }
}
