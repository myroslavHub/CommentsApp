import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final int id;
  final int likes;
  final String author;
  final String text;
  final DateTime date;

  final List<Comment> comments;

  Comment({
    this.id,
    this.likes,
    this.author,
    this.text,
    this.date,
    this.comments,
  });

  @override
  List<Object> get props => [
        id,
        likes,
        author,
        text,
        date,
        comments,
      ];

  static Comment fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      likes: json['likes'] as int,
      author: json['author'] as String,
      text: json['text'] as String,
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
  String toString() => 'id: $id likes:$likes author: $author text: $text date: $date comments:${comments.map((cc)=>cc.toString()).join(",")}';
}
