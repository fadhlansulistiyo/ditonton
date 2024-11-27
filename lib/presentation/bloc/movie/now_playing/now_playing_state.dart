part of 'now_playing_bloc.dart';

sealed class NowPlayingState extends Equatable {
  const NowPlayingState();
  
  @override
  List<Object?> get props => [];
}

class NowPlayingEmpty extends NowPlayingState {}

class NowPlayingLoading extends NowPlayingState {}

class NowPlayingError extends NowPlayingState {
  final String message;

  NowPlayingError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingHasData extends NowPlayingState {
  final List<Movie> result;

  NowPlayingHasData(this.result);

  @override
  List<Object> get props => [result];
}