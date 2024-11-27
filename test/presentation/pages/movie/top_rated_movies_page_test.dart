import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entity/movie/movie.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:ditonton/presentation/provider/movie/top_rated_movies_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([TopRatedMoviesNotifier])
void main() {
  late MockTopRatedMoviesNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTopRatedMoviesNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TopRatedMoviesNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(mockNotifier.state).thenReturn(RequestState.loading);

    /*
    * act */
    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    /*
    * assert */
    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.movies).thenReturn(<Movie>[]);

    /*
    * act */
    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

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

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    /*
    * assert */
    expect(textFinder, findsOneWidget);
  });
}
