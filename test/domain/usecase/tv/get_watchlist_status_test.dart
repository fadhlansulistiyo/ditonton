import 'package:ditonton/domain/usecases/tv/get_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListStatus useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = GetWatchListStatus(mockTvRepository);
  });

  test('should get watchlist status from repository', () async {
    /*
    * arrange */
    when(mockTvRepository.isAddedToWatchlist(1))
        .thenAnswer((_) async => true);
    /*
    * act */
    final result = await useCase.execute(1);
    /*
    * assert */
    expect(result, true);
  });
}
