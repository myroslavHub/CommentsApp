import 'dart:convert';
import 'package:http/http.dart';

import '../models/comment.dart';

class CommentsRepository {
  static const _baseUrl = 'https://commentsapi.azurewebsites.net';

  final Client _httpClient = Client();

  Future<List<Comment>> getComments(int topicId) async {
    final response = await _httpClient.get(
      '$_baseUrl/api/Topics/$topicId/comments',
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode != 200) {
      return null;
    }

    final commentsJson = json.decode(response.body) as Iterable;

    return commentsJson
        .map((t) => Comment.fromJson(t as Map<String, dynamic>))
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
      '$_baseUrl/api/comments/$commentId',
      body: jsonBody,
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode != 201 && response.statusCode != 200 ) {
      return null;
    }

    return Comment.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  Future<Comment> createCommentForTopic(int topicId, String text, String author) async {
    final body = {
      'text': text,
      'author': author,
      'date': DateTime.now().toIso8601String()
    };
    final jsonBody = json.encode(body);

    final response = await _httpClient.post(
      '$_baseUrl/api/Comments/addfortopic/$topicId',
      body: jsonBody,
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode != 201) {
      return null;
    }
    return Comment.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  Future<Comment> updateComment(int commentId, String text) async {
    final body = {
      'text': text
    };

    final jsonBody = json.encode(body);

    final response = await _httpClient.put(
      '$_baseUrl/api/comments/update/$commentId',
      body: jsonBody,
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode != 201 && response.statusCode != 200 ) {
      return null;
    }

    return Comment.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  Future<Comment> likeComment(int commentId) async {
    final response = await _httpClient.put(
      '$_baseUrl/api/comments/like/$commentId',
      headers: {'content-type': 'application/json'},
    );
    
    if (response.statusCode != 201) {
      return null;
    }
    return Comment.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  Future<Comment> dislikeComment(int commentId) async {
    final response = await _httpClient.put(
      '$_baseUrl/api/comments/dislike/$commentId',
      headers: {'content-type': 'application/json'},
    );
    
    if (response.statusCode != 201) {
      return null;
    }
    return Comment.fromJson(json.decode(response.body) as Map<String, dynamic>);
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
