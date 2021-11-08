import 'package:hopaut/config/constants.dart';

class Profile {
  String firstName;
  String lastName;
  String profilePicture;
  String description;

  Profile(
      {this.firstName, this.lastName, this.profilePicture, this.description});

  Profile.fromJson(Map<String, dynamic> json) {
    firstName = json['FirstName'];
    lastName = json['LastName'];
    profilePicture = json['ProfilePicture'];
    description = json['Description'];
  }

  String get getFullName => "$firstName $lastName";

  String get getInitials =>
      "${firstName.substring(0, 1)}${lastName.substring(0, 1)}";

  String get getProfilePicture {
    if (profilePicture != null) {
      if (profilePicture.startsWith("http")) {
        return profilePicture;
      } else {
        return "${WEB.PROFILE_PICTURES}/$profilePicture.webp";
      }
    }
    return null;
  }
}
