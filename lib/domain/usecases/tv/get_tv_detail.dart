import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entity/tv/tv_detail.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTvDetail {
  final TvRepository tvRepository;

  GetTvDetail(this.tvRepository);

  Future<Either<Failure, TvDetail>> execute(int id) {
    return tvRepository.getTvDetail(id);
  }
}