import 'dart:convert';

import 'package:http/http.dart';

import '../models/comment.dart';
import '../models/topic.dart';

class CommentsRepository {
  static const _baseUrl = 'https://commentsapi.azurewebsites.net';

  final Client _httpClient = Client();

  Future<List<Comment>> getComments(int topicId) async {
    var response = await _httpClient.get(
      '$_baseUrl/api/topics/$topicId',
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode != 200) {
      return null;
    }

    final topic =
        Topic.fromJson(json.decode(response.body) as Map<String, dynamic>);

    response = await _httpClient.get(
      '$_baseUrl/api/comments',
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode != 200) {
      return null;
    }
    final commentsJson = json.decode(response.body) as Iterable;

    return commentsJson
        .map((t) => Comment.fromJson(t as Map<String, dynamic>))
        .where((c) => topic.comments.any((com) => com.id == c.id))
        .toList();
  }

  Future<Comment> createCommentForComment(
      int commentId, String text, String author) async {
    final body = {
      'text': text,
      'author': author,
      'date': DateTime.now().toIso8601String()
    };
    final jsonBody = json.encode(body);
    final response = await _httpClient.post(
      '$_baseUrl/api/comments/Id?id=$commentId',
      body: jsonBody,
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode != 201) {
      return null;
    }

    return Comment.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  Future<int> createCommentForTopic(
      int topicId, String text, String author) async {
    final body = {
      'text': text,
      'author': author,
      'date': DateTime.now().toIso8601String()
    };
    final jsonBody = json.encode(body);

    final response = await _httpClient.post(
      '$_baseUrl/api/Topics/addcomment/Id?id=$topicId',
      body: jsonBody,
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode != 201) {
      return null;
    }
    return 5;
  }

  Future<int> updateComment(int commentId, String text) async {

    var response = await _httpClient.get(
      '$_baseUrl/api/comments/$commentId',
      headers: {'content-type': 'application/json'},
    );

    final comment =
        Comment.fromJson(json.decode(response.body) as Map<String, dynamic>);

    final body = {
      'id': commentId,
      'text': text,
      'likes':comment.likes,
      'author':comment.author,
      'date':comment.date.toIso8601String()
    };

    final jsonBody = json.encode(body);

    response = await _httpClient.put(
      '$_baseUrl/api/comments/$commentId',
      body: jsonBody,
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode != 204 && response.statusCode != 200 ) {
      return null;
    }
    return 5;
  }

  Future<int> likeComment(int commentId) async {
    var response = await _httpClient.get(
      '$_baseUrl/api/comments/$commentId',
      headers: {'content-type': 'application/json'},
    );
    final comment =
        Comment.fromJson(json.decode(response.body) as Map<String, dynamic>);

    //final body = {'id': commentId, 'likes': comment.likes + 1};
    final body = {
      'id': commentId,
      'text': comment.text,
        'likes':comment.likes + 1,
        'author':comment.author,
        'date':comment.date.toIso8601String()
    };
    final jsonBody = json.encode(body);
    response = await _httpClient.put(
      '$_baseUrl/api/comments/$commentId',
      body: jsonBody,
      headers: {'content-type': 'application/json'},
    );
    
    if (response.statusCode != 204) {
      return null;
    }
    return 5;
  }

  Future<int> dislikeComment(int commentId) async {
    var response = await _httpClient.get('$_baseUrl/api/comments/$commentId',
        headers: {'content-type': 'application/json'});
    final comment =
        Comment.fromJson(json.decode(response.body) as Map<String, dynamic>);
    
    final body = {
      'id': commentId,
      'text': comment.text,
        'likes':comment.likes - 1,
        'author':comment.author,
        'date':comment.date.toIso8601String()
    };
    final jsonBody = json.encode(body);
    response = await _httpClient.put('$_baseUrl/api/comments/$commentId',
        body: jsonBody, headers: {'content-type': 'application/json'});
    if (response.statusCode != 204) {
      return null;
    }
    return 5;
  }

  Future<Comment> deleteComment(int commentId) async {
    final locationUrl = '$_baseUrl/api/Comments/$commentId';
    final response = await _httpClient.delete(locationUrl);

    if (response.statusCode != 200) {
      return null;
    }

    final topicJson = json.decode(response.body);

    return Comment.fromJson(topicJson as Map<String, dynamic>);
  }
}
