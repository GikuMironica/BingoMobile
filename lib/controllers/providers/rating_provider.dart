import 'package:flutter/cupertino.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/rating.dart';
import 'package:hopaut/data/repositories/rating_repository.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:injectable/injectable.dart';
import 'page_states/base_form_status.dart';

@lazySingleton
class RatingProvider with ChangeNotifier {
  // validation rules
  static final reportTextAreaLength = 300;

  // state
  BaseFormStatus ratingFormStatus = Idle();
  int rating = 0;

  // repo
  RatingRepository ratingRepository = getIt<RatingRepository>();

  bool validateBugField(String text) {
    return text.characters.length <= 300 && text.characters.length > 0;
  }

  Future<void> rateUserAsync(
      String message, int postId, BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    ratingFormStatus = Submitted();
    notifyListeners();

    Rating rate = Rating(
        feedback: message, rate: this.rating, postId: postId, userId: '');

    var rateJson = rate.toJson();

    var result = await ratingRepository.create(rateJson);

    if (!result.isSuccessful) {
      ratingFormStatus = Failed(errorMessage: result.errorMessage);
      notifyListeners();
      return;
    }

    ratingFormStatus = Idle();
    notifyListeners();
    Application.router.pop(context, true);
    // Application.pop
  }

  void onRatingMessageChange(String v, TextEditingController ratingController) {
    ratingController.text = v;
    notifyListeners();
  }

  bool validateFeedback(String feedback) {
    return feedback.characters.length <= reportTextAreaLength &&
        feedback.characters.length > 0;
  }

  void onRatingChanged(int rating) {
    this.rating = rating;
    notifyListeners();
  }
}
