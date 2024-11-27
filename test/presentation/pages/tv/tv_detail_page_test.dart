import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../../../dummy_data/dummy_object_tv.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailNotifier])
void main() {
  late MockTvDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    /* act */
    final watchlistButtonIcon = find.byIcon(Icons.add);
    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

    /* assert */
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv is added to watchlist',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);

    /*
    * act */
    final watchlistButtonIcon = find.byIcon(Icons.check);
    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

    /*
    * assert */
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

    /*
    * act */
    final watchlistButton = find.byType(FilledButton);
    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    /*
    * arrange */
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Failed');

    /*
    * act */
    final watchlistButton = find.byType(FilledButton);
    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

    /*
    * assert */
    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
