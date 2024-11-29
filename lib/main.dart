import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing/now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/airing_today/airing_today_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/search/search_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/about/about_page.dart';
import 'package:ditonton/presentation/pages/movie/home_movie_page.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/search_movie_page.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv/airing_today_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/home_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/search_page_tv.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'common/constants.dart';
import 'common/utils.dart';
import 'data/helper/http_ssl_pinning.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HttpSSLPinning.init();
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /*
        * Movies 
        * */
        BlocProvider(
          create: (_) => di.locator<NowPlayingBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMovieBloc>(),
        ),
        /*
        * Tv Series 
        * */
        BlocProvider(
          create: (_) => di.locator<AiringTodayBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTvBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Ditonton',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case SearchMoviePage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => const SearchMoviePage());
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => const PopularMoviesPage());
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedMoviesPage());
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case WatchlistMoviesPage.routeName:
              return MaterialPageRoute(
                  builder: (_) => const WatchlistMoviesPage());
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            /*
            Tv Series
            */
            case HomeTvPage.routeName:
              return CupertinoPageRoute(builder: (_) => HomeTvPage());
            case SearchPageTv.routeName:
              return CupertinoPageRoute(builder: (_) => const SearchPageTv());
            case AiringTodayTvPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => const AiringTodayTvPage());
            case PopularTvPage.routeName:
              return CupertinoPageRoute(builder: (_) => const PopularTvPage());
            case TopRatedTvPage.routeName:
              return CupertinoPageRoute(builder: (_) => const TopRatedTvPage());
            case WatchlistTvPage.routeName:
              return MaterialPageRoute(builder: (_) => const WatchlistTvPage());
            case TvDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
