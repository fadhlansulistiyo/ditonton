import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entity/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMovieBloc watchlistMovieBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovie;

  setUp(() {
    mockGetWatchlistMovie = MockGetWatchlistMovies();
    watchlistMovieBloc = WatchlistMovieBloc(mockGetWatchlistMovie);
  });

  final tWatchlistMovieList = <Movie>[testWatchlistMovie];

  test('initial state should be empty', () {
    expect(watchlistMovieBloc.state, WatchlistMovieEmpty());
  });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovie.execute())
          .thenAnswer((_) async => Right(tWatchlistMovieList));
      return watchlistMovieBloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistMovie()),
    expect: () => [
      WatchlistMovieLoading(),
      WatchlistMovieHasData(tWatchlistMovieList),
    ],
    verify: (_) => [
      verify(mockGetWatchlistMovie.execute()),
      const FetchWatchlistMovie().props,
    ],
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockGetWatchlistMovie.execute())
          .thenAnswer((_) async => const Right([]));
      return watchlistMovieBloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistMovie()),
    expect: () => [
      WatchlistMovieLoading(),
      WatchlistMovieEmpty(),
    ],
    verify: (_) => [
      verify(mockGetWatchlistMovie.execute()),
      const FetchWatchlistMovie().props,
    ],
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Error] when get watchlist tv series is unsuccessful',
    build: () {
      when(mockGetWatchlistMovie.execute()).thenAnswer(
          (_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistMovieBloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistMovie()),
    expect: () => [
      WatchlistMovieLoading(),
      WatchlistMovieError('Database Failure'),
    ],
    verify: (_) => [
      verify(mockGetWatchlistMovie.execute()),
      const FetchWatchlistMovie().props,
    ],
  );
}
