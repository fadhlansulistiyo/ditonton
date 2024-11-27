part of 'popular_movie_bloc.dart';

sealed class PopularMovieState extends Equatable {
  const PopularMovieState();
}

final class PopularMovieInitial extends PopularMovieState {
  @override
  List<Object> get props => [];
}
