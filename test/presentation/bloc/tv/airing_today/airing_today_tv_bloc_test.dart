import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_airing_today_tv.dart';
import 'package:ditonton/presentation/bloc/tv/airing_today/airing_today_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../../../dummy_data/dummy_object_tv.dart';
import 'airing_today_tv_bloc_test.mocks.dart';

@GenerateMocks([GetAiringTodayTv])
void main() {
  late AiringTodayBloc airingTodayBloc;
  late MockGetAiringTodayTv mockGetAiringTodayTv;

  setUp(() {
    mockGetAiringTodayTv = MockGetAiringTodayTv();
    airingTodayBloc = AiringTodayBloc(mockGetAiringTodayTv);
  });

  test('initial state should be empty', () {
    expect(airingTodayBloc.state, AiringTodayEmpty());
  });

  blocTest<AiringTodayBloc, AiringTodayState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetAiringTodayTv.execute())
          .thenAnswer((_) async => Right(testTvList));
      return airingTodayBloc;
    },
    act: (bloc) => bloc.add(FetchAiringTodayTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      AiringTodayLoading(),
      AiringTodayHasData(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTv.execute());
    },
  );

  blocTest<AiringTodayBloc, AiringTodayState>(
    'Should emit [Loading, Error] when get airing today Tv is unsuccessful',
    build: () {
      when(mockGetAiringTodayTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return airingTodayBloc;
    },
    act: (bloc) => bloc.add(FetchAiringTodayTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      AiringTodayLoading(),
      AiringTodayError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTv.execute());
    },
  );
}
