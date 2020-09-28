import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/data/models/announcement.dart';
import 'package:hopaut/presentation/screens/events/event_list/past_events.dart';
import 'package:hopaut/services/dio_service/dio_service.dart';

import '../../config/urls.dart';
import '../models/announcement_message.dart';

/// Announcement Repository
/// -------------------------
/// :org: HopAut
/// :author: Braz Castana
///

class AnnouncementRepository {
  /// POST: This endpoint is used for updating an announcement.
  /// Can be updated only by event host.
  Future<bool> create(AnnouncementMessage announcement) async {
    Map<String, dynamic> payload = {
      'PostId': announcement.postId, 
      'Message': announcement.text
    };

    try {
      final Response res = await GetIt.I.get<DioService>().dio.post(
          apiUrl['announcement'], data: payload
      );
      return res.statusCode == 201;
    } on DioError catch(e) {
      print('Error: '  + e.message);
      return false;
    }
  }

  /// PUT: This endpoint is used for updating an announcement.
  /// Can be updated only by event host.
  Future<bool> update(AnnouncementMessage announcement) async {
    Map<String, dynamic> payload = {
      'Message': announcement.text,
    };

    try {
      final Response res = await GetIt.I.get<DioService>().dio.put(
        '${apiUrl['announcement']}/${announcement.id}',
        data: payload
      );
      return res.statusCode == 200;
    } on DioError catch(e) {
      print('Error: ' + e.message);
      return false;
    }
  }

  /// GET: This endpoint returns an announcement by Id.
  Future<AnnouncementMessage> get(int id) async {
    try {
      final Response res = await GetIt.I.get<DioService>().dio.get(
          '${apiUrl['announcement']}/$id',
      );
      if(res.statusCode == 200){
        return AnnouncementMessage.fromJson(res.data['Data']);
      }
    } on DioError catch(e) {
      print('Error: ' + e.message);
      return AnnouncementMessage.error(error: e.message);
    }
  }

  /// DELETE: This endpoint is used to delete an announcement.
  ///
  /// Can only be deleted by event host.
  Future<bool> delete(int id) async {
    try {
      final Response res = await GetIt.I.get<DioService>().dio.delete(
        '${apiUrl['announcement']}/$id',
      );
      return res.statusCode == 204;
    } on DioError catch (e) {
      print('Error: ' + e.message);
      return false;
    }
  }

  /// GET ALL: This endpoint is used to get all announcements related to a Post.
  /// Can be accessed by all users that are related to the post.
  Future<List<AnnouncementMessage>> getAll(int postId) async {
    try {
      final Response res = await GetIt.I.get<DioService>().dio.get(
        '${apiUrl['announcementsByPost']}/$postId',
      );
      if(res.statusCode == 200){
        Iterable iterable = res.data['Data'];
        return iterable.map((e) => AnnouncementMessage.fromJson(e)).toList();
      } else {
        return <AnnouncementMessage>[];
      }
    } on DioError catch(e) {
      print('Error: ' + e.message);
      return [];
    }
  }

  Future<List<Announcement>> getInbox() async {
    try {
      final Response res = await GetIt.I.get<DioService>().dio.get(
        apiUrl['announcementsInbox']
      );
      if(res.statusCode == 200){
        Iterable iterable = res.data['Data'];
        return iterable.map((e) => Announcement.fromJson(e)).toList();
      } else {
        return <Announcement>[];
      }
    } on DioError catch (e) {
      print('Error: ' + e.message);
      return [];
    }
  }

  Future<List<Announcement>> getOutbox() async {
    try {
      final Response res = await GetIt.I.get<DioService>().dio.get(
          apiUrl['announcementsOutbox']
      );
      if(res.statusCode == 200){
        Iterable iterable = res.data['Data'];
        return iterable.map((e) => Announcement.fromJson(e)).toList();
      } else {
        return <Announcement>[];
      }
    } on DioError catch (e) {
      print('Error: ' + e.message);
      return <Announcement>[];
    }
  }
}