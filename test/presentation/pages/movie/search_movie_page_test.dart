import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_movie_bloc.dart';
import 'package:ditonton/presentation/pages/movie/search_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../dummy_data/dummy_objects.dart';

class MockSearchMovieBloc extends MockBloc<SearchMovieEvent, SearchMovieState>
    implements SearchMovieBloc {}

class FakeSearchMovieEvent extends Fake implements SearchMovieEvent {}

class FakeSearchMovieState extends Fake implements SearchMovieState {}

void main() {
  late MockSearchMovieBloc mockSearchMovieBloc;

  setUpAll(() {
    registerFallbackValue(FakeSearchMovieEvent());
    registerFallbackValue(FakeSearchMovieState());
  });

  setUp(() {
    mockSearchMovieBloc = MockSearchMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchMovieBloc>.value(
      value: mockSearchMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockSearchMovieBloc.state).thenReturn(SearchMovieLoading());

    /*
    * act */
    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

    /*
    * assert */
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockSearchMovieBloc.state)
        .thenReturn(SearchMovieHasData(testMovieList));

    /*
    * act */
    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

    /*
    * assert */
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockSearchMovieBloc.state)
        .thenReturn(SearchMovieHasData(testMovieList));

    /*
    * act */
    final formSearch = find.byType(TextField);
    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

    await tester.enterText(formSearch, 'spiderman');
    await tester.pump();

    /*
    * assert */
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display Text when data is empty',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockSearchMovieBloc.state).thenReturn(SearchMovieEmpty());

    /*
    * act */
    final textErrorBarFinder = find.text('Movie not found. Please try again.');

    await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

    /*
    * assert */
    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets('Page should display when empty', (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockSearchMovieBloc.state).thenReturn(SearchMovieEmpty());

    /*
    * act */
    final textErrorBarFinder = find.byType(Container);

    await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

    /*
    * assert */
    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockSearchMovieBloc.state)
        .thenReturn(SearchMovieError('Error message'));

    /*
    * act */
    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

    /*
    * assert */
    expect(textFinder, findsOneWidget);
  });
}
