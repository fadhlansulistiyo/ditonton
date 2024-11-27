import 'package:flutter/material.dart';
import '../../../common/state_enum.dart';
import '../../../domain/entity/movie/movie.dart';
import '../../../domain/usecases/movie/get_now_playing_movies.dart';
import '../../../domain/usecases/movie/get_popular_movies.dart';
import '../../../domain/usecases/movie/get_top_rated_movies.dart';

class MovieListNotifier extends ChangeNotifier {

  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListNotifier({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  });

  var _nowPlayingMovies = <Movie>[];
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  RequestState _nowPlayingState = RequestState.empty;
  RequestState get nowPlayingState => _nowPlayingState;

  var _popularMovies = <Movie>[];
  List<Movie> get popularMovies => _popularMovies;

  RequestState _popularMoviesState = RequestState.empty;
  RequestState get popularMoviesState => _popularMoviesState;

  var _topRatedMovies = <Movie>[];
  List<Movie> get topRatedMovies => _topRatedMovies;

  RequestState _topRatedMoviesState = RequestState.empty;
  RequestState get topRatedMoviesState => _topRatedMoviesState;

  String _message = '';
  String get message => _message;

  Future<void> fetchNowPlayingMovies() async {
    _nowPlayingState = RequestState.loading;
    notifyListeners();

    final result = await getNowPlayingMovies.execute();
    result.fold(
        (failure) {
          _nowPlayingState = RequestState.error;
          _message = failure.message;
          notifyListeners();
        },
        (moviesData) {
          _nowPlayingState = RequestState.loaded;
          _nowPlayingMovies = moviesData;
          notifyListeners();
        },
    );
  }

  Future<void> fetchPopularMovies() async {
    _popularMoviesState = RequestState.loading;
    notifyListeners();

    final result = await getPopularMovies.execute();
    result.fold(
        (failure) {
          _popularMoviesState = RequestState.error;
          _message = failure.message;
          notifyListeners();
        },
        (moviesData) {
          _popularMoviesState = RequestState.loaded;
          _popularMovies = moviesData;
          notifyListeners();
        }
    );
  }

  Future<void> fetchTopRatedMovies() async {
    _topRatedMoviesState = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedMovies.execute();
    result.fold(
          (failure) {
        _topRatedMoviesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
          (moviesData) {
        _topRatedMoviesState = RequestState.loaded;
        _topRatedMovies = moviesData;
        notifyListeners();
      },
    );
  }
}
