import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'data/datasources/db/database_helper.dart';
import 'data/datasources/movie_local_data_source.dart';
import 'data/datasources/movie_local_data_source_impl.dart';
import 'data/datasources/movie_remote_data_source.dart';
import 'data/datasources/movie_remote_data_source_impl.dart';
import 'domain/usecases/get_popular_movies.dart';
import 'domain/usecases/get_top_rated_movies.dart';

final locator = GetIt.instance;

void init() {
  /*
  * provider
  */
  locator.registerFactory(() => MovieListNotifier(
        getNowPlayingMovies: locator(),
        getPopularMovies: locator(),
        getTopRatedMovies: locator(),
      ));

  /*
  * use case
  */
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));

  /*
  * repository
  */
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      movieRemoteDataSource: locator(),
      movieLocalDataSource: locator(),
    ),
  );

  /*
  * data sources
  */
  locator.registerLazySingleton<MovieRemoteDataSource>(
          () => MovieRemoteDataSourceImpl(client: locator()));

  locator.registerLazySingleton<MovieLocalDataSource>(
          () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  /*
  * helper
  */
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  /*
  * external
  */
  locator.registerLazySingleton(() => http.Client());
}
