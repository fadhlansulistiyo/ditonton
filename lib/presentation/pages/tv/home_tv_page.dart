import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/search_page_tv.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_page.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/tv/tv_list_notifier.dart';
import '../../widgets/tv_list.dart';
import '../about/about_page.dart';
import '../movie/watchlist_movies_page.dart';
import 'airing_today_tv_page.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-page';

  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TvListNotifier>()
          ..fetchAiringTodayTv()
          ..fetchPopularTv()
          ..fetchTopRatedTv();
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
                  Navigator.pushNamed(context, AiringTodayTvPage.ROUTE_NAME);
                },
              ),
              _buildAiringTodayTv(),
              _buildSubHeading(
                title: 'Popular Tv Series',
                onTap: () {
                  Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME);
                },
              ),
              _buildPopularTv(),
              _buildSubHeading(
                title: 'Top Rated Series',
                onTap: () {
                  Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME);
                },
              ),
              _buildTopRatedTv(),
            ],
          ),
        ),
      ),
    );
  }

  Consumer<TvListNotifier> _buildTopRatedTv() {
    return Consumer<TvListNotifier>(builder: (context, data, child) {
      final state = data.topRatedTvState;
      if (state == RequestState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state == RequestState.Loaded) {
        return TvList(data.topRatedTv);
      } else {
        return const Text('Failed');
      }
    });
  }

  Consumer<TvListNotifier> _buildPopularTv() {
    return Consumer<TvListNotifier>(builder: (context, data, child) {
      final state = data.popularTvState;
      if (state == RequestState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state == RequestState.Loaded) {
        return TvList(data.popularTv);
      } else {
        return const Text('Failed');
      }
    });
  }

  Consumer<TvListNotifier> _buildAiringTodayTv() {
    return Consumer<TvListNotifier>(builder: (context, data, child) {
      final state = data.airingTodayState;
      if (state == RequestState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state == RequestState.Loaded) {
        return TvList(data.airingTodayTv);
      } else {
        return const Text('Failed');
      }
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Tv Series'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, SearchPageTv.ROUTE_NAME);
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
              Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmarks_rounded),
            title: const Text('Watchlist Tv Series'),
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
