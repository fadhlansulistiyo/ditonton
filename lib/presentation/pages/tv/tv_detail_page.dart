import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entity/tv/genre_tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../domain/entity/tv/tv.dart';
import '../../../domain/entity/tv/tv_detail.dart';
import '../../provider/tv/tv_detail_notifier.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv';

  final int id;

  const TvDetailPage({super.key, required this.id});

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TvDetailNotifier>()
          ..fetchTvDetail(widget.id)
          ..loadWatchlistStatus(widget.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.tvState == RequestState.Loaded) {
            final tv = provider.tv;
            return SafeArea(
              child: DetailContent(
                tv,
                provider.tvRecommendations,
                provider.isAddedToWatchlist,
              ),
            );
          } else {
            return Text(provider.message);
          }
        },
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
                        child: _buildDetailColumn(context),
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

  Column _buildDetailColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(tv.name, style: kHeading5),
        _watchlistButton(context),
        Text(_showGenres(tv.genres)),
        // Vote average
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
        Text('Recommendations', style: kHeading6),
        _buildRecommendationList(),
      ],
    );
  }

  Consumer<TvDetailNotifier> _buildRecommendationList() {
    return Consumer<TvDetailNotifier>(
      builder: (context, data, child) {
        if (data.recommendationState == RequestState.Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.recommendationState == RequestState.Error) {
          return Text(data.message);
        } else if (data.recommendationState == RequestState.Loaded) {
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
        } else {
          return Container();
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
            TvDetailPage.ROUTE_NAME,
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

  FilledButton _watchlistButton(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        if (!isAddedWatchlist) {
          await context.read<TvDetailNotifier>().addWatchlist(tv);
        } else {
          await context.read<TvDetailNotifier>().removeFromWatchlist(tv);
        }
        if (context.mounted) {
          final message = context.read<TvDetailNotifier>().watchlistMessage;
          if (message == TvDetailNotifier.watchlistAddSuccessMessage ||
              message == TvDetailNotifier.watchlistRemoveSuccessMessage) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(message),
                );
              },
            );
          }
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isAddedWatchlist ? const Icon(Icons.check) : const Icon(Icons.add),
          const Text('Watchlist'),
        ],
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
