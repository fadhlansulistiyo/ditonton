part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();
}

class FetchWatchlistMovie extends WatchlistMovieEvent {
  const FetchWatchlistMovie();

  @override
  List<Object> get props => [];
}
