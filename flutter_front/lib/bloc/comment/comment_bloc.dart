import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/comment.dart';

import '../../repo/comments_repository.dart';

import '../block.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final _repo = CommentsRepository();

  @override
  CommentState get initialState => CommentsUninitialized();

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    try {
      if (event is FetchComments) {
        yield CommentsLoading();
        yield await getComments(topicId: event.topicId);

      } else if (event is DeleteCommentEvent) {
        yield await deleteComment(event);

      } else if (event is CreateCommentForCommentEvent) {
        final comment = await _repo.createCommentForComment(
            event.parentCommentId, event.text, event.author);
        if (comment == null) {
          yield CommentsLoadFailed();
        }
        yield await getComments();

      } else if (event is CreateCommentForTopicEvent) {
        final result = await _repo.createCommentForTopic(
            event.parentTopicId, event.text, event.author);

        if (result == null) {
          yield CommentsLoadFailed();
        } else {
          yield await getComments();
        }

      } else if (event is LikeCommentEvent) {
        final res = await _repo.likeComment(event.id);
        yield await insertModifiedComment(event.id, res);

      } else if (event is DislikeCommentEvent) {
        final res = await _repo.dislikeComment(event.id);
        yield await insertModifiedComment(event.id, res);

      } else if (event is UpdateCommentEvent) {
        final res = await _repo.updateComment(event.id, event.text);
        yield await insertModifiedComment(event.id, res);

      } else {
        yield CommentsLoadFailed();
      }
    } catch (_) {
      yield CommentsLoadFailed();
    }
  }

  Future<CommentState> insertModifiedComment(int id, Comment res) async {
    if (state is CommentsLoaded) {
      final st = state as CommentsLoaded;
      _insertComment(id, st.comments, res);
      return CommentsLoaded(
          topicId: st.topicId,
          comments: st.comments,
          dirtySwitch: !st.dirtySwitch);
    } else {
      return getComments();
    }
  }

  void _insertComment(int id, List<Comment> comments, Comment newComment) {
    for (int i = 0; i < comments.length; i++) {
      if (comments[i].id == newComment.id) {
        comments[i] =
            newComment.copyWithComments(newComments: comments[i].comments);
        return;
      }
      if (comments[i].comments != null) {
        _insertComment(id, comments[i].comments, newComment);
      }
    }
  }

  Future<CommentState> deleteComment(DeleteCommentEvent event) async {
    final deleted = await _repo.deleteComment(event.id);
    if (deleted == null) {
      return CommentsLoadFailed();
    }
    return getComments();
  }

  Future<CommentState> getComments({int topicId}) async {
    if (topicId != null || state is CommentsLoaded) {
      final data =
          await _repo.getComments(topicId ?? (state as CommentsLoaded).topicId);
      return (data != null)
          ? CommentsLoaded(
              topicId: topicId ?? (state as CommentsLoaded).topicId,
              comments: data)
          : CommentsLoadFailed();
    }
    return CommentsLoadFailed();
  }
}
