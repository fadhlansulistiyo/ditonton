import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entity/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/presentation/provider/movie/popular_movies_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_notifier_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMoviesNotifier notifier;
  late MockGetPopularMovies mockGetPopularMovies;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularMovies = MockGetPopularMovies();
    notifier = PopularMoviesNotifier(mockGetPopularMovies)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie];

  test('should change state to loading when useCase is called', () async {
    /*
    * arrange */
    when(mockGetPopularMovies.execute())
        .thenAnswer((_) async => Right(tMovieList));
    /*
    * act */
    notifier.fetchPopularMovies();
    /*
    * assert */
    expect(notifier.state, RequestState.loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    /*
    * arrange */
    when(mockGetPopularMovies.execute())
        .thenAnswer((_) async => Right(tMovieList));
    /*
    * act */
    await notifier.fetchPopularMovies();
    /*
    * assert */
    expect(notifier.state, RequestState.loaded);
    expect(notifier.movies, tMovieList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    /*
    * arrange */
    when(mockGetPopularMovies.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    /*
    * act */
    await notifier.fetchPopularMovies();
    /*
    * assert */
    expect(notifier.state, RequestState.error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
