import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/block.dart';
import '../models/user.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userBloc = context.bloc<UserBloc>();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blue[200], Colors.blue[50]],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[50],
            blurRadius: 3.0, // has the effect of softening the shadow
            spreadRadius: 3.0, // has the effect of extending the shadow
            offset: Offset(
              10.0, // horizontal, move right 10
              4.0, // vertical, move down 10
            ),
          )
        ],
      ),
      height: 120,
      //color: Colors.blue[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/fl.png',
            height: 120,
            width: 156,
          ),
          Text(
            'Чаттер',
            style: MediaQuery.of(context).size.width > 600
                ? Theme.of(context).textTheme.display3
                : Theme.of(context).textTheme.display1,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width > 600 ? 150 : 10,
          ),
          BlocBuilder<UserBloc, UserState>(
            builder: (BuildContext context, UserState state) {
              if (state is UserLoaded) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    InkWell(
                      onTap: () {
                        _showDialog(context, userBloc);
                      },
                      child: Text(
                        state.user.name,
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(color: Colors.black87),
                      ),
                    ),
                  ],
                );
              } else {
                return Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.blue,
                );
              }
            },
          )
        ],
      ),
    );
  }

  void _showDialog(
    BuildContext context,
    UserBloc userBloc,
  ) {
    final author = (userBloc.state as UserLoaded).user.name;
    final nameController = TextEditingController();
    nameController.text = author;
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
                    decoration: InputDecoration(hintText: 'введіть нове імя'),
                  ),
                  SizedBox(
                    width: 320.0,
                    child: RaisedButton(
                      onPressed: () {
                        if (nameController.text.isEmpty) {
                          return;
                        }
                        userBloc.add(SaveUser(
                          User(nameController.text),
                        ));
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Зберегти",
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
}
