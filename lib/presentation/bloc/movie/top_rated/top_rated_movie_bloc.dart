import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entity/movie/movie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_movie_event.dart';

part 'top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMovieBloc(this._getTopRatedMovies) : super(TopRatedMovieEmpty()) {
    on<FetchTopRatedMovie>(
      (event, emit) async {
        emit(TopRatedMovieLoading());
        final result = await _getTopRatedMovies.execute();

        result.fold(
          (failure) {
            emit(TopRatedMovieError(failure.message));
          },
          (data) {
            emit(TopRatedMovieHasData(data));
          },
        );
      },
    );
  }
}
