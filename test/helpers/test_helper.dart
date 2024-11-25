import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie/movie_local_ds.dart';
import 'package:ditonton/data/datasources/movie/movie_remote_ds.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  /*
  * Movies */
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
  /*
  * Tv */
  TvRepository,
  // TODO
  /*
  * TvRemoteDateSource
  * TvLocalDataSource
  * */
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
