///  models/user.dart
///  ------------------------
///  User class
///
///  Author:           Braz Castana
///  Date Created:     22.05.2020  7:04 GMT +1
///  Last Modified:    -

class User {
  String firstName;
  String lastName;
  String profilePicture;
  String phoneNumber;
  String email;
  String description;

  User(
      this.firstName,
      this.lastName,
      this.profilePicture,
      this.description,
      this.email,
      this.phoneNumber
      );

  User.fromJson(Map<String, dynamic> json){
    firstName = json['firstName'];
    lastName = json['lastName'];
    profilePicture = json['profilePicture'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    description = json['description'];
  }

  String get getFirstName {
    return firstName;
  }

  String get getLastName {
    return lastName;
  }

  String get getFullName {
    return "$firstName $lastName";
  }

  String get getProfilePicture {
    return profilePicture;
  }

  String get getProfilePictureUrl {
    return "/user-images/$profilePicture.webp";
  }

  String get getEmail {
    return email;
  }

  String get getDescription {
    return description;
  }
}