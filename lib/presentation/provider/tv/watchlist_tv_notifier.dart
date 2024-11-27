import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/entity/tv/tv.dart';
import '../../../domain/usecases/tv/get_watchlist_tv.dart';

class WatchlistTvNotifier extends ChangeNotifier {
  final GetWatchlistTv getWatchlistTv;

  WatchlistTvNotifier({required this.getWatchlistTv});

  var _watchlistTv = <Tv>[];

  List<Tv> get watchlistTv => _watchlistTv;

  var _watchlistState = RequestState.empty;

  RequestState get watchlistState => _watchlistState;

  String _message = '';

  String get message => _message;

  Future<void> fetchWatchlistTv() async {
    _watchlistState = RequestState.loading;
    notifyListeners();

    final result = await getWatchlistTv.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _watchlistState = RequestState.loaded;
        _watchlistTv = data;
        notifyListeners();
      },
    );
  }
}
