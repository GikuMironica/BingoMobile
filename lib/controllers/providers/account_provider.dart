import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/data/domain/request_result.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/data/repositories/user_repository.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AccountProvider extends ChangeNotifier {
  // validation rules
  static final namesMaxLength = 20;
  static final RegExp _regExp = RegExp(r"^[\p{L} ,.'-]*$",
      caseSensitive: false, unicode: true, dotAll: true);

  // State data
  BaseFormStatus formStatus;
  BaseFormStatus picturesPageStatus;

  // Services, repositories and models
  AuthenticationService _authenticationService;
  UserRepository _userRepository;
  User get currentIdentity => _authenticationService.user;

  AccountProvider() {
    _authenticationService = getIt<AuthenticationService>();
    _userRepository = getIt<UserRepository>();
    formStatus = Idle();
    picturesPageStatus = Idle();
  }

  Future<void> updateUserNameAsync(
      String firstName, String lastName, BuildContext context) async {
    bool firstNameChanged = currentIdentity.firstName != firstName;
    bool lastNameChanged = currentIdentity.lastName != lastName;

    if ((!firstNameChanged && !lastNameChanged) ||
        (firstName == "") && (lastName == "")) {
      Application.router.pop(context);
    } else {
      formStatus = Submitted();
      notifyListeners();
      User tempUser = User(firstName: firstName, lastName: lastName);
      User updatedUser =
          await _userRepository.update(currentIdentity.id, tempUser);
      if (updatedUser == null) {
        formStatus = new Failed();
        notifyListeners();
      } else {
        formStatus = Idle();
        _authenticationService.setUser(updatedUser);
        Application.router.pop(context, Success());
      }
    }
  }

  Future<void> updateDescriptionAsync(
      String newDescription, BuildContext context) async {
    bool descriptionHasChanged = currentIdentity.description != newDescription;

    if (!descriptionHasChanged) {
      Application.router.pop(context);
    } else {
      formStatus = Submitted();
      notifyListeners();
      User tempUser = User(description: newDescription);
      var response = await _userRepository.update(currentIdentity.id, tempUser);

      if (response == null) {
        formStatus = Failed();
        notifyListeners();
      } else {
        formStatus = Idle();
        _authenticationService.setUser(response);
        Application.router.pop(context, Success());
      }
    }
  }

  void navigateToConfirmPhone(BuildContext context, String number) {
    Application.router
        .navigateTo(context, "", transition: TransitionType.cupertino);
  }

  Future<bool> deleteProfilePictureAsync(String userId) async {
    if (currentIdentity.profilePicture != null) {
      var response = await _userRepository.deletePicture(userId);
      currentIdentity.profilePicture = null;
      _authenticationService.setUser(currentIdentity);
      notifyListeners();
      return response;
    }
    return true;
  }

  Future<RequestResult> uploadProfilePictureAsync(
      String fileAbsolutePath) async {
    var result = await _userRepository.uploadPicture(currentIdentity.id,
        imagePath: fileAbsolutePath);
    if (result.isSuccessful) {
      if (result.data != null) {
        User user = result.data;
        _authenticationService.setUser(user);
        return result;
      } else {
        // TODO Translation, to log
        return RequestResult(
            data: null, isSuccessful: false, errorMessage: "An error occurred");
      }
    } else {
      return result;
    }
  }

  /// Validation Methods
  bool validateFirstName(String value) {
    return _regExp.hasMatch(value) &&
        value.isNotEmpty &&
        value.characters.length < namesMaxLength;
  }

  bool validateLastName(String value) {
    return _regExp.hasMatch(value) &&
        value.isNotEmpty &&
        value.characters.length < namesMaxLength;
  }

  bool validateDescription(String value, int maxlength) {
    return value.characters.length <= maxlength;
  }

  /// On Change Methods
  void onFirstNameChange(String value, TextEditingController controller) {
    controller.text = value;
    notifyListeners();
  }

  void onLastNameChange(String value, TextEditingController controller) {
    controller.text = value;
    notifyListeners();
  }

  void onDescriptionChange(String value, TextEditingController controller) {
    controller.text = value;
    notifyListeners();
  }

  void resetProvider() {
    formStatus = Idle();
    picturesPageStatus = Idle();
  }
}
