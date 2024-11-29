import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_object_tv.dart';

class MockWatchlistTvBloc
    extends MockBloc<WatchlistTvEvent, WatchlistTvState>
    implements WatchlistTvBloc {}

class FakeWatchlistTvEvent extends Fake implements WatchlistTvEvent {}

class FakeWatchlistTvState extends Fake implements WatchlistTvState {}

void main() {
  late MockWatchlistTvBloc mockWatchlistTvBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistTvEvent());
    registerFallbackValue(FakeWatchlistTvState());
  });

  setUp(() {
    mockWatchlistTvBloc = MockWatchlistTvBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvBloc>.value(
      value: mockWatchlistTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockWatchlistTvBloc.state)
        .thenReturn(WatchlistTvLoading());

    /*
    * act */
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const WatchlistTvPage()));

    /*
    * assert */
    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockWatchlistTvBloc.state)
        .thenReturn(WatchlistTvHasData(testTvList));

    /*
    * act */
    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const WatchlistTvPage()));

    /*
    * assert */
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockWatchlistTvBloc.state)
        .thenReturn(WatchlistTvError('Error message'));

    /*
    * act */
    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistTvPage()));

    /*
    * assert */
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text when data is empty',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockWatchlistTvBloc.state).thenReturn(WatchlistTvEmpty());

    /*
    * act */
    final textErrorBarFinder = find.text('You do not have a Watchlist yet.');

    await tester.pumpWidget(makeTestableWidget(const WatchlistTvPage()));

    /*
    * assert */
    expect(textErrorBarFinder, findsOneWidget);
  });
}
