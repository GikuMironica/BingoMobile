import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/urls.dart';
import 'package:hopaut/data/models/mini_post.dart';
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
  Future<bool> update(Post post) async {

  }

  /// Delete Post
  Future<bool> delete(int postId) async {

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
  Future<Post> create(Post post, List images) async {
    try{
      FormData _data = FormData.fromMap(await post.toJson());
      Response response = await GetIt.I.get<DioService>().dio.post(apiUrl['posts'], data: _data, options: Options(headers: { '${HttpHeaders.contentTypeHeader}': 'multipart/form-data'}));
      if(response.statusCode == 201){
        Post post = Post.fromJson(response.data['Data']);
        return post;
      }
    } on DioError catch (e){
      print(e.response.statusMessage);
    }
  }
}