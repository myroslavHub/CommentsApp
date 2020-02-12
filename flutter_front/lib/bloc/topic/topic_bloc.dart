import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/topics_repository.dart';
import 'topic_event.dart';
import 'topic_state.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  final _repo = TopicsRepository();

  @override
  TopicState get initialState => TopicsUninitialized();

  @override
  Stream<TopicState> mapEventToState(TopicEvent event) async* {
    try {
      if (event is FetchTopics) {
        yield TopicsLoading();
        final topics = await _repo.getTopics();
        yield (topics != null) ? TopicsLoaded(topics) : TopicLoadFailed();
      } else if (event is DeleteTopicEvent) {
        final deletedTopic = await _repo.deleteTopic(event.id);
        if (deletedTopic == null) {
          yield TopicLoadFailed();
        }
        final topics = await _repo.getTopics();
        yield (topics != null) ? TopicsLoaded(topics) : TopicLoadFailed();
      } else if (event is CreateTopicEvent) {
        final createdTopic = await _repo.createTopic(
          author: event.author,
          name: event.name,
          description: event.description,
        );
        if (createdTopic == null) {
          yield TopicLoadFailed();
        }
        final topics = await _repo.getTopics();
        yield (topics != null) ? TopicsLoaded(topics) : TopicLoadFailed();
      }else if (event is UninitializeTopic){
        yield TopicsUninitialized();
      }
      else{
        yield TopicLoadFailed();
      }
    } catch (_) {
      yield TopicLoadFailed();
    }
  }
}
