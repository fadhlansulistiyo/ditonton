import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entity/movie/movie_detail.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetMovieDetail {
  final MovieRepository movieRepository;

  GetMovieDetail(this.movieRepository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return movieRepository.getMovieDetail(id);
  }
}