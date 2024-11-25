import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entity/movie/movie.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendations useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = GetTvRecommendations(mockTvRepository);
  });

  const tId = 1;
  final tTv = <Tv>[];

  test('should get list of tv recommendations from the repository',
      () async {
    /*
    * arrange */
    when(mockTvRepository.getTvRecommendations(tId))
        .thenAnswer((_) async => Right(tTv));
    /*
    * act */
    final result = await useCase.execute(tId);
    /*
    * assert */
    expect(result, Right(tTv));
  });
}
