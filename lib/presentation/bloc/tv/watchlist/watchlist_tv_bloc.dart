import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entity/tv/tv.dart';
import '../../../../domain/usecases/tv/get_watchlist_tv.dart';

part 'watchlist_tv_event.dart';

part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv _getWatchlistTv;

  WatchlistTvBloc(this._getWatchlistTv) : super(WatchlistTvEmpty()) {
    on<FetchWatchlistTv>((event, emit) async {
      emit(WatchlistTvLoading());

      final result = await _getWatchlistTv.execute();

      result.fold(
        (failure) => emit(WatchlistTvError(failure.message)),
        (data) {
          if (data.isEmpty) {
            emit(WatchlistTvEmpty());
          } else {
            emit(WatchlistTvHasData(data));
          }
        },
      );
    });
  }
}
