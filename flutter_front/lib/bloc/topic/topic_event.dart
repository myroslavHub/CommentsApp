import 'package:equatable/equatable.dart';

abstract class TopicEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UninitializeTopic extends TopicEvent {}

class FetchTopics extends TopicEvent {}

class DeleteTopicEvent extends TopicEvent {
  final int id;

  DeleteTopicEvent(this.id);

  @override
  List<Object> get props => [id];
}

class CreateTopicEvent extends TopicEvent {
  final String author; 
  final String name; 
  final String description;

  CreateTopicEvent(this.author, this.name, this.description);

  @override
  List<Object> get props => [author, name, description];
}