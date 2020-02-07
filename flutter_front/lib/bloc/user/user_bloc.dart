import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  @override
  UserState get initialState => UserUninitialized();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is LoadSavedUser) {
      try {
        yield UserLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String name = prefs.getString('username');
        if (name != null) {
          yield UserLoaded(User(name));
        } else {
          yield UserLoadFailed();
        }
      } catch (_) {
        yield UserLoadFailed();
      }
    }else
    if (event is SaveUser) {
      try {
        yield UserLoading();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        
        prefs.setString('username', event.user.name);

        yield UserLoaded(event.user);

      } catch (_) {
        yield UserLoadFailed();
      }
    }
    else{
      yield UserLoadFailed();
    }

  }
}
