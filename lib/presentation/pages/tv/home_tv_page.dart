import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/tv/airing_today/airing_today_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/search_page_tv.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/tv_list.dart';
import '../about/about_page.dart';
import '../movie/watchlist_movies_page.dart';
import 'airing_today_tv_page.dart';

class HomeTvPage extends StatefulWidget {
  static const routeName = '/tv-page';

  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AiringTodayBloc>().add(FetchAiringTodayTv());
        context.read<PopularTvBloc>().add(FetchPopularTv());
        context.read<TopRatedTvBloc>().add(FetchTopRatedTv());
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
              _buildSubHeading(
                title: 'Airing Today Tv',
                onTap: () {
                  Navigator.pushNamed(context, AiringTodayTvPage.routeName);
                },
              ),
              _buildAiringTodayTv(),
              _buildSubHeading(
                title: 'Popular Tv Series',
                onTap: () {
                  Navigator.pushNamed(context, PopularTvPage.routeName);
                },
              ),
              _buildPopularTv(),
              _buildSubHeading(
                title: 'Top Rated Series',
                onTap: () {
                  Navigator.pushNamed(context, TopRatedTvPage.routeName);
                },
              ),
              _buildTopRatedTv(),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<AiringTodayBloc, AiringTodayState> _buildAiringTodayTv() {
    return BlocBuilder<AiringTodayBloc, AiringTodayState>(
      builder: (context, state) {
        if (state is AiringTodayLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AiringTodayHasData) {
          return TvList(state.result);
        } else if (state is AiringTodayError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return Container();
        }
      },
    );
  }

  BlocBuilder<PopularTvBloc, PopularTvState> _buildPopularTv() {
    return BlocBuilder<PopularTvBloc, PopularTvState>(
      builder: (context, state) {
        if (state is PopularTvLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PopularTvHasData) {
          return TvList(state.result);
        } else if (state is PopularTvError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return Container();
        }
      },
    );
  }

  BlocBuilder<TopRatedTvBloc, TopRatedTvState> _buildTopRatedTv() {
    return BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
      builder: (context, state) {
        if (state is TopRatedTvLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TopRatedTvHasData) {
          return TvList(state.result);
        } else if (state is TopRatedTvError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return Container();
        }
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Tv Series'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, SearchPageTv.routeName);
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
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Tv Series'),
            onTap: () {
              Navigator.pop(context);
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
