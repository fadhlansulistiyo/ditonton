import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import '../../entity/tv/tv.dart';

class GetAiringTodayTv {
  final TvRepository repository;

  GetAiringTodayTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getAiringTodayTv();
  }
}
