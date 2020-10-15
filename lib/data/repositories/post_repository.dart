import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/multipart/updated_post.dart';
import 'package:hopaut/data/models/search_query.dart';
import 'package:hopaut/services/dio_service/dio_service.dart';
import 'package:hopaut/services/logging_service/logging_service.dart';

import '../models/post.dart';

class PostRepository {
  Logger _logger = GetIt.I.get<LoggingService>().getLogger(PostRepository);
  Dio _dio = GetIt.I.get<DioService>().dio;
  String _endpoint = API.POSTS;
  /// Get Post by Id
  Future<Post> get(int postId) async {
    try {
      Response response =
          await _dio.get('$_endpoint/$postId');

      if (response.statusCode == 200) {
        return Post.fromJson(response.data['Data']);
      }
    } on DioError catch (e) {
      _logger.e(e.message);
    }
  }

  /// Update Post
  Future<bool> update(int postId, Map<String, dynamic> newValues) async {
    try {
      FormData _data = FormData.fromMap(await MultiPartUpdatedPost(newValues));
      Response response = await _dio.post(
          '$_endpoint/$postId',
          data: _data,
          options: Options(headers: {
            '${HttpHeaders.contentTypeHeader}': 'multipart/form-data'
          }));
      return response.statusCode == 200;
    } on DioError catch (e) {
      _logger.e(e.response.statusMessage);
      return false;
    }
  }

  Future<Map<String, dynamic>> getAttendees(int postId) async {
    try {
      Response response = await _dio.get('${API.PARTICIPANTS}?PostId=$postId');
      if (response.statusCode == 200) {
        return response.data['Data'];
      } else {
        return {};
      }
    } on DioError catch (e) {}
  }

  /// Delete Post
  Future<bool> delete(int postId) async {
    try {
      Response response = await _dio.delete('$_endpoint/$postId');
      if (response.statusCode == 204) {
        return true;
      }
    } on DioError catch (e) {
      _logger.e(e.message);
      return false;
    }
  }

  /// Get the user's active hosted events
  Future<List<MiniPost>> getUserActive() async {
    try {
      Response response =
          await _dio.get(API.MY_ACTIVE);
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          Iterable iterable = response.data['Data'];
          return iterable.map((e) => MiniPost.fromJson(e)).toList();
        }
      }
    } on DioError catch (e) {
      _logger.e(e.message);
    }
  }

  /// Get user's inactive hosted events.
  Future<List<MiniPost>> getUserInactive() async {
    try {
      Response response =
          await _dio.get(API.MY_INACTIVE);
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          Iterable iterable = response.data['Data'];
          return iterable.map((e) => MiniPost.fromJson(e)).toList();
        }
      }
    } on DioError catch (e) {
      _logger.e(e.message);
    }
  }

  /// Search for posts.
  Future<List<MiniPost>> search(SearchQuery searchQuery) async {
    try {
      Response response = await _dio.get('$_endpoint?${searchQuery.toString()}');

      if (response.data is Map<String, dynamic>) {
        Iterable iterable = response.data['Data'];
        return iterable.map((e) => MiniPost.fromJson(e)).toList();
      }
    } on DioError catch (e) {
      _logger.e(e.message);
    }
  }

  /// Endpoint for creating a post.
  ///
  /// Must be multi-part form.
  Future<MiniPost> create(Post post, List images) async {
    try {
      FormData _data = FormData.fromMap(await post.toMultipartJson());
      Response response = await _dio.post(
          _endpoint,
          data: _data,
          options: Options(headers: {
            '${HttpHeaders.contentTypeHeader}': 'multipart/form-data'
          }));
      if (response.statusCode == 201) {
        MiniPost post = MiniPost.fromJson(response.data['Data']);
        return post;
      }
    } on DioError catch (e) {
      _logger.e(e.response.statusMessage);
    }
  }
}
