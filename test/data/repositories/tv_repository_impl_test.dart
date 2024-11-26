import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv/genre_model_tv.dart';
import 'package:ditonton/data/models/tv/tv_detail_model.dart';
import 'package:ditonton/data/models/tv/tv_model.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/dummy_objects_tv.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource remoteDataSource;
  late MockTvLocalDataSource localDataSource;

  setUp(() {
    remoteDataSource = MockTvRemoteDataSource();
    localDataSource = MockTvLocalDataSource();
    repository = TvRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  final tTvModel = TvModel(
    adult: false,
    backdropPath: "/sYXLeu5usz6yEz0k00FYvtEdodD.jpg",
    genreIds: const [16, 10765, 10759, 9648],
    id: 94605,
    originalName: "Arcane",
    overview:
        "Amid the stark discord of twin cities Piltover and Zaun, two sisters fight on rival sides of a war between magic technologies and clashing convictions.",
    popularity: 1964.981,
    posterPath: "/fqldf2t8ztc9aiwn3k6mlX3tvRT.jpg",
    firstAirDate: "2021-11-06",
    name: "Arcane",
    voteAverage: 8.8,
    voteCount: 4335,
  );

  final tTv = Tv(
    adult: false,
    backdropPath: "/sYXLeu5usz6yEz0k00FYvtEdodD.jpg",
    genreIds: const [16, 10765, 10759, 9648],
    id: 94605,
    originalName: "Arcane",
    overview:
        "Amid the stark discord of twin cities Piltover and Zaun, two sisters fight on rival sides of a war between magic technologies and clashing convictions.",
    popularity: 1964.981,
    posterPath: "/fqldf2t8ztc9aiwn3k6mlX3tvRT.jpg",
    firstAirDate: "2021-11-06",
    name: "Arcane",
    voteAverage: 8.8,
    voteCount: 4335,
  );

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  group('Now Airing Today Tv', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      /*
      * arrange */
      when(remoteDataSource.getAiringTodayTv())
          .thenAnswer((_) async => tTvModelList);
      /*
      * act */
      final result = await repository.getAiringTodayTv();
      /*
      * assert */
      verify(remoteDataSource.getAiringTodayTv());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      /*
      * arrange */
      when(remoteDataSource.getAiringTodayTv()).thenThrow(ServerException());
      /*
      * act */
      final result = await repository.getAiringTodayTv();
      /*
      * assert */
      verify(remoteDataSource.getAiringTodayTv());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      /*
      * arrange */
      when(remoteDataSource.getAiringTodayTv())
          .thenThrow(const SocketException('Failed to connect to the network'));
      /*
      * act */
      final result = await repository.getAiringTodayTv();
      /*
      * assert */
      verify(remoteDataSource.getAiringTodayTv());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular Tv', () {
    test('should return tv list when call to data source is success', () async {
      /*
      * arrange */
      when(remoteDataSource.getPopularTv())
          .thenAnswer((_) async => tTvModelList);
      /*
      * act */
      final result = await repository.getPopularTv();
      /*
      * assert */
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      /*
      * arrange */
      when(remoteDataSource.getPopularTv()).thenThrow(ServerException());
      /*
      * act */
      final result = await repository.getPopularTv();
      /*
      * assert */
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      /*
      * arrange */
      when(remoteDataSource.getPopularTv())
          .thenThrow(const SocketException('Failed to connect to the network'));
      /*
      * act */
      final result = await repository.getPopularTv();
      /*
      * assert */
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Tv', () {
    test('should return tv list when call to data source is successful',
        () async {
      /*
      * arrange */
      when(remoteDataSource.getTopRatedTv())
          .thenAnswer((_) async => tTvModelList);
      /*
      * act */
      final result = await repository.getTopRatedTv();
      /*
      * assert */
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      /*
      * arrange */
      when(remoteDataSource.getTopRatedTv()).thenThrow(ServerException());
      /*
      * act */
      final result = await repository.getTopRatedTv();
      /*
      * assert */
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      /*
      * arrange */
      when(remoteDataSource.getTopRatedTv())
          .thenThrow(const SocketException('Failed to connect to the network'));
      /*
      * act */
      final result = await repository.getTopRatedTv();
      /*
      * assert */
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Tv Detail', () {
    const tId = 1;
    final tTvResponse = TvDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [GenreModelTv(id: 1, name: 'Action')],
      id: 1,
      name: 'name',
      originalName: 'originalName',
      overview: 'overview',
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return Tv data when the call to remote data source is successful',
        () async {
      /*
      * arrange */
      when(remoteDataSource.getTvDetail(tId))
          .thenAnswer((_) async => tTvResponse);
      /*
      * act */
      final result = await repository.getTvDetail(tId);
      /*
      * assert */
      verify(remoteDataSource.getTvDetail(tId));
      expect(result, equals(Right(testTvDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      /*
      * arrange */
      when(remoteDataSource.getTvDetail(tId)).thenThrow(ServerException());
      /*
      * act */
      final result = await repository.getTvDetail(tId);
      /*
      * assert */
      verify(remoteDataSource.getTvDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      /*
      * arrange */
      when(remoteDataSource.getTvDetail(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      /*
      * act */
      final result = await repository.getTvDetail(tId);
      /*
      * assert */
      verify(remoteDataSource.getTvDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Tv Recommendations', () {
    final tTvList = <TvModel>[];
    const tId = 1;

    test('should return data (tv list) when the call is successful',
        () async {
      /*
      * arrange */
      when(remoteDataSource.getTvRecommendations(tId))
          .thenAnswer((_) async => tTvList);
      /*
      * act */
      final result = await repository.getTvRecommendations(tId);
      /*
      * assert */
      verify(remoteDataSource.getTvRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      /*
      * arrange */
      when(remoteDataSource.getTvRecommendations(tId))
          .thenThrow(ServerException());
      /*
      * act */
      final result = await repository.getTvRecommendations(tId);
      /*
      * assert build runner */
      verify(remoteDataSource.getTvRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      /*
      * arrange */
      when(remoteDataSource.getTvRecommendations(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      /*
      * act */
      final result = await repository.getTvRecommendations(tId);
      /*
      * assert */
      verify(remoteDataSource.getTvRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Search Tv', () {
    const tQuery = 'Arcane';

    test('should return tv list when call to data source is successful',
        () async {
      /*
      * arrange */
      when(remoteDataSource.searchTv(tQuery))
          .thenAnswer((_) async => tTvModelList);
      /*
      * act */
      final result = await repository.searchTv(tQuery);
      /*
      * assert */
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      /*
      * arrange */
      when(remoteDataSource.searchTv(tQuery)).thenThrow(ServerException());
      /*
      * act */
      final result = await repository.searchTv(tQuery);
      /*
      * assert */
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      /*
      * arrange */
      when(remoteDataSource.searchTv(tQuery))
          .thenThrow(const SocketException('Failed to connect to the network'));
      /*
      * act */
      final result = await repository.searchTv(tQuery);
      /*
      * assert */
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      /*
      * arrange */
      when(localDataSource.insertWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      /*
      * act */
      final result = await repository.saveWatchlist(testTvDetail);
      /*
      * assert */
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      /*
      * arrange */
      when(localDataSource.insertWatchlistTv(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      /*
      * act */
      final result = await repository.saveWatchlist(testTvDetail);
      /*
      * assert */
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      /*
      * arrange */
      when(localDataSource.removeWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      /*
      * act */
      final result = await repository.removeWatchlist(testTvDetail);
      /*
      * assert*/
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      /*
      * arrange*/
      when(localDataSource.removeWatchlistTv(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      /*
      * act */
      final result = await repository.removeWatchlist(testTvDetail);
      /*
      * assert */
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      /*
      * arrange */
      const tId = 1;
      when(localDataSource.getTvById(tId)).thenAnswer((_) async => null);
      /*
      * act */
      final result = await repository.isAddedToWatchlist(tId);
      /*
      * assert */
      expect(result, false);
    });
  });

  group('get watchlist tv', () {
    test('should return list of Tv', () async {
      /*
      * arrange */
      when(localDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTvTable]);
      /*
      * act */
      final result = await repository.getWatchlistTv();
      /*
      * assert */
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });
}
