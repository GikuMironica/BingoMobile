import 'package:dio/dio.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/data/models/announcement.dart';
import 'package:hopaut/data/repositories/repository.dart';
import 'package:injectable/injectable.dart';

import '../models/announcement_message.dart';

/// Announcement Repository
/// -------------------------
/// :org: HopAut
/// :author: Braz Castana
///

@lazySingleton
class AnnouncementRepository extends Repository {
  AnnouncementRepository() : super();

  /// POST: This endpoint is used for updating an announcement.
  /// Can be updated only by event host.
  Future<bool> create(AnnouncementMessage announcement) async {
    Map<String, dynamic> payload = {
      'PostId': announcement.postId,
      'Message': announcement.text
    };

    try {
      final Response res = await dio.post(API.ANNOUNCEMENTS, data: payload);
      return res.statusCode == 201;
    } on DioError catch (e) {
      logger.e(e.message);
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
      final Response res = await dio
          .put('${API.ANNOUNCEMENTS}/${announcement.id}', data: payload);
      return res.statusCode == 200;
    } on DioError catch (e) {
      logger.e(e.message);
      return false;
    }
  }

  /// GET: This endpoint returns an announcement by Id.
  Future<AnnouncementMessage> get(int id) async {
    try {
      final Response res = await dio.get('${API.ANNOUNCEMENTS}/$id');
      if (res.statusCode == 200) {
        return AnnouncementMessage.fromJson(res.data['Data']);
      }
    } on DioError catch (e) {
      logger.e(e.message);
      return AnnouncementMessage.error(error: e.message);
    }
    return null;
  }

  /// DELETE: This endpoint is used to delete an announcement.
  ///
  /// Can only be deleted by event host.
  Future<bool> delete(int id) async {
    try {
      final Response res = await dio.delete('${API.ANNOUNCEMENTS}/$id');
      return res.statusCode == 204;
    } on DioError catch (e) {
      logger.e(e.message);
      return false;
    }
  }

  /// GET ALL: This endpoint is used to get all announcements related to a Post.
  /// Can be accessed by all users that are related to the post.
  Future<List<AnnouncementMessage>> getAll(int postId) async {
    try {
      final Response res = await dio.get('${API.POST_ANNOUNCEMENTS}/$postId');
      if (res.statusCode == 200) {
        Iterable iterable = res.data['Data'];
        return iterable.map((e) => AnnouncementMessage.fromJson(e)).toList();
      } else {
        return <AnnouncementMessage>[];
      }
    } on DioError catch (e) {
      logger.e(e.message);
      return [];
    }
  }

  Future<List<Announcement>> getInbox() async {
    try {
      final Response res = await dio.get(API.ANNOUNCEMENTS_INBOX);
      if (res.statusCode == 200) {
        Iterable iterable = res.data['Data'];
        return iterable.map((e) => Announcement.fromJson(e)).toList();
      } else {
        return <Announcement>[];
      }
    } on DioError catch (e) {
      logger.e(e.message);
      return [];
    }
  }

  Future<List<Announcement>> getOutbox() async {
    try {
      final Response res = await dio.get(API.ANNOUNCEMENTS_OUTBOX);
      if (res.statusCode == 200) {
        Iterable iterable = res.data['Data'];
        return iterable.map((e) => Announcement.fromJson(e)).toList();
      } else {
        return <Announcement>[];
      }
    } on DioError catch (e) {
      logger.e(e.message);
      return <Announcement>[];
    }
  }
}
