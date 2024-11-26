import 'package:ditonton/data/models/tv/tv_table.dart';
import 'package:ditonton/domain/entity/tv/genre_tv.dart';
import 'package:ditonton/domain/entity/tv/tv.dart';
import 'package:ditonton/domain/entity/tv/tv_detail.dart';

final testTv = Tv(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: const [16, 10765, 10759, 9648],
  id: 94605,
  originalName: 'Arcane',
  overview:
      'Amid the stark discord of twin cities Piltover and Zaun, two sisters fight on rival sides of a war between magic technologies and clashing convictions.',
  popularity: 1964.981,
  posterPath: "/fqldf2t8ztc9aiwn3k6mlX3tvRT.jpg",
  firstAirDate: "2021-11-06",
  name: "Arcane",
  voteAverage: 8.8,
  voteCount: 4335,
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [GenreTv(id: 1, name: 'Action')],
  id: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  firstAirDate: 'firstAirDate',
  name: 'name',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistTv = Tv.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvTable = TvTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
