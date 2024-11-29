import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../dummy_data/dummy_objects_tv.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])
void main() {
  late WatchlistTvBloc watchlistTvBloc;
  late MockGetWatchlistTv mockGetWatchlistTv;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    watchlistTvBloc = WatchlistTvBloc(mockGetWatchlistTv);
  });

  final tWatchlistTvList = <Tv>[testWatchlistTv];

  test('initial state should be empty', () {
    expect(watchlistTvBloc.state, WatchlistTvEmpty());
  });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTv.execute())
          .thenAnswer((_) async => Right(tWatchlistTvList));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistTv()),
    expect: () => [
      WatchlistTvLoading(),
      WatchlistTvHasData(tWatchlistTvList),
    ],
    verify: (_) => [
      verify(mockGetWatchlistTv.execute()),
      const FetchWatchlistTv().props,
    ],
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockGetWatchlistTv.execute())
          .thenAnswer((_) async => const Right([]));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistTv()),
    expect: () => [
      WatchlistTvLoading(),
      WatchlistTvEmpty(),
    ],
    verify: (_) => [
      verify(mockGetWatchlistTv.execute()),
      const FetchWatchlistTv().props,
    ],
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Error] when get watchlist tv series is unsuccessful',
    build: () {
      when(mockGetWatchlistTv.execute()).thenAnswer(
          (_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistTv()),
    expect: () => [
      WatchlistTvLoading(),
      WatchlistTvError('Database Failure'),
    ],
    verify: (_) => [
      verify(mockGetWatchlistTv.execute()),
      const FetchWatchlistTv().props,
    ],
  );
}
