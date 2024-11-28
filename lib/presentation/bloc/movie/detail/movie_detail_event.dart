part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();
}

/*
* Fetch movie detail */
class FetchMovieDetail extends MovieDetailEvent {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object?> get props => [id];
}

/*
* Load watchlist status */
class LoadWatchlistStatusMovie extends MovieDetailEvent {
  final int id;

  const LoadWatchlistStatusMovie(this.id);

  @override
  List<Object?> get props => [id];
}

/*
* Add movie to watchlist */
class AddWatchlistMovie extends MovieDetailEvent {
  final MovieDetail movieDetail;

  const AddWatchlistMovie(this.movieDetail);

  @override
  List<Object?> get props => [movieDetail];
}

/*
* Remove movie from watchlist */
class RemoveFromWatchlistMovie extends MovieDetailEvent {
  final MovieDetail movieDetail;

  const RemoveFromWatchlistMovie(this.movieDetail);

  @override
  List<Object?> get props => [movieDetail];
}