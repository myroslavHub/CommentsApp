import 'package:equatable/equatable.dart';

import '../../models/topic.dart';

abstract class TopicState extends Equatable {
  @override
  List<Object> get props => [];
}

class TopicsUninitialized extends TopicState {}

class TopicsLoading extends TopicState {}

class TopicsLoaded extends TopicState {
  final List<Topic> topics;

  TopicsLoaded(this.topics);

  @override
  List<Object> get props => [topics];
}

class TopicLoadFailed extends TopicState { }