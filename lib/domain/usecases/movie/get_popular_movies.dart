import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import '../../entity/movie/movie.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularMovies();
  }
}
