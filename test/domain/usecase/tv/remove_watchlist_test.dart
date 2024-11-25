import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_object_tv.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlist useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = RemoveWatchlist(mockTvRepository);
  });

  test('should remove watchlist movie from repository', () async {
    /*
    * arrange */
    when(mockTvRepository.removeWatchlist(testTvDetail))
        .thenAnswer((_) async => const Right('Removed from watchlist'));
    /*
    * act */
    final result = await useCase.execute(testTvDetail);
    /*
    * assert */
    verify(mockTvRepository.removeWatchlist(testTvDetail));
    expect(result, const Right('Removed from watchlist'));
  });
}
