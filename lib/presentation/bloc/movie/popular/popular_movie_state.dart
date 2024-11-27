part of 'popular_movie_bloc.dart';

sealed class PopularMovieState extends Equatable {
  const PopularMovieState();
  
  @override
  List<Object?> get props => [];
}

class PopularMovieEmpty extends PopularMovieState {}

class PopularMovieLoading extends PopularMovieState {}

class PopularMovieError extends PopularMovieState {
  final String message;

  PopularMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularMovieHasData extends PopularMovieState {
  final List<Movie> result;

  PopularMovieHasData(this.result);

  @override
  List<Object> get props => [result];
}