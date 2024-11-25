import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_object_tv.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvDetail useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = GetTvDetail(mockTvRepository);
  });

  const tId = 1;

  test('should get tv detail from the repository', () async {
    /*
    * arrange */
    when(mockTvRepository.getTvDetail(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    /*
    * act */
    final result = await useCase.execute(tId);
    /*
    * assert */
    expect(result, Right(testTvDetail));
  });
}
