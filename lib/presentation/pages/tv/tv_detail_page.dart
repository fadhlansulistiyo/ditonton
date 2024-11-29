import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entity/tv/genre_tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../domain/entity/tv/tv.dart';
import '../../../domain/entity/tv/tv_detail.dart';
import '../../bloc/tv/detail/tv_detail_bloc.dart';

class TvDetailPage extends StatefulWidget {
  static const routeName = '/detail-tv';

  final int id;

  const TvDetailPage({super.key, required this.id});

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TvDetailBloc>()
          ..add(FetchTvDetail(widget.id))
          ..add(LoadWatchlistStatusTv(widget.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        key: GlobalKey<ScaffoldState>(),
        body: BlocConsumer<TvDetailBloc, TvDetailState>(
          builder: (context, state) {
            final tvDetailState = state.tvDetailState;
            if (tvDetailState == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (tvDetailState == RequestState.loaded) {
              return SafeArea(
                child: DetailContent(
                  state.tvDetail!,
                  state.tvRecommendations,
                  state.isAddedToWatchlist,
                ),
              );
            } else if (tvDetailState == RequestState.error) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
          listener: (context, state) {
            final message = state.watchlistMessage;
            if (message == TvDetailBloc.watchlistAddSuccessMessage ||
                message == TvDetailBloc.watchlistRemoveSuccessMessage) {
              _scaffoldMessengerKey.currentState!.showSnackBar(
                SnackBar(
                  content: Text(message),
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: Text(message),
                  );
                },
              );
            }
          },
          listenWhen: (oldState, newState) {
            return oldState.watchlistMessage != newState.watchlistMessage &&
                newState.watchlistMessage != '';
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(this.tv, this.recommendations, this.isAddedWatchlist,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        _buildPoster(screenWidth),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: _buildDetailColumn(context, isAddedWatchlist),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _buildBackButton(context)
      ],
    );
  }

  Column _buildDetailColumn(BuildContext context, bool isAddedToWatchlist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(tv.name, style: kHeading5),
        _watchlistButton(context, isAddedToWatchlist, tv),
        _buildDetailElement(),
        Text('Recommendations', style: kHeading6),
        _buildRecommendationList(),
      ],
    );
  }

  FilledButton _watchlistButton(
      BuildContext context, bool isAddedToWatchlist, TvDetail tv) {
    return FilledButton(
      key: const Key('watchlistButton'),
      onPressed: () {
        final bloc = context.read<TvDetailBloc>();
        if (!isAddedWatchlist) {
          bloc.add(AddWatchlistTv(tv));
        } else {
          bloc.add(RemoveFromWatchlistTv(tv));
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isAddedToWatchlist ? const Icon(Icons.check) : const Icon(Icons.add),
          const Text('Watchlist'),
        ],
      ),
    );
  }

  Column _buildDetailElement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_showGenres(tv.genres)),
        Row(
          children: [
            RatingBarIndicator(
              rating: tv.voteAverage / 2,
              itemCount: 5,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: kMikadoYellow,
              ),
              itemSize: 24,
            ),
            Text('${tv.voteAverage}')
          ],
        ),
        const SizedBox(height: 16),
        Text('Overview', style: kHeading6),
        Text(tv.overview),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRecommendationList() {
    return BlocBuilder<TvDetailBloc, TvDetailState>(
      builder: (context, state) {
        final recommendationsState = state.tvRecommendationsState;
        if (recommendationsState == RequestState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (recommendationsState == RequestState.loaded) {
          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final tv = recommendations[index];
                return _buildRecommendationItem(context, tv);
              },
              itemCount: recommendations.length,
            ),
          );
        } else if (recommendationsState == RequestState.error) {
          return Text(state.message);
        } else {
          return const Text('No recommendations available.');
        }
      },
    );
  }

  Padding _buildRecommendationItem(BuildContext context, Tv tv) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(
            context,
            TvDetailPage.routeName,
            arguments: tv.id,
          );
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          child: CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Padding _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: kRichBlack,
        foregroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  CachedNetworkImage _buildPoster(double screenWidth) {
    return CachedNetworkImage(
      imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
      width: screenWidth,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  String _showGenres(List<GenreTv> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }
    if (result.isEmpty) {
      return result;
    }
    return result.substring(0, result.length - 2);
  }
}
