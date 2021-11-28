import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hopaut/config/constants/api.dart';
import 'package:hopaut/data/domain/request_result.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/models/search_query.dart';
import 'package:hopaut/data/repositories/repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class EventRepository extends Repository {
  EventRepository() : super();

  /// Get Post by Id
  Future<Post> get(int postId) async {
    try {
      Response response = await dio.get('${API.POSTS}/$postId');

      if (response.statusCode == 200) {
        return Post.fromJson(response.data['Data']);
      }
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return null;
  }

  Future<RequestResult> create(Post post) async {
    try {
      FormData _data = FormData.fromMap(await post.toMultipartJson(false));
      Response response = await dio.post(API.POSTS,
          data: _data,
          options: Options(headers: {
            '${HttpHeaders.contentTypeHeader}': 'multipart/form-data'
          }));
      if (response.statusCode == 201) {
        MiniPost post = MiniPost.fromJson(response.data['Data']);
        return RequestResult(data: post, isSuccessful: true);
      }
    } on DioError catch (e) {
      logger.e(e.response?.statusMessage);
      String errorMessage =
          "A connection to the server couldn't be established."; //TODO: translation
      switch (e.response?.statusCode) {
        case 400:
          errorMessage = "Invalid input."; //TODO: translation
          break;
        case 403:
          errorMessage =
              "You need to set your name to create an event."; //TODO: translation
      }
      return RequestResult(isSuccessful: false, errorMessage: errorMessage);
    } finally {
      dio.options.headers
          .addAll({Headers.contentTypeHeader: 'application/json'});
    }
    return null;
  }

  /// Update Post
  Future<RequestResult> update(Post post) async {
    try {
      FormData data = FormData.fromMap(await post.toMultipartJson(true));
      dio.options.headers.addAll({
        Headers.contentTypeHeader: 'multipart/form-data',
      });
      Response response = await dio.post(
        '${API.POSTS}/${post.id}',
        data: data,
      );
      if (response.statusCode == 200) {
        return RequestResult(isSuccessful: true);
      }
    } on DioError catch (e) {
      logger.e(e.response?.statusMessage);
      String errorMessage =
          "A connection to the server couldn't be established."; //TODO: translation
      switch (e.response?.statusCode) {
        case 400:
          errorMessage = "Invalid input."; //TODO: translation
          break;
        case 403:
          errorMessage =
              "You are not authorized for this action."; //TODO: translation
      }
      return RequestResult(isSuccessful: false, errorMessage: errorMessage);
    } finally {
      dio.options.headers
          .addAll({Headers.contentTypeHeader: 'application/json'});
    }
    return null;
  }

  /// Delete Post
  Future<RequestResult> delete(int postId) async {
    try {
      Response response = await dio.delete('${API.POSTS}/$postId');
      if (response.statusCode == 204) {
        return RequestResult(isSuccessful: true);
      }
    } on DioError catch (e) {
      logger.e(e.message);
      String errorMessage =
          "A connection to the server couldn't be established."; //TODO: translation
      switch (e.response?.statusCode) {
        case 400:
          errorMessage = "Bad request."; //TODO: translation
          break;
        case 403:
          errorMessage =
              "You need to be the host in order to delete this event."; //TODO: translation
          break;
        case 404:
          errorMessage =
              "The event you are trying to delete wasn't found."; //TODO: translation
      }
      return RequestResult(isSuccessful: false, errorMessage: errorMessage);
    }
    return null;
  }

  /// Search for posts.
  Future<List<MiniPost>> search(SearchQuery searchQuery) async {
    try {
      Response response =
          await dio.get('${API.POSTS}?${searchQuery.toString()}');

      if (response.data is Map<String, dynamic>) {
        Iterable iterable = response.data['Data'];
        return iterable.map((e) => MiniPost.fromJson(e)).toList();
      }
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return null;
  }

  Future<bool> changeAttendanceStatus(int postId, String endpoint) async {
    try {
      Response response = await dio.post('$endpoint/$postId');
      return response.statusCode == 200;
    } on DioError catch (e) {
      logger.e(e.response.data);
      return false;
    }
  }

  Future<Map<String, dynamic>> getAttendees(int postId) async {
    try {
      Response response = await dio.get('${API.PARTICIPANTS}?PostId=$postId');
      if (response.statusCode == 200) {
        return response.data['Data'];
      }
    } on DioError catch (e) {
      logger.e(e.response.statusMessage);
    }
    return {};
  }

  Future<List<MiniPost>> getEventMiniPosts(String endpoint) async {
    try {
      Response response = await dio.get(endpoint);
      if (response.statusCode == 200) {
        Iterable iterable = response.data['Data'];
        return iterable.map((e) => MiniPost.fromJson(e)).toList();
      }
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return null;
  }
}
