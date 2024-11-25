import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_object_tv.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTv useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = GetWatchlistTv(mockTvRepository);
  });

  test('should get list of tv from the repository', () async {
    /*
    * arrange */
    when(mockTvRepository.getWatchlistTv())
        .thenAnswer((_) async => Right(testTvList));
    /*
    * act */
    final result = await useCase.execute();
    /*
    * assert */
    expect(result, Right(testTvList));
  });
}
