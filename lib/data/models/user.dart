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
    if (this.firstName != null && this.firstName.trim().length != 0) data['FirstName'] = this.firstName.trim();
    if (this.lastName != null && this.lastName.trim().length != 0) data['LastName'] = this.lastName.trim();
    if (this.phoneNumber != null && this.phoneNumber.trim().length != 0) data['PhoneNumber'] = this.phoneNumber.trim();
    if (this.description != null && this.description.trim().length != 0) data['Description'] = this.description.trim();
    return data;
  }

  String get getFirstName => firstName ??= '';
  String get getLastName => lastName ??= '';
  String get fullName => "$getFirstName $getLastName".trim();

  String get getProfilePicture {
    if(profilePicture != null){
      if(profilePicture.startsWith("http")){ return profilePicture; }
      else {
        return "${webUrl['baseUrl']}${webUrl['profiles']}/$profilePicture.webp";
      }
    }
  }

  String get dateRegistered {
    var format = DateFormat("dd.MM.yyyy");
    return format.format(DateTime.fromMillisecondsSinceEpoch(registrationTimeStamp*1000));
  }
}