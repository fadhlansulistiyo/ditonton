import 'package:flutter/material.dart';
import '../../../common/state_enum.dart';
import '../../../domain/entity/movie/movie.dart';
import '../../../domain/entity/movie/movie_detail.dart';
import '../../../domain/usecases/movie/get_movie_detail.dart';
import '../../../domain/usecases/movie/get_movie_recommendations.dart';
import '../../../domain/usecases/movie/get_watchlist_status.dart';
import '../../../domain/usecases/movie/remove_watchlist.dart';
import '../../../domain/usecases/movie/save_watchlist.dart';

class MovieDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailNotifier({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  late MovieDetail _movie;

  MovieDetail get movie => _movie;

  RequestState _movieState = RequestState.empty;

  RequestState get movieState => _movieState;

  List<Movie> _movieRecommendations = [];

  List<Movie> get movieRecommendations => _movieRecommendations;

  RequestState _recommendationState = RequestState.empty;

  RequestState get recommendationState => _recommendationState;

  String _message = '';

  String get message => _message;

  bool _isAddedToWatchlist = false;

  bool get isAddedToWatchlist => _isAddedToWatchlist;

  Future<void> fetchMovieDetail(int id) async {
    _movieState = RequestState.loading;
    notifyListeners();

    final detailResult = await getMovieDetail.execute(id);
    final recommendationResult = await getMovieRecommendations.execute(id);

    detailResult.fold(
      (failure) {
        _movieState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (movie) {
        _recommendationState = RequestState.loading;
        _movie = movie;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.error;
            _message = failure.message;
          },
          (movieRecommendation) {
            _recommendationState = RequestState.loaded;
            _movieRecommendations = movieRecommendation;
          },
        );
        _movieState = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';

  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(MovieDetail movie) async {
    final result = await saveWatchlist.execute(movie);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final result = await removeWatchlist.execute(movie);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }
}
