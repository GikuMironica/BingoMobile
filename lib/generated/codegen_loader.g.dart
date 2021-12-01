// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> de = {
  "Map": {
    "Event": {}
  },
  "Hosted": {
    "Create": {},
    "Edit": {}
  },
  "Joined": {},
  "Account": {
    "AccountPage": {
      "label_MemberSince": "Mitglied seit",
      "navigationLabel_EditProfile": "Profil bearbeiten",
      "navigationLabel_Settings": "Einstellungen",
      "placeholder_NameSurname": "Name Nachname",
      "label_Email": "Email",
      "label_PhoneNumber": "Mobil"
    },
    "EditProfile": {
      "navigationLabel_PhoneNumber": "Mobil",
      "navigationLabel_EditName": "Name",
      "navigationLabel_EditDescription": "Profilbeschreibung",
      "navigationLabel_EditProfilePicture": "Profilbild ändern",
      "pageTitle": "Profil bearbeiten",
      "placeholder_EmptyDescription": "Leer",
      "successToast_ProfileUpdated": "Profil wurde aktualisiert",
      "EditMobile": {
        "pageTitle": "Bestätigen Sie Ihre Rufnummer",
        "label_verifyNumberInfo": "Sie erhalten eine SMS-Nachricht (es können Gebühren anfallen) zur Bestätigung Ihrer Telefonnummer. Geben Sie Ihre Telefonnummer ein.",
        "errorToast_Error": "Fehler, etwas ist schief gelaufen",
        "hintLabel_PhoneNumber": "Rufnummer",
        "validationLabel_InvalidNumber": "Ungültige Rufnummer",
        "button_Next": "Weiter"
      }
    },
    "Settings": {}
  },
  "Authentication": {
    "Register": {},
    "Login": {},
    "ForgotPassword": {}
  }
};
static const Map<String,dynamic> en = {
  "Map": {
    "Event": {}
  },
  "Hosted": {
    "Create": {},
    "Edit": {}
  },
  "Joined": {},
  "Account": {
    "AccountPage": {
      "label_MemberSince": "Member since",
      "navigationLabel_EditProfile": "Edit Profile",
      "navigationLabel_Settings": "Settings",
      "placeholder_NameSurname": "Name Surname",
      "label_Email": "Email",
      "label_PhoneNumber": "Mobile"
    },
    "EditProfile": {
      "navigationLabel_PhoneNumber": "Mobile",
      "navigationLabel_EditName": "Name",
      "navigationLabel_EditDescription": "Profile description",
      "navigationLabel_EditProfilePicture": "Change profile picture",
      "pageTitle": "Edit Profile",
      "placeholder_EmptyDescription": "Empty",
      "successToast_ProfileUpdated": "Profile updated",
      "EditMobile": {
        "pageTitle": "Confirm your phone number",
        "label_verifyNumberInfo": "You will get an SMS message (carrier charges may apply) to confirm your phone number. Enter your phone number.",
        "errorToast_Error": "Error, something went wrong",
        "hintLabel_PhoneNumber": "Phone number",
        "validationLabel_InvalidNumber": "Invalid phone number",
        "button_Next": "Next"
      }
    },
    "Settings": {}
  },
  "Authentication": {
    "Register": {},
    "Login": {},
    "ForgotPassword": {}
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"de": de, "en": en};
}
