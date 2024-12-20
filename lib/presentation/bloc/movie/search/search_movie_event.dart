part of 'search_movie_bloc.dart';

abstract class SearchMovieEvent extends Equatable {
  const SearchMovieEvent();

  @override
  List<Object?> get props => [];
}

class OnQueryChanged extends SearchMovieEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}