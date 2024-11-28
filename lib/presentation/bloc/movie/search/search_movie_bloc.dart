import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/entity/movie/movie.dart';

part 'search_movie_event.dart';

part 'search_movie_state.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchMovies _searchMovies;

  SearchMovieBloc(this._searchMovies) : super(SearchMovieEmpty()) {
    on<OnQueryChanged>(
      (event, emit) async {
        final query = event.query;

        emit(SearchMovieLoading());
        final result = await _searchMovies.execute(query);

        result.fold(
          (failure) {
            emit(SearchMovieError(failure.message));
          },
          (data) {
            emit(SearchMovieHasData(data));
          },
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
