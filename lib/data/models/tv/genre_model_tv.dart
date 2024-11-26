import 'package:ditonton/domain/entity/tv/genre_tv.dart';
import 'package:equatable/equatable.dart';

class GenreModelTv extends Equatable {
  GenreModelTv({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory GenreModelTv.fromJson(Map<String, dynamic> json) => GenreModelTv(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  GenreTv toEntity() {
    return GenreTv(id: id, name: name);
  }

  @override
  List<Object?> get props => [id, name];
}
