import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTv useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = SearchTv(mockTvRepository);
  });

  final tTv = <Tv>[];
  const tQuery = 'Spiderman';

  test('should get list of tv from the repository', () async {
    /*
    * arrange */
    when(mockTvRepository.searchTv(tQuery))
        .thenAnswer((_) async => Right(tTv));
    /*
    * act */
    final result = await useCase.execute(tQuery);
    /*
    * assert */
    expect(result, Right(tTv));
  });
}
