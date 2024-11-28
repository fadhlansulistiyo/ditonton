import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entity/movie/movie.dart';
import '../../../../domain/usecases/movie/get_watchlist_movies.dart';

part 'watchlist_movie_event.dart';

part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovies;

  WatchlistMovieBloc(this._getWatchlistMovies) : super(WatchlistMovieEmpty()) {
    on<FetchWatchlistMovie>((event, emit) async {
      emit(WatchlistMovieLoading());

      final result = await _getWatchlistMovies.execute();

      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (data) {
          if (data.isEmpty) {
            emit(WatchlistMovieEmpty());
          } else {
            emit(WatchlistMovieHasData(data));
          }
        },
      );
    });
  }
}
