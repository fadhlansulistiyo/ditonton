part of 'airing_today_bloc.dart';

abstract class AiringTodayEvent extends Equatable {
  const AiringTodayEvent();
}

class FetchAiringTodayTv extends AiringTodayEvent {
  @override
  List<Object> get props => [];
}