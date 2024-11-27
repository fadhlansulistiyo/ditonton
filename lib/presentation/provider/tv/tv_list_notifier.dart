import 'package:ditonton/domain/usecases/tv/get_airing_today_tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:flutter/material.dart';
import '../../../common/state_enum.dart';
import '../../../domain/entity/tv/tv.dart';

class TvListNotifier extends ChangeNotifier {
  final GetAiringTodayTv getAiringTodayTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  TvListNotifier({
    required this.getAiringTodayTv,
    required this.getPopularTv,
    required this.getTopRatedTv,
  });

  var _airingTodayTv = <Tv>[];

  List<Tv> get airingTodayTv => _airingTodayTv;

  RequestState _airingTodayState = RequestState.empty;

  RequestState get airingTodayState => _airingTodayState;

  var _popularTv = <Tv>[];

  List<Tv> get popularTv => _popularTv;

  RequestState _popularTvState = RequestState.empty;

  RequestState get popularTvState => _popularTvState;

  var _topRatedTv = <Tv>[];

  List<Tv> get topRatedTv => _topRatedTv;

  RequestState _topRatedTvState = RequestState.empty;

  RequestState get topRatedTvState => _topRatedTvState;

  String _message = '';

  String get message => _message;

  Future<void> fetchAiringTodayTv() async {
    _airingTodayState = RequestState.loading;
    notifyListeners();

    final result = await getAiringTodayTv.execute();
    result.fold(
      (failure) {
        _airingTodayState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _airingTodayState = RequestState.loaded;
        _airingTodayTv = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTv() async {
    _popularTvState = RequestState.loading;
    notifyListeners();

    final result = await getPopularTv.execute();
    result.fold((failure) {
      _popularTvState = RequestState.error;
      _message = failure.message;
      notifyListeners();
    }, (tvData) {
      _popularTvState = RequestState.loaded;
      _popularTv = tvData;
      notifyListeners();
    });
  }

  Future<void> fetchTopRatedTv() async {
    _topRatedTvState = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedTv.execute();
    result.fold(
      (failure) {
        _topRatedTvState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _topRatedTvState = RequestState.loaded;
        _topRatedTv = tvData;
        notifyListeners();
      },
    );
  }
}
