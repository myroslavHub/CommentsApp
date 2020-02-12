import 'package:equatable/equatable.dart';

class Topic extends Equatable {
  final int id;
  final String author;
  final String name;
  final String description;
  final DateTime date;
  final int commentsCount;

  Topic({
    this.id,
    this.author,
    this.name,
    this.description,
    this.date,
    this.commentsCount,
  });

  @override
  List<Object> get props => [
        id,
        author,
        name,
        description,
        date,
        commentsCount,
      ];

  static Topic fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as int,
      author: json['author'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      commentsCount: json['commentsCount'] as int,
    );
  }

    @override
  String toString() => 'id: $id author: $author name: $name descrription: $description date: $date commentsCount:$commentsCount';
}
