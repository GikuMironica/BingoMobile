import '../models/announcement_message.dart';

/// Announcement Repository
/// -------------------------
/// :org: HopAut
/// :author: Braz Castana
///

class AnnouncementRepository {
  /// PUT: This endpoint is used for updating an announcement.
  /// Can be updated only by event host.
  void create(AnnouncementMessage announcement){

  }

  /// GET: This endpoint returns an announcement by Id.
  void get(int id){
    // TODO: Insert logic here.
  }

  /// DELETE: This endpoint is used to delete an announcement.
  ///
  /// Can only be deleted by event host.
  void delete(int id){
    // TODO: Insert logic here.
  }

  /// GET ALL: This endpoint is used to get all announcements related to a Post.
  /// Can be accessed by all users that are related to the post.
  void getAll(int postId){
    // TODO: Insert logic here.
  }
}