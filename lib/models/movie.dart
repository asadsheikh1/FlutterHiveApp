import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final bool addedToWatchList;

  const Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.addedToWatchList = false,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? imageUrl,
    bool addedToWatchList = false,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      addedToWatchList: addedToWatchList,
    );
  }

  @override
  List<Object?> get props => [id, title, imageUrl, addedToWatchList];
}
