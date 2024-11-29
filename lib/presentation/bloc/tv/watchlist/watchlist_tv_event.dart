part of 'watchlist_tv_bloc.dart';

abstract class WatchlistTvEvent extends Equatable {
  const WatchlistTvEvent();
}

class FetchWatchlistTv extends WatchlistTvEvent {
  const FetchWatchlistTv();

  @override
  List<Object> get props => [];
}
