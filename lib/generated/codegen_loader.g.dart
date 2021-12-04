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
    "Create": {
      "header": {
        "title": "Veranstaltung erstellen"
      },
      "labels": {
        "pictures": "Bilder",
        "title": "Titel",
        "type": "Typ",
        "location": "Standort",
        "time": "Zeit",
        "tags": "Tag",
        "description": "Beschreibung",
        "requirements": "Anforderungen",
        "creating": "Veranstaltung erstellen",
        "guests": "Anzahl der Gäste",
        "price": "Eintrittspreis"
      },
      "hints": {
        "eventType": "Veranstaltungstyp",
        "startTime": "Startzeit",
        "endTime": "Endzeit",
        "tagsLimit": "Sie können bis zu 5 Tags hinzufügen.",
        "addTags": "Tags hinzufügen"
      },
      "btns": {
        "create": "Erstellen"
      },
      "validation": {
        "title": "Bitte geben Sie einen gültigen Titel an.",
        "eventType": "Veranstaltungstyp ist erforderlich.",
        "location": "Bitte wählen Sie einen Standort.",
        "time": "Start- und Endzeit sind erforderlich.",
        "description": "Bitte geben Sie eine gültige Beschreibung an."
      },
      "eventTypes": {
        "houseParty": "Hausparty",
        "club": "Club",
        "bar": "Bar",
        "bikerMeet": "Bikertreffen",
        "bicycleMeet": "Fahrradtreffen",
        "carMeet": "Autotreffen",
        "streetParty": "Straßenparty",
        "sport": "Sport",
        "others": "Sonstiges"
      }
    },
    "Edit": {
      "labels": {
        "updatingEvent": "Aktualisierung der Veranstaltung"
      },
      "btns": {
        "pictures": "Bilder",
        "title": "Titel",
        "location": "Standort",
        "time": "Zeit",
        "description": "Beschreibung",
        "requirements": "Anforderungen",
        "tags": "Tags",
        "update": "Aktualisieren",
        "places": "Freie Plätze",
        "price": "Eintrittspreis"
      },
      "header": {
        "editEvent": "Veranstaltung bearbeiten",
        "editPictures": "Bilder bearbeiten",
        "editTitle": "Titel bearbeiten",
        "editTime": "Zeit bearbeiten",
        "editDescription": "Beschreibung bearbeiten",
        "editRequirements": "Anforderungen bearbeiten",
        "editTags": "Tags bearbeiten",
        "editPrice": "Preis bearbeiten",
        "editPlaces": "Verfügbare Plätze bearbeiten"
      },
      "toasts": {
        "eventUpdated": "Veranstaltung aktualisiert."
      }
    },
    "header": {
      "title": "Gehaltene Veranstaltungen"
    }
  },
  "Joined": {
    "header": {
      "title": "Verbundene Veranstaltungen",
      "currentTab": "Aktuelle",
      "pastTab": "Vergangene"
    },
    "labels": {
      "noEventsFound": "Keine Veranstaltungen gefunden",
      "loading": "Veranstaltungen laden."
    }
  },
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
    "Create": {
      "header": {
        "title": "Create Event"
      },
      "labels": {
        "pictures": "Pictures",
        "title": "Title",
        "type": "Type",
        "location": "Location",
        "time": "Time",
        "tags": "Tags",
        "description": "Description",
        "requirements": "Requirements",
        "creating": "Creating event",
        "guests": "Number of guests",
        "price": "Entrance price"
      },
      "hints": {
        "eventType": "Event Type",
        "startTime": "End Time",
        "endTime": "End Time",
        "tagsLimit": "You can add up to 5 tags.",
        "addTags": "Add Tags"
      },
      "btns": {
        "create": "Create"
      },
      "validation": {
        "title": "Please provide a valid title.",
        "eventType": "Event type is required.",
        "location": "Please choose a location.",
        "time": "Start and end time is required.",
        "description": "Please provide a valid description."
      },
      "eventTypes": {
        "houseParty": "House Party",
        "club": "Club",
        "bar": "Bar",
        "bikerMeet": "Biker Meet",
        "bicycleMeet": "Bicycle Meet",
        "carMeet": "Car Meet",
        "streetParty": "Street Party",
        "sport": "Sport",
        "others": "Other"
      }
    },
    "Edit": {
      "labels": {
        "updatingEvent": "Updating event."
      },
      "btns": {
        "pictures": "Pictures",
        "title": "Title",
        "location": "Location",
        "time": "Time",
        "description": "Description",
        "requirements": "Requirements",
        "tags": "Tags",
        "update": "Update",
        "places": "Available Places",
        "price": "Entrance Price"
      },
      "header": {
        "editEvent": "Edit Event",
        "editPictures": "Edit Pictures",
        "editTitle": "Edit Title",
        "editTime": "Edit Time",
        "editDescription": "Edit Description",
        "editRequirements": "Edit Requirements",
        "editTags": "Edit Tags",
        "editPrice": "Edit Price",
        "editPlaces": "Edit Available Places"
      },
      "toasts": {
        "eventUpdated": "Event updated."
      }
    },
    "header": {
      "title": "Hosted Events"
    }
  },
  "Joined": {
    "header": {
      "title": "Joined Events",
      "currentTab": "Current",
      "pastTab": "Past"
    },
    "labels": {
      "noEventsFound": "No events found",
      "loading": "Loading events."
    }
  },
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
