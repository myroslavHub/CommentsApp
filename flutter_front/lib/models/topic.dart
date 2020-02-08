import 'package:equatable/equatable.dart';

import 'comment.dart';

class Topic extends Equatable {
  final int id;
  final String author;
  final String name;
  final String description;
  final DateTime date;

  final List<Comment> comments;

  Topic({
    this.id,
    this.author,
    this.name,
    this.description,
    this.date,
    this.comments,
  });

  @override
  List<Object> get props => [
        id,
        author,
        name,
        description,
        date,
        comments,
      ];

  static Topic fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as int,
      author: json['author'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      comments: getComments(json['comments'] as List),
    );
  }
  static List<Comment> getComments(Iterable json){
    if (json != null) {
      return json.map<Comment>((c) => Comment.fromJson(c as Map<String, dynamic>)).toList();
		}
    return [];
  }

    @override
  String toString() => 'id: $id author: $author name: $name descrription: $description date: $date comments:${comments.map((cc)=>cc.toString()).join(",")}';
}
