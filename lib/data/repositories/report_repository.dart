import 'package:hopaut/data/models/bug.dart';
import 'package:hopaut/data/repositories/repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReportRepository extends Repository {
  ReportRepository() : super();

  /// Creates a post report
  ///
  /// This endpoint is used for reporting a post.
  void postReport(int postId, int reason, String message) {
    // TODO: Create a hashmap for reason (int) -> reason (String)
  }

  /// Creates a user report
  ///
  /// This endpoint is used for reporting a user.
  void userReport(String userId, int reason, String message) {
    // TODO: Create a hashmap for reason (int) -> reason (String)
  }

  /// Report a bug
  void bugReport(Bug bug) {}
}
