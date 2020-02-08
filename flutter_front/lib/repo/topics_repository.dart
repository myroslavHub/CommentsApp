import 'dart:convert';

import 'package:http/http.dart';

import '../models/topic.dart';

class TopicsRepository {
  static const _baseUrl = 'https://commentsapi.azurewebsites.net';

  final Client _httpClient = Client();

  Future<Topic> getTopic(int topicId) async {
    final locationUrl = '$_baseUrl/api/topics/$topicId';
    final response = await _httpClient.get(locationUrl);

    if (response.statusCode != 200) {
      return null;
    }
    final topicJson = json.decode(response.body);
    return Topic.fromJson(topicJson as Map<String, dynamic>);
  }

  Future<List<Topic>> getTopics() async {
    const locationUrl = '$_baseUrl/api/topics';
    final response = await _httpClient.get(locationUrl, headers: {'content-type': 'application/json'});

    if (response.statusCode != 200) {
      return null;
    }
    final topicJson = json.decode(response.body) as Iterable;

    return topicJson
        .map((t) => Topic.fromJson(t as Map<String, dynamic>))
        .toList();
  }

  Future<Topic> createTopic({String author, String name, String description}) async {
    
    final map = {
      'author': author,
      'name': name,
      'description' : description,
      'date': DateTime.now().toIso8601String()
    };
    final jsonTopic = json.encode(map);

    const locationUrl = '$_baseUrl/api/topics';

    final response = await _httpClient.post(locationUrl, body: jsonTopic, headers: {'content-type': 'application/json'},);

    if (response.statusCode != 201) {
      return null;
    }

    final topicJson = json.decode(response.body) as Map<String, dynamic>;

    return Topic.fromJson(topicJson);
  }

  Future<Topic> deleteTopic(int topicId) async {
    final locationUrl = '$_baseUrl/api/topics/$topicId';
    final response = await _httpClient.delete(locationUrl);

    if (response.statusCode != 200) {
      return null;
    }
    final topicJson = json.decode(response.body);
    return Topic.fromJson(topicJson as Map<String, dynamic>);
  }


}
