import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/tv/get_airing_today_tv.dart';

part 'airing_today_event.dart';

part 'airing_today_state.dart';

class AiringTodayBloc extends Bloc<AiringTodayEvent, AiringTodayState> {
  final GetAiringTodayTv _getAiringTodayTv;

  AiringTodayBloc(this._getAiringTodayTv) : super(AiringTodayEmpty()) {
    on<FetchAiringTodayTv>(
      (event, emit) async {
        emit(AiringTodayLoading());
        final result = await _getAiringTodayTv.execute();

        result.fold(
          (failure) {
            emit(AiringTodayError(failure.message));
          },
          (data) {
            emit(AiringTodayHasData(data));
          },
        );
      },
    );
  }
}
