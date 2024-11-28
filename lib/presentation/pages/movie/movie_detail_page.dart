import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../domain/entity/movie/genre.dart';
import '../../../domain/entity/movie/movie.dart';
import '../../../domain/entity/movie/movie_detail.dart';
import '../../bloc/movie/detail/movie_detail_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/detail-movie';
  final int id;

  const MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<MovieDetailBloc>()
          ..add(FetchMovieDetail(widget.id))
          ..add(LoadWatchlistStatusMovie(widget.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        key: GlobalKey<ScaffoldState>(),
        body: BlocConsumer<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            final movieDetailState = state.movieDetailState;
            if (movieDetailState == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (movieDetailState == RequestState.loaded) {
              return SafeArea(
                child: DetailContent(
                  state.movieDetail!,
                  state.movieRecommendations,
                  state.isAddedToWatchlist,
                ),
              );
            } else if (movieDetailState == RequestState.error) {
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
            if (message == MovieDetailBloc.watchlistAddSuccessMessage ||
                message == MovieDetailBloc.watchlistRemoveSuccessMessage) {
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
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(this.movie, this.recommendations, this.isAddedWatchlist,
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
        Text(movie.title, style: kHeading5),
        _watchlistButton(context, isAddedToWatchlist, movie),
        _buildDetailElement(),
        Text('Recommendations', style: kHeading6),
        _buildRecommendationList(),
      ],
    );
  }

  FilledButton _watchlistButton(
      BuildContext context, bool isAddedToWatchlist, MovieDetail movie) {
    return FilledButton(
      key: const Key('watchlistButton'),
      onPressed: () {
        final bloc = context.read<MovieDetailBloc>();
        if (!isAddedWatchlist) {
          bloc.add(AddWatchlistMovie(movie));
        } else {
          bloc.add(RemoveFromWatchlistMovie(movie));
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
        Text(_showGenres(movie.genres)),
        Text(_showDuration(movie.runtime)),
        // Vote average
        Row(
          children: [
            RatingBarIndicator(
              rating: movie.voteAverage / 2,
              itemCount: 5,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: kMikadoYellow,
              ),
              itemSize: 24,
            ),
            Text('${movie.voteAverage}')
          ],
        ),
        const SizedBox(height: 16),
        Text('Overview', style: kHeading6),
        Text(movie.overview),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRecommendationList() {
    return BlocBuilder<MovieDetailBloc, MovieDetailState>(
      builder: (context, state) {
        final recommendationsState = state.movieRecommendationsState;
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
                final movie = recommendations[index];
                return _buildRecommendationItem(context, movie);
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

  Padding _buildRecommendationItem(BuildContext context, Movie movie) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(
            context,
            MovieDetailPage.routeName,
            arguments: movie.id,
          );
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          child: CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
          key: const Key('backButton'),
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
      imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
      width: screenWidth,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }
    if (result.isEmpty) {
      return result;
    }
    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
