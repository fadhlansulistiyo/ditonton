import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entity/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchMovies useCase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    useCase = SearchMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];
  const tQuery = 'Spiderman';

  test('should get list of movies from the repository', () async {
    /*
    * arrange */
    when(mockMovieRepository.searchMovies(tQuery))
        .thenAnswer((_) async => Right(tMovies));
    /*
    * act */
    final result = await useCase.execute(tQuery);
    /*
    * assert */
    expect(result, Right(tMovies));
  });
}
