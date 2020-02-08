import 'package:flutter_bloc/flutter_bloc.dart';

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
        print('before getComments');
        yield await getComments(topicId: event.topicId);
        print('after getComments');
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

        if (result != 5) {
          yield CommentsLoadFailed();
        }
        yield await getComments();

      } else if (event is LikeCommentEvent) {
        final res = await _repo.likeComment(event.id);
        if (res != 5) {
          yield CommentsLoadFailed();
        }
        yield await getComments();

      } else if (event is DislikeCommentEvent) {
        final res = await _repo.dislikeComment(event.id);
        if (res != 5) {
          yield CommentsLoadFailed();
        }
        yield await getComments();
        
      } else if (event is UpdateCommentEvent) {
        final res = await _repo.updateComment(event.id, event.text);
        if (res != 5) {
          yield CommentsLoadFailed();
        }
        yield await getComments();
      } else {
        yield CommentsLoadFailed();
      }
    } catch (_) {
      yield CommentsLoadFailed();
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
    if (topicId != null ||  state is CommentsLoaded){
      print('before _repo.getComments');
      final data = await _repo.getComments(topicId ?? (state as CommentsLoaded).topicId);
      print('after _repo.getComments');
      return (data != null)
          ? CommentsLoaded(
              topicId: topicId ?? (state as CommentsLoaded).topicId, comments: data)
          : CommentsLoadFailed();
    }
    return CommentsLoadFailed();
  }
}
