import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_airing_today_tv.dart';
import 'package:flutter/foundation.dart';

class AiringTodayTvNotifier extends ChangeNotifier {
  final GetAiringTodayTv getAiringTodayTv;

  AiringTodayTvNotifier({required this.getAiringTodayTv});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<Tv> _tv = [];

  List<Tv> get tv => _tv;

  String _message = '';

  String get message => _message;

  Future<void> fetchAiringTodayTv() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getAiringTodayTv.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvData) {
        _tv = tvData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
