import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/block.dart';
import '../models/topic.dart';

import 'comments_page.dart';
import 'common/fail_message.dart';
import 'header.dart';

class TopicsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topicBloc = context.bloc<TopicBloc>();
    final userBloc = context.bloc<UserBloc>();

    return Scaffold(
      body: Column(
        children: <Widget>[
          Header(),
          Expanded(
            child: BlocBuilder<TopicBloc, TopicState>(
              builder: (BuildContext context, TopicState state) {
                if (state is TopicsUninitialized) {
                  topicBloc.add(FetchTopics());
                  return const Text('Loading...');
                }
                if (state is TopicsLoading) {
                  return const Center(
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator()),
                  );
                }
                if (state is TopicLoadFailed) {
                  return const FailMessage();
                }
                if (state is TopicsLoaded) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                    child: SingleChildScrollView(
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (BuildContext context, UserState userState) {
                          var topics = state.topics
                              .map((t) => getTopicWidget(
                                  context, userState, topicBloc, t))
                              .toList();
                          topics.add(MaterialButton(
                            onPressed: () {
                              _showDialog(context, userBloc, topicBloc);
                            },
                            child: Text(
                              'Добавити нову тему для обговорень',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle
                                  .copyWith(color: Colors.blue),
                            ),
                          ));

                          return Column(
                            children: topics,
                          );
                        },
                      ),
                    ),
                  );
                  //return const Text('Завантажило топіки!!!!!');
                }
                return const FailMessage();
              },
            ),

            // child: Container(
            //   //color: Colors.yellow[50],
            // ),
          )
        ],
      ),
    );
  }

  void _showDialog(
    BuildContext context,
    UserBloc userBloc,
    TopicBloc topicBloc,
  ) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Container(
            height: 300,
            width: 600,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    maxLines: 1,
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: 'Введіть заголовок нової теми'),
                  ),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    minLines: 3,
                    decoration: InputDecoration(hintText: 'Введіть деталі'),
                  ),
                  SizedBox(
                    width: 320.0,
                    child: RaisedButton(
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            descriptionController.text.isEmpty) {
                          return;
                        }
                        final author = (userBloc.state as UserLoaded).user.name;
                        topicBloc.add(CreateTopicEvent(
                          author,
                          nameController.text,
                          descriptionController.text,
                        ));
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Добавити",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
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

  Widget getRemoveButton(
    UserState userState,
    TopicBloc topicBloc,
    Topic topic,
  ) {
    if (topic.author == (userState as UserLoaded).user.name) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              topicBloc.add(DeleteTopicEvent(topic.id));
            }),
      );
    }
    return Container();
  }

  Widget getTopicWidget(
    BuildContext context,
    UserState userState,
    TopicBloc topicBloc,
    Topic topic,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxWidth: 650, minHeight: 140, maxHeight: 250, minWidth: 200),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) => CommentBloc(),
                    child: CommentPage(topic: topic),
                  ),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Text(
                    'АВТОР: ${topic.author}',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(color: Colors.blue),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (BuildContext context) => CommentBloc(),
                        child: CommentPage(topic: topic),
                      ),
                    ));
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Text(
                      '${topic.comments.length} КОМЕНТАРІВ',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: Colors.blue),
                    ),
                  ),
                ),
                getRemoveButton(userState, topicBloc, topic),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
