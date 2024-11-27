import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entity/movie/movie.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:ditonton/presentation/provider/movie/popular_movies_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([PopularMoviesNotifier])
void main() {
  late MockPopularMoviesNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockPopularMoviesNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<PopularMoviesNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(mockNotifier.state).thenReturn(RequestState.loading);

    /*
    * act */
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    /*
    * assert */
    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.movies).thenReturn(<Movie>[]);

    /*
    * act */
    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    /*
    * assert */
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(mockNotifier.state).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    /*
    * act */
    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    /*
    * assert */
    expect(textFinder, findsOneWidget);
  });
}
