import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/search_page.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv/home_tv_page.dart';
import 'package:ditonton/presentation/provider/movie/movie_list_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        context.read<MovieListNotifier>()
          ..fetchNowPlayingMovies()
          ..fetchPopularMovies()
          ..fetchTopRatedMovies();
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
                  Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME);
                },
              ),
              _buildPopularMovies(),
              _buildSubHeading(
                title: 'Top Rated Movies',
                onTap: () {
                  Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME);
                },
              ),
              _buildTopRatedMovies(),
            ],
          ),
        ),
      ),
    );
  }

  Consumer<MovieListNotifier> _buildTopRatedMovies() {
    return Consumer<MovieListNotifier>(builder: (context, data, child) {
      final state = data.topRatedMoviesState;
      if (state == RequestState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state == RequestState.Loaded) {
        return MovieList(data.topRatedMovies);
      } else {
        return const Text('Failed');
      }
    });
  }

  Consumer<MovieListNotifier> _buildPopularMovies() {
    return Consumer<MovieListNotifier>(builder: (context, data, child) {
      final state = data.popularMoviesState;
      if (state == RequestState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state == RequestState.Loaded) {
        return MovieList(data.popularMovies);
      } else {
        return const Text('Failed');
      }
    });
  }

  Consumer<MovieListNotifier> _buildNowPlayingMovies() {
    return Consumer<MovieListNotifier>(builder: (context, data, child) {
      final state = data.nowPlayingState;
      if (state == RequestState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state == RequestState.Loaded) {
        return MovieList(data.nowPlayingMovies);
      } else {
        return const Text('Failed');
      }
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Movies'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
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
              Navigator.pushReplacementNamed(context, HomeTvPage.ROUTE_NAME);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmarks_rounded),
            title: const Text('Watchlist Movie'),
            onTap: () {
              Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmarks_rounded),
            title: const Text('Watchlist Tv'),
            onTap: () {
              Navigator.pushNamed(context, WatchlistTvPage.ROUTE_NAME);
            },
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
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
