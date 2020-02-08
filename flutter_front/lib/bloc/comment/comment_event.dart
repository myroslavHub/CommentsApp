import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchComments extends CommentEvent {
  final int topicId;

  FetchComments(this.topicId);

  @override
  List<Object> get props => [topicId];
}

class DeleteCommentEvent extends CommentEvent {
  final int id;

  DeleteCommentEvent(this.id);

  @override
  List<Object> get props => [id];
}

class CreateCommentForCommentEvent extends CommentEvent {
  final int parentCommentId;
  final String author; 
  final String text;

  CreateCommentForCommentEvent({this.parentCommentId, this.author, this.text});
  
  @override
  List<Object> get props => [parentCommentId, author, text];
}

class CreateCommentForTopicEvent extends CommentEvent {
  final int parentTopicId;
  final String author; 
  final String text;

  CreateCommentForTopicEvent({this.parentTopicId, this.author, this.text}); 

  @override
  List<Object> get props => [parentTopicId, author, text];
}

class LikeCommentEvent extends CommentEvent {
  final int id;

  LikeCommentEvent(this.id); 
  @override
  List<Object> get props => [id];
}

class DislikeCommentEvent extends CommentEvent {
  final int id;

  DislikeCommentEvent(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateCommentEvent extends CommentEvent {
  final int id;
  final String text;

  UpdateCommentEvent(this.id, this.text);

  @override
  List<Object> get props => [id, text];
}