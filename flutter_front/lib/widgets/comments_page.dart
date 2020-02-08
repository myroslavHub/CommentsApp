import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/block.dart';
import '../models/comment.dart';
import '../models/topic.dart';
import '../models/user.dart';
import 'common/fail_message.dart';
import 'header.dart';

class CommentPage extends StatelessWidget {
  final Topic topic;
  const CommentPage({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentsBloc = context.bloc<CommentBloc>();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Header(),
          Expanded(
            child: BlocBuilder<CommentBloc, CommentState>(
              builder: (BuildContext context, CommentState state) {
                if (state is CommentsUninitialized) {
                  commentsBloc.add(FetchComments(topic.id));
                  return const Text('Loading...');
                }
                if (state is CommentsLoading) {
                  return const Center(
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator()),
                  );
                }
                if (state is CommentsLoadFailed) {
                  return const FailMessage();
                }

                if (state is CommentsLoaded) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 15,
                    ),
                    child: SingleChildScrollView(
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (BuildContext context, UserState userState) {
                          final user = (userState as UserLoaded).user;
                          var comments = List<Widget>();
                          comments.add(getCommentHeaderWidget(
                              context, commentsBloc, user));
                          // comments.add(Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: <Widget>[
                          //     MaterialButton(
                          //       onPressed: () {
                          //         _addTopicCommentDialog(context,
                          //             (userState as UserLoaded).user, commentsBloc);
                          //       },
                          //       child: Text(
                          //         'Добавити коментар',
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .subtitle
                          //             .copyWith(color: Colors.blue),
                          //       ),
                          //     ),
                          //   ],
                          // ));

                          for (var com in state.comments) {
                            comments.addAll(
                                getComment(context, commentsBloc, com, user));
                          }

                          return Column(
                            children: comments,
                          );
                        },
                      ),
                    ),
                  );
                }

                return const FailMessage();
              },
            ),
          ),
          Container(
            color: Colors.yellow[50],
          ),
        ],
      ),
    );
  }

  Iterable<Widget> getComment(
      BuildContext context, CommentBloc commentBloc, Comment comment, User user,
      {int deep = 0}) sync* {
    yield getCommentWidget(context, commentBloc, comment, user, deep);
    for (var com in comment.comments) {
      yield* getComment(context, commentBloc, com, user, deep: deep + 1);
    }
  }

  void _addTopicCommentDialog(
      BuildContext context, User user, CommentBloc commentsBloc) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            height: 250,
            width: 600,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: textController,
                    maxLines: 3,
                    minLines: 3,
                    decoration: InputDecoration(hintText: 'коментар сюди'),
                  ),
                  SizedBox(
                    width: 320.0,
                    child: RaisedButton(
                      onPressed: () {
                        if (textController.text.isEmpty) {
                          return;
                        }
                        final author = user.name;
                        commentsBloc.add(CreateCommentForTopicEvent(
                            parentTopicId: topic.id,
                            author: author,
                            text: textController.text));

                        Navigator.of(context).pop();
                      },
                      color: Colors.blue,
                      child: const Text(
                        "Добавити",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _editCommentDialog(BuildContext context, User user, Comment comment,
      CommentBloc commentsBloc) {
    final textController = TextEditingController();
    textController.text = comment.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            height: 250,
            width: 600,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: textController,
                    maxLines: 3,
                    minLines: 3,
                    decoration: InputDecoration(hintText: 'коментар сюди'),
                  ),
                  SizedBox(
                    width: 320.0,
                    child: RaisedButton(
                      onPressed: () {
                        if (textController.text.isEmpty) {
                          return;
                        }
                        final author = user.name;
                        commentsBloc.add(UpdateCommentEvent(
                            comment.id, textController.text));

                        Navigator.of(context).pop();
                      },
                      color: Colors.blue,
                      child: const Text(
                        "Зберегти",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _addCommentForCommentDialog(BuildContext context, User user,
      Comment comment, CommentBloc commentsBloc) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            height: 250,
            width: 600,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: textController,
                    maxLines: 3,
                    minLines: 3,
                    decoration: InputDecoration(hintText: 'коментар сюди'),
                  ),
                  SizedBox(
                    width: 320.0,
                    child: RaisedButton(
                      onPressed: () {
                        if (textController.text.isEmpty) {
                          return;
                        }
                        final author = user.name;
                        commentsBloc.add(CreateCommentForCommentEvent(
                            parentCommentId: comment.id,
                            author: author,
                            text: textController.text));

                        Navigator.of(context).pop();
                      },
                      color: Colors.blue,
                      child: const Text(
                        "Зберегти",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getCommentHeaderWidget(
      BuildContext context, CommentBloc commentBloc, User user) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxWidth: 650, minHeight: 140, maxHeight: 250, minWidth: 200),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: <Widget>[
                  Column(
                    // mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 600 > MediaQuery.of(context).size.width
                            ? MediaQuery.of(context).size.width - 40
                            : 600,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Text(
                            topic.name,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ),
                      ),
                      Container(
                        width: 600 > MediaQuery.of(context).size.width
                            ? MediaQuery.of(context).size.width - 40
                            : 600,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Text(
                            topic.description,
                            softWrap: true,
                            maxLines: 4,
                            style: Theme.of(context).textTheme.subhead,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.teal[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      _addTopicCommentDialog(context, user, commentBloc);
                    },
                    child: Text(
                      'Добавити коментар',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCommentWidget(BuildContext context, CommentBloc commentBloc,
      Comment comment, User user, int deep) {
    double offset = deep * 24.0;
    if (MediaQuery.of(context).size.width < 600){
      offset = 0;
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: offset,
          ),
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        child: Text(
                          'АВТОР: ${comment.author}',
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(color: Colors.blue),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        child: Text(
                          'ДАТА: ${DateFormat.MMMd().add_jm().format(comment.date)}',
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(color: Colors.blue),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {
                            commentBloc.add(LikeCommentEvent(comment.id));
                          }),
                      Text(
                        comment.likes.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: Colors.blue),
                      ),
                      IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {
                            commentBloc.add(DislikeCommentEvent(comment.id));
                          }),
                      getRemoveButton(commentBloc, user, comment),
                      getEditButton(context, commentBloc, user, comment),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width:
                                620 - offset > MediaQuery.of(context).size.width
                                    ? MediaQuery.of(context).size.width
                                    : 620 - offset,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Text(
                                comment.text,
                                softWrap: true,
                                maxLines: 10,
                                style: Theme.of(context).textTheme.subhead,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          _addCommentForCommentDialog(context, user, comment, commentBloc);
                        },
                        child: Text(
                          'Коментувати',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .copyWith(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getRemoveButton(CommentBloc commentBloc, User user, Comment comment) {
    if (user.name == comment.author) {
      return IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            commentBloc.add(DeleteCommentEvent(comment.id));
          });
    }
    return Container();
  }

  Widget getEditButton(BuildContext context, CommentBloc commentBloc, User user,
      Comment comment) {
    if (user.name == comment.author) {
      return IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            _editCommentDialog(context, user, comment, commentBloc);
          });
    }
    return Container();
  }
}
