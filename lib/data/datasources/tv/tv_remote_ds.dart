import '../../models/tv/tv_detail_model.dart';
import '../../models/tv/tv_model.dart';

abstract class TvRemoteDataSource {
  Future<List<TvModel>> getAiringTodayTv();
  Future<List<TvModel>> getPopularTv();
  Future<List<TvModel>> getTopRatedTv();
  Future<TvDetailResponse> getTvDetail(int id);
  Future<List<TvModel>> getTvRecommendations(int id);
  Future<List<TvModel>> searchTv(String query);
}