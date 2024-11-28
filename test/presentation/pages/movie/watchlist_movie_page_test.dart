import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../dummy_data/dummy_objects.dart';

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

class FakeWatchlistMovieEvent extends Fake implements WatchlistMovieEvent {}

class FakeWatchlistMovieState extends Fake implements WatchlistMovieState {}

void main() {
  late MockWatchlistMovieBloc mockWatchlistMovieBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistMovieEvent());
    registerFallbackValue(FakeWatchlistMovieState());
  });

  setUp(() {
    mockWatchlistMovieBloc = MockWatchlistMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMovieBloc>.value(
      value: mockWatchlistMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockWatchlistMovieBloc.state)
        .thenReturn(WatchlistMovieLoading());

    /*
    * act */
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    /*
    * assert */
    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockWatchlistMovieBloc.state)
        .thenReturn(WatchlistMovieHasData(testMovieList));

    /*
    * act */
    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    /*
    * assert */
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockWatchlistMovieBloc.state)
        .thenReturn(WatchlistMovieError('Error message'));

    /*
    * act */
    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    /*
    * assert */
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text when data is empty',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockWatchlistMovieBloc.state).thenReturn(WatchlistMovieEmpty());

    /*
    * act */
    final textErrorBarFinder = find.text('You do not have a Watchlist yet.');

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    /*
    * assert */
    expect(textErrorBarFinder, findsOneWidget);
  });
}
