import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hopaut/config/constants/api.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/models/search_query.dart';
import 'package:hopaut/data/models/updated_post.dart';
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

  Future<MiniPost> create(Post post) async {
    try {
      FormData _data = FormData.fromMap(await post.toMultipartJson());
      Response response = await dio.post(API.POSTS,
          data: _data,
          options: Options(headers: {
            '${HttpHeaders.contentTypeHeader}': 'multipart/form-data'
          }));
      if (response.statusCode == 201) {
        MiniPost post = MiniPost.fromJson(response.data['Data']);
        return post;
      }
    } on DioError catch (e) {
      logger.e(e.response.statusMessage);
    }
    return null;
  }

  /// Update Post
  Future<bool> update(Post post) async {
    try {
      FormData data = FormData.fromMap(await post.toMultipartJson());
      dio.options.headers.addAll({
        Headers.contentTypeHeader: 'multipart/form-data',
      });
      Response response = await dio.post(
        '${API.POSTS}/${post.id}',
        data: data,
      );
      return response.statusCode == 200;
    } on DioError catch (e) {
      logger.e(e.response.statusMessage);
      return false;
    } finally {
      dio.options.headers
          .addAll({Headers.contentTypeHeader: 'application/json'});
    }
  }

  /// Delete Post
  Future<bool> delete(int postId) async {
    try {
      Response response = await dio.delete('${API.POSTS}/$postId');
      if (response.statusCode == 204) {
        return true;
      }
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return false;
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
