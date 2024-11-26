import 'dart:convert';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv/tv_remote_ds_impl.dart';
import 'package:ditonton/data/models/tv/tv_detail_model.dart';
import 'package:ditonton/data/models/tv/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Airing Today Tv', () {
    final tTvList = TvResponse.fromJson(
            json.decode(readJson('dummy_data/airing_today_tv.json')))
        .tvList;

    test('should return list of Tv Model when the response code is 200',
        () async {
      /*
      * arrange */
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/airing_today?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/airing_today_tv.json'), 200));
      /*
      * act */
      final result = await dataSource.getAiringTodayTv();
      /*
      * assert */
      expect(result, equals(tTvList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      /*
      * arrange */
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/airing_today?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      /*
      * act */
      final call = dataSource.getAiringTodayTv();
      /*
      * assert */
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Tv', () {
    final tTvList =
        TvResponse.fromJson(json.decode(readJson('dummy_data/popular_tv.json')))
            .tvList;

    test('should return list of tv when response is success (200)', () async {
      /*
      * arrange */
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/popular_tv.json'), 200));
      /*
      * act */
      final result = await dataSource.getPopularTv();
      /*
      * assert */
      expect(result, tTvList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      /*
      * arrange */
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      /*
      * act */
      final call = dataSource.getPopularTv();
      /*
      * assert */
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated Tv', () {
    final tTvList = TvResponse.fromJson(
            json.decode(readJson('dummy_data/top_rated_tv.json')))
        .tvList;

    test('should return list of tv when response code is 200 ', () async {
      /*
      * arrange */
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/top_rated_tv.json'), 200));
      /*
      * act */
      final result = await dataSource.getTopRatedTv();
      /*
      * assert */
      expect(result, tTvList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      /*
      * arrange */
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      /*
      * act */
      final call = dataSource.getTopRatedTv();
      /*
      * assert */
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv detail', () {
    const tId = 1;
    final tTvDetail = TvDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_detail.json')));

    test('should return tv detail when the response code is 200', () async {
      /*
      * arrange */
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_detail.json'), 200));
      /*
      * act */
      final result = await dataSource.getTvDetail(tId);
      /*
      * assert */
      expect(result, equals(tTvDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      /*
      * arrange */
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      /*
      * act */
      final call = dataSource.getTvDetail(tId);
      /*
      * assert */
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv recommendations', () {
    final tTvList = TvResponse.fromJson(
            json.decode(readJson('dummy_data/tv_recommendations.json')))
        .tvList;
    const tId = 1;

    test('should return list of Tv Model when the response code is 200',
        () async {
      /*
      * arrange */
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_recommendations.json'), 200));
      /*
      * act */
      final result = await dataSource.getTvRecommendations(tId);
      /*
      * assert */
      expect(result, equals(tTvList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      /*
      * arrange*/
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      /*
      * act */
      final call = dataSource.getTvRecommendations(tId);
      /*
      * assert */
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tv', () {
    final tSearchResult = TvResponse.fromJson(
            json.decode(readJson('dummy_data/search_arcane.json')))
        .tvList;
    const tQuery = 'Arcane';

    test('should return list of tv when response code is 200', () async {
      /*
      * arrange */
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_arcane.json'), 200));
      /*
      * act */
      final result = await dataSource.searchTv(tQuery);
      /*
      * assert */
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      /*
      * arrange */
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      /*
      * act */
      final call = dataSource.searchTv(tQuery);
      /*
      * assert */
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
