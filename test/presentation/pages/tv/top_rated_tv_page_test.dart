import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_object_tv.dart';

class MockTopRatedTvBloc extends MockBloc<TopRatedTvEvent, TopRatedTvState>
    implements TopRatedTvBloc {}

class FakeTopRatedTvEvent extends Fake implements TopRatedTvEvent {}

class FakeTopRatedTvState extends Fake implements TopRatedTvState {}

void main() {
  late MockTopRatedTvBloc mockTopRatedTvBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedTvEvent());
    registerFallbackValue(FakeTopRatedTvState());
  });

  setUp(() {
    mockTopRatedTvBloc = MockTopRatedTvBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvBloc>.value(
      value: mockTopRatedTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockTopRatedTvBloc.state).thenReturn(TopRatedTvLoading());

    /*
    * act */
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvPage()));

    /*
    * assert */
    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockTopRatedTvBloc.state)
        .thenReturn(TopRatedTvHasData(testTvList));

    /*
    * act */
    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvPage()));

    /*
    * assert */
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(() => mockTopRatedTvBloc.state)
        .thenReturn(TopRatedTvError('Error message'));

    /*
    * act */
    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvPage()));

    /*
    * assert */
    expect(textFinder, findsOneWidget);
  });
}
