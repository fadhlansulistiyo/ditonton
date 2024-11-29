import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entity/tv/tv.dart';
import '../../../../domain/usecases/tv/get_top_rated_tv.dart';

part 'top_rated_tv_event.dart';

part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTv _getTopRatedTv;

  TopRatedTvBloc(this._getTopRatedTv) : super(TopRatedTvEmpty()) {
    on<FetchTopRatedTv>(
      (event, emit) async {
        emit(TopRatedTvLoading());
        final result = await _getTopRatedTv.execute();

        result.fold(
          (failure) {
            emit(TopRatedTvError(failure.message));
          },
          (data) {
            emit(TopRatedTvHasData(data));
          },
        );
      },
    );
  }
}
