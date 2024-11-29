part of 'popular_tv_bloc.dart';

abstract class PopularTvEvent extends Equatable {
  const PopularTvEvent();
}

class FetchPopularTv extends PopularTvEvent {
  @override
  List<Object> get props => [];
}