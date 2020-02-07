import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/block.dart';
import '../models/user.dart';
import 'common/fail_message.dart';
import 'topics_page.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      body: Container(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserUninitialized) {
              userBloc.add(LoadSavedUser());
              return const Text('Loading...');
            }
            if (state is UserLoading) {
              return const Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator()),
              );
            }
            if (state is UserLoaded) {
              return Center(
                child: SizedBox(
                  width: 450,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Привіт, ${state.user.name}',
                          style: Theme.of(context).textTheme.display2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        child: Text(
                          'Го спілкуватись!',
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          color: Colors.blue[200],
                          padding: const EdgeInsets.all(8.0),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TopicsPage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                            child: const Text('Гоу!'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is UserLoadFailed) {
              final textController = TextEditingController();
              return Center(
                child: SizedBox(
                  width: 450,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Давай знайомитись,',
                          style: Theme.of(context).textTheme.display2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        child: Text(
                          "введи своє ім'я",
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(hintText: 'тут'),
                          controller: textController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          color: Colors.blue[200],
                          padding: const EdgeInsets.all(8.0),
                          onPressed: () {
                            final userName = textController.text;
                            if (userName != null && userName.isNotEmpty) {
                              userBloc.add(SaveUser(User(userName)));
                            }
                          },
                          child: const Text('Продовжити!'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const FailMessage();
          },
        ),
      ),
    );
  }
}
