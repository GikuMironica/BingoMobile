import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/urls.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/multipart/updated_post.dart';
import 'package:hopaut/data/models/search_query.dart';
import 'package:hopaut/services/dio_service/dio_service.dart';

import '../models/post.dart';

class PostRepository {
  /// Get Post by Id
  Future<Post> get(int postId) async {
    try {
      Response response = await GetIt.I
          .get<DioService>()
          .dio
          .get('${apiUrl['posts']}/$postId');
      
      if (response.statusCode == 200){
        return Post.fromJson(response.data['Data']);
      }
    } on DioError catch(e){
    }
  }

  /// Update Post
  Future<bool> update(int postId, Map<String, dynamic> newValues) async {
    try{
      FormData _data = FormData.fromMap(await MultiPartUpdatedPost(newValues));
      Response response = await GetIt.I.get<DioService>().dio.post('${apiUrl['posts']}/$postId', data: _data, options: Options(headers: { '${HttpHeaders.contentTypeHeader}': 'multipart/form-data'}));
      return response.statusCode == 200;
    } on DioError catch (e){
      print(e.response.statusMessage);
      return false;
    }
  }

  Future<Map<String, dynamic>> getAttendees(int postId) async {
    try{
      Response response = await GetIt.I.get<DioService>().dio.get('${apiUrl['participants']}?PostId=$postId');
      if(response.statusCode == 200){
        return response.data['Data'];
      }else{
        return {};
      }
    } on DioError catch (e) {

    }
  }

  /// Delete Post
  Future<bool> delete(int postId) async {
    try {
      Response response = await GetIt.I.get<DioService>().dio.delete('${apiUrl['posts']}/$postId');
      if(response.statusCode == 204){
        return true;
      }
    } on DioError catch(e) {
      return false;
    }
  }

  /// Get the user's active hosted events
  Future<List<MiniPost>> getUserActive() async {
    try {
      Response response = await GetIt.I.get<DioService>().dio.get('${apiUrl['my_active']}');
      if(response.statusCode == 200){
        if(response.data is Map<String,dynamic>){
          Iterable iterable = response.data['Data'];
          return iterable.map((e) => MiniPost.fromJson(e)).toList();
        }
      }
    } on DioError catch(e){

    }
  }

  /// Get user's inactive hosted events.
  Future<List<MiniPost>> getUserInactive() async{
    try{
      Response response = await GetIt.I.get<DioService>().dio.get('${apiUrl['my_inactive']}');
      if(response.statusCode == 200){
        if(response.data is Map<String,dynamic>){
          Iterable iterable = response.data['Data'];
          return iterable.map((e) => MiniPost.fromJson(e)).toList();
        }
      }
    } on DioError catch(e){

    }

  }

  /// Search for posts.
  Future<List<MiniPost>> search(SearchQuery searchQuery) async {
    try {
      Response response = await GetIt.I
          .get<DioService>()
          .dio
          .get('${apiUrl['posts']}?${searchQuery.toString()}');

      if(response.data is Map<String, dynamic>){
        Iterable iterable = response.data['Data'];
        return iterable.map((e) => MiniPost.fromJson(e)).toList();
      }
    }on DioError catch(e) {

    }
  }

  /// Endpoint for creating a post.
  ///
  /// Must be multi-part form.
  Future<MiniPost> create(Post post, List images) async {
    try{
      FormData _data = FormData.fromMap(await post.toMultipartJson());
      Response response = await GetIt.I.get<DioService>().dio.post(apiUrl['posts'], data: _data, options: Options(headers: { '${HttpHeaders.contentTypeHeader}': 'multipart/form-data'}));
      if(response.statusCode == 201){
        MiniPost post = MiniPost.fromJson(response.data['Data']);
        return post;
      }
    } on DioError catch (e){
      print(e.response.statusMessage);
    }
  }
}