import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entity/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingMovies useCase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    useCase = GetNowPlayingMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];

  test('Should get list of movies from the repository', () async {
    /*
    * arrange */
    when(mockMovieRepository.getNowPlayingMovies())
        .thenAnswer((_) async => Right(tMovies));
    /*
    * act */
    final result = await useCase.execute();
    /*
    * assert */
    expect(result, Right(tMovies));
  });
}
