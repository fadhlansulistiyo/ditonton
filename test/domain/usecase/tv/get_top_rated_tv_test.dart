import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTv useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = GetTopRatedTv(mockTvRepository);
  });

  final tTv = <Tv>[];

  test('should get list of tv from repository', () async {
    /*
    * arrange */
    when(mockTvRepository.getTopRatedTv())
        .thenAnswer((_) async => Right(tTv));
    /*
    * act */
    final result = await useCase.execute();
    /*
    * assert */
    expect(result, Right(tTv));
  });
}
