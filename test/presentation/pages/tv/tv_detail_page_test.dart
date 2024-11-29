import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/presentation/bloc/tv/detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_object_tv.dart';

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

class FakeTvDetailEvent extends Fake implements TvDetailEvent {}

class FakeTvDetailState extends Fake implements TvDetailState {}

void main() {
  late MockTvDetailBloc mockTvDetailBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvDetailEvent());
    registerFallbackValue(FakeTvDetailState());
  });

  setUp(() {
    mockTvDetailBloc = MockTvDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>.value(
      value: mockTvDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const tId = 1;

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockTvDetailBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: RequestState.loaded,
        tvDetail: testTvDetail,
        tvRecommendationsState: RequestState.loaded,
        tvRecommendations: <Tv>[],
        isAddedToWatchlist: false,
      ),
    );

    /*
    * act */
    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
    await tester.pump();

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    /*
    * assert */
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv is added to watchlist',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockTvDetailBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: RequestState.loaded,
        tvDetail: testTvDetail,
        tvRecommendationsState: RequestState.loaded,
        tvRecommendations: [testTv],
        isAddedToWatchlist: true,
      ),
    );

    /*
    * act */
    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
    await tester.pump();

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    /*
    * assert */
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Show display snackbar when added to watchlist',
      (WidgetTester tester) async {
    /*
    * arrange */
    whenListen(
      mockTvDetailBloc,
      Stream.fromIterable([
        TvDetailState.initial().copyWith(
          isAddedToWatchlist: false,
        ),
        TvDetailState.initial().copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Added to Watchlist',
        ),
      ]),
      initialState: TvDetailState.initial(),
    );

    /*
    * act */
    final snackbar = find.byType(SnackBar);
    final textMessage = find.text('Added to Watchlist');

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));

    /*
    * assert */
    expect(snackbar, findsNothing);
    expect(textMessage, findsNothing);

    await tester.pump();

    expect(snackbar, findsOneWidget);
    expect(textMessage, findsOneWidget);
  });

  testWidgets('Show display alert dialog when add to watchlist failed',
      (WidgetTester tester) async {
    /*
    * arrange */
    whenListen(
      mockTvDetailBloc,
      Stream.fromIterable([
        TvDetailState.initial().copyWith(
          isAddedToWatchlist: false,
        ),
        TvDetailState.initial().copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed Add to Watchlist',
        ),
      ]),
      initialState: TvDetailState.initial(),
    );

    /*
    * act */
    final alertDialog = find.byType(AlertDialog);
    final textMessage = find.text('Failed Add to Watchlist');

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));

    /*
    * assert */
    expect(alertDialog, findsNothing);
    expect(textMessage, findsNothing);

    await tester.pump();

    /*
    * assert */
    expect(alertDialog, findsOneWidget);
    expect(textMessage, findsOneWidget);
  });

  testWidgets(
      'Tv detail page should display error text when no internet network',
      (WidgetTester tester) async {
    /*
   * arrange */
    when(() => mockTvDetailBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: RequestState.error,
        message: 'Failed to connect to the network',
      ),
    );

    /*
    * act */
    final textErrorBarFinder = find.text('Failed to connect to the network');

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump();

    /*
    * assert */
    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets(
      'Recommendations Tv should display error text when data is empty',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockTvDetailBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: RequestState.loaded,
        tvDetail: testTvDetail,
        tvRecommendationsState: RequestState.empty,
        isAddedToWatchlist: false,
      ),
    );

    /*
    * act */
    final textErrorBarFinder = find.text('No recommendations available.');

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump();

    /*
    * assert */
    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets(
      'Recommendations Tv should display error text when get data is error',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockTvDetailBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: RequestState.loaded,
        tvDetail: testTvDetail,
        tvRecommendationsState: RequestState.error,
        message: 'Error',
        isAddedToWatchlist: false,
      ),
    );

    /*
    * act */
    final textErrorBarFinder = find.text('Error');

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump();

    /*
    * assert */
    expect(textErrorBarFinder, findsOneWidget);
  });
}
