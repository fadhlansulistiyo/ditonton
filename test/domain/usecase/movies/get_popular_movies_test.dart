import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entity/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularMovies useCase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    useCase = GetPopularMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];

  group('GetPopularMovies Tests', () {
    group('execute', () {
      test(
          'should get list of movies from the repository when execute function is called',
          () async {
        /*
        * arrange */
        when(mockMovieRepository.getPopularMovies())
            .thenAnswer((_) async => Right(tMovies));
        /*
        *  act */
        final result = await useCase.execute();
        /*
        * assert */
        expect(result, Right(tMovies));
      });
    });
  });
}
