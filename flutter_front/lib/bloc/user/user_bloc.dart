import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final _repo = UserRepository();

  @override
  UserState get initialState => UserUninitialized();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    try {
      if (event is LoadSavedUser) {
          yield UserLoading();
          final user = await _repo.loadUser();
          yield (user != null) ? UserLoaded(user) : UserLoadFailed();

      } else if (event is SaveUser) {
          yield UserLoading();
          yield UserLoaded(await _repo.saveUser(event.user));

      } else {
        yield UserLoadFailed();
      }
    } catch (_) {
      yield UserLoadFailed();
    }
  }
}
