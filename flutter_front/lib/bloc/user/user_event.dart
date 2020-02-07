import 'package:equatable/equatable.dart';

import '../../models/user.dart';

abstract class UserEvent extends Equatable{
  List<Object> get props => [];
}

class LoadSavedUser extends UserEvent {
}

class SaveUser extends UserEvent {
  final User user;
  SaveUser(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UserLoaded: user name: ${user.name}';
}