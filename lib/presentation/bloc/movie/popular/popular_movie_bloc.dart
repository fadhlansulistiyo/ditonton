import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'popular_movie_event.dart';
part 'popular_movie_state.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  PopularMovieBloc() : super(PopularMovieInitial()) {
    on<PopularMovieEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
