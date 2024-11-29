part of 'top_rated_tv_bloc.dart';

abstract class TopRatedTvEvent extends Equatable {
  const TopRatedTvEvent();
}

class FetchTopRatedTv extends TopRatedTvEvent {
  @override
  List<Object> get props => [];
}