part of 'now_playing_bloc.dart';

sealed class NowPlayingEvent extends Equatable {
  const NowPlayingEvent();
}

class FetchNowPlayingMovie extends NowPlayingEvent {
  @override
  List<Object> get props => [];
}
