import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/state_enum.dart';
import '../../../../domain/entity/tv/tv.dart';
import '../../../../domain/entity/tv/tv_detail.dart';
import '../../../../domain/usecases/tv/get_tv_detail.dart';
import '../../../../domain/usecases/tv/get_tv_recommendations.dart';
import '../../../../domain/usecases/tv/get_watchlist_status.dart';
import '../../../../domain/usecases/tv/remove_watchlist.dart';
import '../../../../domain/usecases/tv/save_watchlist.dart';

part 'tv_detail_event.dart';

part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getRecommendationTv;
  final SaveWatchlist saveWatchlistTv;
  final RemoveWatchlist removeWatchlistTv;
  final GetWatchListStatus getWatchListStatusTv;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getRecommendationTv,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
    required this.getWatchListStatusTv,
  }) : super(TvDetailState.initial()) {
    /*
    * Fetch Tv Detail */
    on<FetchTvDetail>((event, emit) async {
      emit(state.copyWith(tvDetailState: RequestState.loading));

      final id = event.id;
      final detailTvResult = await getTvDetail.execute(id);
      final recommendationTvResult = await getRecommendationTv.execute(id);

      detailTvResult.fold(
        (failure) => emit(
          state.copyWith(
            tvDetailState: RequestState.error,
            message: failure.message,
          ),
        ),
        (tvDetail) {
          emit(
            state.copyWith(
              tvRecommendationsState: RequestState.loading,
              tvDetailState: RequestState.loaded,
              tvDetail: tvDetail,
              watchlistMessage: '',
            ),
          );
          recommendationTvResult.fold(
            (failure) => emit(
              state.copyWith(
                tvRecommendationsState: RequestState.error,
                message: failure.message,
              ),
            ),
            (tvRecommendations) {
              if (tvRecommendations.isEmpty) {
                emit(
                  state.copyWith(
                    tvRecommendationsState: RequestState.empty,
                  ),
                );
              } else {
                emit(
                  state.copyWith(
                    tvRecommendationsState: RequestState.loaded,
                    tvRecommendations: tvRecommendations,
                  ),
                );
              }
            },
          );
        },
      );
    });

    /*
    * Check watchlist tv status */
    on<LoadWatchlistStatusTv>((event, emit) async {
      final status = await getWatchListStatusTv.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status));
    });

    /*
    * Add tv to watchlist */
    on<AddWatchlistTv>((event, emit) async {
      final tvDetail = event.tvDetail;
      final result = await saveWatchlistTv.execute(tvDetail);

      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusTv(tvDetail.id));
    });

    /*
    * Remove tv from watchlist */
    on<RemoveFromWatchlistTv>((event, emit) async {
      final tvDetail = event.tvDetail;
      final result = await removeWatchlistTv.execute(tvDetail);

      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusTv(tvDetail.id));
    });
  }
}
