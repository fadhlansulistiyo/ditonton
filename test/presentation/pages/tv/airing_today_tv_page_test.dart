import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/presentation/pages/tv/airing_today_tv_page.dart';
import 'package:ditonton/presentation/provider/tv/airing_today_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'airing_today_tv_page_test.mocks.dart';

@GenerateMocks([AiringTodayTvNotifier])
void main() {
  late MockAiringTodayTvNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockAiringTodayTvNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<AiringTodayTvNotifier>.value(
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

    await tester.pumpWidget(makeTestableWidget(const AiringTodayTvPage()));

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
    when(mockNotifier.tv).thenReturn(<Tv>[]);

    /*
    * act */
    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const AiringTodayTvPage()));

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

    await tester.pumpWidget(makeTestableWidget(const AiringTodayTvPage()));

    /*
    * assert */
    expect(textFinder, findsOneWidget);
  });
}
