import '../../config/urls.dart';
import 'package:intl/intl.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String profilePicture;
  String phoneNumber;
  String email;
  String description;
  int registrationTimeStamp;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.profilePicture,
        this.phoneNumber,
        this.email,
        this.description,
        this.registrationTimeStamp});

  User.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    profilePicture = json['ProfilePicture'];
    phoneNumber = json['PhoneNumber'];
    email = json['Email'];
    description = json['Description'];
    registrationTimeStamp = json['RegistrationTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['ProfilePicture'] = this.profilePicture;
    data['PhoneNumber'] = this.phoneNumber;
    data['Description'] = this.description;
    return data;
  }

  String get getFirstName => firstName ??= '';
  String get getLastName => lastName ??= '';
  String get getDescription => description ??= 'You have not set your description as yet';
  String get fullName => "$getFirstName $getLastName".trim();

  String get getProfilePicture {
    if(profilePicture != null){
      if(profilePicture.startsWith("http")){ return profilePicture; }
      else {
        return "${webUrl['baseUrl']}/assets/profile/$profilePicture.webp";
      }
    }
  }

  String get dateRegistered {
    var format = DateFormat("dd.MM.yyyy");
    return format.format(DateTime.fromMillisecondsSinceEpoch(registrationTimeStamp*1000));
  }
}