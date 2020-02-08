
import 'package:equatable/equatable.dart';
import '../../models/comment.dart';

abstract class CommentState extends Equatable {
  @override
  List<Object> get props => [];
}

class CommentsUninitialized extends CommentState {}

class CommentsLoading extends CommentState {}

class CommentsLoaded extends CommentState {
  final int topicId;
  final List<Comment> comments;

  CommentsLoaded({this.topicId, this.comments});

  @override
  List<Object> get props => [topicId, comments];
}

class CommentsLoadFailed extends CommentState { }