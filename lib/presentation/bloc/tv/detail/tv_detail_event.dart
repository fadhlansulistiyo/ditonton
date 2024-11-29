part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();
}

/*
* Fetch tv detail */
class FetchTvDetail extends TvDetailEvent {
  final int id;

  const FetchTvDetail(this.id);

  @override
  List<Object?> get props => [id];
}

/*
* Load watchlist status */
class LoadWatchlistStatusTv extends TvDetailEvent {
  final int id;

  const LoadWatchlistStatusTv(this.id);

  @override
  List<Object?> get props => [id];
}

/*
* Add tv to watchlist */
class AddWatchlistTv extends TvDetailEvent {
  final TvDetail tvDetail;

  const AddWatchlistTv(this.tvDetail);

  @override
  List<Object?> get props => [tvDetail];
}

/*
* Remove tv from watchlist */
class RemoveFromWatchlistTv extends TvDetailEvent {
  final TvDetail tvDetail;

  const RemoveFromWatchlistTv(this.tvDetail);

  @override
  List<Object?> get props => [tvDetail];
}