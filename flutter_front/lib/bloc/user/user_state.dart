import 'package:equatable/equatable.dart';

import '../../models/user.dart';

abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserUninitialized extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UserLoaded: user name: ${user.name}';
}

class UserLoadFailed extends UserState {}