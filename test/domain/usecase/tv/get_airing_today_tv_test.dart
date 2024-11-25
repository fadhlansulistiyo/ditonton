import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entity/movie/movie.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_airing_today_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetAiringTodayTv useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = GetAiringTodayTv(mockTvRepository);
  });

  final tTv = <Tv>[];

  test('Should get list of tv from the repository', () async {
    /*
    * arrange */
    when(mockTvRepository.getAiringTodayTv())
        .thenAnswer((_) async => Right(tTv));
    /*
    * act */
    final result = await useCase.execute();
    /*
    * assert */
    expect(result, Right(tTv));
  });
}
