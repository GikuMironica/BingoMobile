import '../../config/urls.dart';

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

  String get getProfilePicture =>
      "${webUrl['baseUrl']}/assets/profiles/$profilePicture.webp";
}