import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/tv/get_airing_today_tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv.dart';
import 'package:ditonton/presentation/provider/movie/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/movie/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/movie/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/movie/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/tv/popular_tv_notifier.dart';
import 'package:ditonton/presentation/provider/tv/top_rated_tv_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_search_notifier.dart';
import 'package:ditonton/presentation/provider/tv/watchlist_tv_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'data/datasources/db/database_helper.dart';
import 'data/datasources/movie/movie_local_ds.dart';
import 'data/datasources/movie/movie_local_ds_impl.dart';
import 'data/datasources/movie/movie_remote_ds.dart';
import 'data/datasources/movie/movie_remote_ds_impl.dart';
import 'data/datasources/tv/tv_local_ds.dart';
import 'data/datasources/tv/tv_local_ds_impl.dart';
import 'data/datasources/tv/tv_remote_ds.dart';
import 'data/datasources/tv/tv_remote_ds_impl.dart';
import 'data/repositories/tv_repository_impl.dart';
import 'domain/usecases/movie/get_movie_detail.dart';
import 'domain/usecases/movie/get_movie_recommendations.dart';
import 'domain/usecases/movie/get_popular_movies.dart';
import 'domain/usecases/movie/get_top_rated_movies.dart';
import 'domain/usecases/movie/get_watchlist_movies.dart';
import 'domain/usecases/movie/search_movies.dart';
import 'domain/usecases/tv/get_popular_tv.dart';
import 'domain/usecases/tv/get_top_rated_tv.dart';
import 'domain/usecases/tv/get_tv_detail.dart';
import 'domain/usecases/tv/get_tv_recommendations.dart';
import 'domain/usecases/movie/save_watchlist.dart' as movie_save_watchlist;
import 'domain/usecases/movie/remove_watchlist.dart' as movie_remove_watchlist;
import 'domain/usecases/movie/get_watchlist_status.dart'
    as movie_watchlist_status;
import 'domain/usecases/tv/get_watchlist_tv.dart';
import 'domain/usecases/tv/save_watchlist.dart' as tv_save_watchlist;
import 'domain/usecases/tv/remove_watchlist.dart' as tv_remove_watchlist;
import 'domain/usecases/tv/get_watchlist_status.dart' as tv_watchlist_status;

final locator = GetIt.instance;

void init() {
  /*
  * provider
  */

  // Movie List
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );

  // Tv List
  locator.registerFactory(
    () => TvListNotifier(
      getAiringTodayTv: locator(),
      getPopularTv: locator(),
      getTopRatedTv: locator(),
    ),
  );

  // Movie Detail
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );

  // Tv Detail
  locator.registerFactory(
    () => TvDetailNotifier(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );

  // Movie Search
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );

  // TV Search
  locator.registerFactory(
    () => TvSearchNotifier(
      searchTv: locator(),
    ),
  );

  // Popular Movie
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );

  // Popular Tv
  locator.registerFactory(
    () => PopularTvNotifier(
      locator(),
    ),
  );

  // Top Rated Movie
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );

  // Top Rated Tv
  locator.registerFactory(
    () => TopRatedTvNotifier(
      getTopRatedTv: locator(),
    ),
  );

  // Watchlist Movie
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );

  // Watchlist Tv
  locator.registerFactory(
    () => WatchlistTvNotifier(
      getWatchlistTv: locator(),
    ),
  );

  /*
  * Movies use case
  */
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(
      () => movie_save_watchlist.SaveWatchlist(locator()));
  locator.registerLazySingleton(
      () => movie_remove_watchlist.RemoveWatchlist(locator()));
  locator.registerLazySingleton(
      () => movie_watchlist_status.GetWatchListStatus(locator()));

  /*
  * TV Series  use case
  * */
  locator.registerLazySingleton(() => GetAiringTodayTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));
  locator
      .registerLazySingleton(() => tv_save_watchlist.SaveWatchlist(locator()));
  locator.registerLazySingleton(
      () => tv_remove_watchlist.RemoveWatchlist(locator()));
  locator.registerLazySingleton(
      () => tv_watchlist_status.GetWatchListStatus(locator()));
  // locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  /*
  * repository
  */
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      movieRemoteDataSource: locator(),
      movieLocalDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  /*
  * Movies data sources
  */
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));

  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  /*
  * Tv Series data sources
  */
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));

  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()));

  /*
  * helper
  */
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  /*
  * external
  */
  locator.registerLazySingleton(() => http.Client());
}
