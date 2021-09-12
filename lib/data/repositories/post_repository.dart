import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/updated_post.dart';
import 'package:hopaut/data/models/search_query.dart';
import 'package:hopaut/data/repositories/repository.dart';
import 'package:injectable/injectable.dart';

import '../models/post.dart';

@lazySingleton
class PostRepository extends Repository {
  final String _endpoint = API.POSTS;

  PostRepository() : super();

  /// Get Post by Id
  Future<Post> get(int postId) async {
    try {
      Response response = await dio.get('$_endpoint/$postId');

      if (response.statusCode == 200) {
        return Post.fromJson(response.data['Data']);
      }
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return null;
  }

  /// Update Post
  Future<bool> update(int postId, Map<String, dynamic> newValues) async {
    try {
      FormData data = FormData.fromMap(await multiPartUpdatedPost(newValues));
      dio.options.headers.addAll({
        Headers.contentTypeHeader: 'multipart/form-data',
      });
      Response response = await dio.post(
        '$_endpoint/$postId',
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

  /// Delete Post
  Future<bool> delete(int postId) async {
    try {
      Response response = await dio.delete('$_endpoint/$postId');
      if (response.statusCode == 204) {
        return true;
      }
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return false;
  }

  /// Get the user's active hosted events
  Future<List<MiniPost>> getUserActive() async {
    try {
      Response response = await dio.get(API.MY_ACTIVE);
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          Iterable iterable = response.data['Data'];
          return iterable.map((e) => MiniPost.fromJson(e)).toList();
        }
      }
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return null;
  }

  /// Get user's inactive hosted events.
  Future<List<MiniPost>> getUserInactive() async {
    try {
      Response response = await dio.get(API.MY_INACTIVE);
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          Iterable iterable = response.data['Data'];
          return iterable.map((e) => MiniPost.fromJson(e)).toList();
        }
      }
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return null;
  }

  /// Search for posts.
  Future<List<MiniPost>> search(SearchQuery searchQuery) async {
    try {
      Response response = await dio.get('$_endpoint?${searchQuery.toString()}');

      if (response.data is Map<String, dynamic>) {
        Iterable iterable = response.data['Data'];
        return iterable.map((e) => MiniPost.fromJson(e)).toList();
      }
    } on DioError catch (e) {
      logger.e(e.message);
    }
    return null;
  }

  /// Endpoint for creating a post.
  ///
  /// Must be multi-part form.
  Future<MiniPost> create(Post post, List images) async {
    try {
      FormData _data = FormData.fromMap(await post.toMultipartJson());
      Response response = await dio.post(_endpoint,
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
}
