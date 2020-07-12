import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/urls.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/searchQuery.dart';
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
        return Post.fromJson(response.data['data']);
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
  void getUserActive(){

  }

  /// Get user's inactive hosted events.
  void getUserInactive(){

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
  Future<Post> create(Post post){

  }
}