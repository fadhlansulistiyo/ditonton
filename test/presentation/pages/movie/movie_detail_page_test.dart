import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entity/movie/movie.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockMovieDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const tId = 1;

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockMovieDetailBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.loaded,
        movieDetail: testMovieDetail,
        movieRecommendationsState: RequestState.loaded,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: false,
      ),
    );

    /*
    * act */
    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: tId)));
    await tester.pump();

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    /*
    * assert */
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockMovieDetailBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.loaded,
        movieDetail: testMovieDetail,
        movieRecommendationsState: RequestState.loaded,
        movieRecommendations: [testMovie],
        isAddedToWatchlist: true,
      ),
    );

    /*
    * act */
    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: tId)));
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
      mockMovieDetailBloc,
      Stream.fromIterable([
        MovieDetailState.initial().copyWith(
          isAddedToWatchlist: false,
        ),
        MovieDetailState.initial().copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Added to Watchlist',
        ),
      ]),
      initialState: MovieDetailState.initial(),
    );

    /*
    * act */
    final snackbar = find.byType(SnackBar);
    final textMessage = find.text('Added to Watchlist');

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: tId)));

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
      mockMovieDetailBloc,
      Stream.fromIterable([
        MovieDetailState.initial().copyWith(
          isAddedToWatchlist: false,
        ),
        MovieDetailState.initial().copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed Add to Watchlist',
        ),
      ]),
      initialState: MovieDetailState.initial(),
    );

    /*
    * act */
    final alertDialog = find.byType(AlertDialog);
    final textMessage = find.text('Failed Add to Watchlist');

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: tId)));

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
      'Movie detail page should display error text when no internet network',
      (WidgetTester tester) async {
    /*
   * arrange */
    when(() => mockMovieDetailBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.error,
        message: 'Failed to connect to the network',
      ),
    );

    /*
    * act */
    final textErrorBarFinder = find.text('Failed to connect to the network');

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    /*
    * assert */
    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets(
      'Recommendations Movies should display error text when data is empty',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockMovieDetailBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.loaded,
        movieDetail: testMovieDetail,
        movieRecommendationsState: RequestState.empty,
        isAddedToWatchlist: false,
      ),
    );

    /*
    * act */
    final textErrorBarFinder = find.text('No recommendations available.');

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    /*
    * assert */
    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets(
      'Recommendations Movies should display error text when get data is error',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockMovieDetailBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.loaded,
        movieDetail: testMovieDetail,
        movieRecommendationsState: RequestState.error,
        message: 'Error',
        isAddedToWatchlist: false,
      ),
    );

    /*
    * act */
    final textErrorBarFinder = find.text('Error');

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    /*
    * assert */
    expect(textErrorBarFinder, findsOneWidget);
  });
}
