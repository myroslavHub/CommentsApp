import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/block.dart';
import 'bloc/simple_bloc_delegate.dart';
import 'widgets/user_page.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<UserBloc>(
        create: (BuildContext context) => UserBloc(),
      ),
      BlocProvider<TopicBloc>(
        create: (BuildContext context) => TopicBloc(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comments app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserPage(),
      // home: BlocProvider(
      //   create: (context) => UserBloc(),
      //   child: UserPage(),
      // ),
    );
  }
}
