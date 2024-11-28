part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  final MovieDetail? movieDetail;
  final RequestState movieDetailState;

  final List<Movie> movieRecommendations;
  final RequestState movieRecommendationsState;

  final String message;
  final String watchlistMessage;

  final bool isAddedToWatchlist;

  const MovieDetailState({
    required this.movieDetail,
    required this.movieDetailState,
    required this.movieRecommendations,
    required this.movieRecommendationsState,
    required this.message,
    required this.watchlistMessage,
    required this.isAddedToWatchlist,
  });

  @override
  List<Object?> get props {
    return [
      movieDetail,
      movieDetailState,
      movieRecommendations,
      movieRecommendationsState,
      message,
      watchlistMessage,
      isAddedToWatchlist,
    ];
  }

  MovieDetailState copyWith({
    MovieDetail? movieDetail,
    RequestState? movieDetailState,
    List<Movie>? movieRecommendations,
    RequestState? movieRecommendationsState,
    String? message,
    String? watchlistMessage,
    bool? isAddedToWatchlist,
  }) {
    return MovieDetailState(
      movieDetail: movieDetail ?? this.movieDetail,
      movieDetailState: movieDetailState ?? this.movieDetailState,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      movieRecommendationsState:
          movieRecommendationsState ?? this.movieRecommendationsState,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  factory MovieDetailState.initial() {
    return const MovieDetailState(
      movieDetail: null,
      movieDetailState: RequestState.empty,
      movieRecommendations: [],
      movieRecommendationsState: RequestState.empty,
      message: '',
      watchlistMessage: '',
      isAddedToWatchlist: false,
    );
  }
}
