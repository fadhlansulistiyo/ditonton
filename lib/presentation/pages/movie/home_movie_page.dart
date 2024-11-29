import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing/now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/search_movie_page.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv/home_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/movie/popular/popular_movie_bloc.dart';
import '../../widgets/movie_list.dart';
import '../tv/watchlist_tv_page.dart';
import '../about/about_page.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<NowPlayingBloc>().add(FetchNowPlayingMovie());
        context.read<PopularMovieBloc>().add(FetchPopularMovie());
        context.read<TopRatedMovieBloc>().add(FetchTopRatedMovie());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              // Now Playing Movies
              _buildNowPlayingMovies(),
              _buildSubHeading(
                title: 'Popular Movies',
                onTap: () {
                  Navigator.pushNamed(context, PopularMoviesPage.routeName);
                },
              ),
              _buildPopularMovies(),
              _buildSubHeading(
                title: 'Top Rated Movies',
                onTap: () {
                  Navigator.pushNamed(context, TopRatedMoviesPage.routeName);
                },
              ),
              _buildTopRatedMovies(),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<NowPlayingBloc, NowPlayingState> _buildNowPlayingMovies() {
    return BlocBuilder<NowPlayingBloc, NowPlayingState>(
      builder: (context, state) {
        if (state is NowPlayingLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is NowPlayingHasData) {
          return MovieList(state.result);
        } else if (state is NowPlayingError) {
          return Expanded(
            child: Center(
              child: Text(state.message),
            ),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }

  BlocBuilder<PopularMovieBloc, PopularMovieState> _buildPopularMovies() {
    return BlocBuilder<PopularMovieBloc, PopularMovieState>(
      builder: (context, state) {
        if (state is PopularMovieLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PopularMovieHasData) {
          return MovieList(state.result);
        } else if (state is PopularMovieError) {
          return Expanded(
            child: Center(
              child: Text(state.message),
            ),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }

  BlocBuilder<TopRatedMovieBloc, TopRatedMovieState> _buildTopRatedMovies() {
    return BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
      builder: (context, state) {
        if (state is TopRatedMovieLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TopRatedMovieHasData) {
          return MovieList(state.result);
        } else if (state is TopRatedMovieError) {
          return Expanded(
            child: Center(
              child: Text(state.message),
            ),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Movies'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, SearchMoviePage.routeName);
          },
          icon: const Icon(Icons.search),
        )
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: const AssetImage('assets/circle-g.png'),
              backgroundColor: Colors.grey.shade900,
            ),
            accountName: const Text('Ditonton'),
            accountEmail: const Text('ditonton@dicoding.com'),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Movies'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.tv),
            title: const Text('Tv Series'),
            onTap: () {
              Navigator.pushReplacementNamed(context, HomeTvPage.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmarks_rounded),
            title: const Text('Watchlist Movie'),
            onTap: () {
              Navigator.pushNamed(context, WatchlistMoviesPage.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmarks_rounded),
            title: const Text('Watchlist Tv Series'),
            onTap: () {
              Navigator.pushNamed(context, WatchlistTvPage.routeName);
            },
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, AboutPage.routeName);
            },
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
          ),
        ],
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}
