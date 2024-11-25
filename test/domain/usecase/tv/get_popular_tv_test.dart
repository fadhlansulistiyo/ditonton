import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTv useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = GetPopularTv(mockTvRepository);
  });

  final tTv = <Tv>[];

  group('GetPopularTv Tests', () {
    group('execute', () {
      test(
          'should get list of tv from the repository when execute function is called',
          () async {
        /*
        * arrange */
        when(mockTvRepository.getPopularTv())
            .thenAnswer((_) async => Right(tTv));
        /*
        *  act */
        final result = await useCase.execute();
        /*
        * assert */
        expect(result, Right(tTv));
      });
    });
  });
}
