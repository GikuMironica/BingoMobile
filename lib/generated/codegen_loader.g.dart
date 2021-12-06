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
    },
    "Location": {
      "header": {
        "title": "Standort auswählen"
      },
      "labels": {
        "loading": "Karte laden"
      },
      "hints": {
        "search": "Suche im Umkreis von 50km",
        "dismiss": "Berühren Sie die Karte, um die Auswahl aufzuheben."
      },
      "btns": {
        "getLocation": "Tippen Sie auf , um den Standort abzurufen"
      }
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
      "loading": "Veranstaltungen laden"
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
        "pageTitle": "Rufnummer ändern",
        "label_verifyNumberInfo": "Sie erhalten eine SMS-Nachricht (es können Gebühren anfallen) zur Bestätigung Ihrer Telefonnummer. Geben Sie Ihre Telefonnummer ein.",
        "errorToast_Error": "Fehler, etwas ist schief gelaufen",
        "hintLabel_PhoneNumber": "Rufnummer",
        "validationLabel_InvalidNumber": "Ungültige Rufnummer",
        "button_Next": "Weiter",
        "ConfirmMobile": {
          "pageTitle": "Bestätigen Sie Ihre Rufnummer",
          "toasts": {
            "wrongCode5Times": "Falscher Code 5 Mal eingegeben",
            "failedToUpdateNumber": "Aktualisierung der Telefonnummer fehlgeschlagen",
            "invalidPhone": "Die angegebene Rufnummer ist ungültig",
            "serviceUnavaialble": "Dieser Dienst ist derzeit nicht verfügbar. Bitte versuchen Sie es morgen erneut. ",
            "invalidOtp": "Das angegebene OTP ist ungültig",
            "expiredOtp": "Der angegebene Code ist abgelaufen"
          },
          "labels": {
            "confirmNumberInfo": "Bitte geben Sie den 6-stelligen Code ein, der Ihnen zugesandt wurde",
            "confirmThisNumber": "Bestätigen",
            "resendOTP": "Code erneut senden"
          },
          "buttons": {
            "confirmPhone": "Bestätigen"
          },
          "validation": {
            "inputValidOtp": "Bitte geben Sie einen gültigen Code ein"
          }
        },
        "label_sendingOtpDialog": "Code wird gesendet"
      },
      "EditName": {
        "pageTitle": "Name bearbeiten",
        "labels": {
          "nameLabel": "Name",
          "lastName": "Nachname",
          "updatingDialog": "Aktualisierung"
        },
        "validation": {
          "inputValidName": "Bitte geben Sie einen gültigen Namen an"
        },
        "toasts": {
          "error": "Etwas ist schief gelaufen"
        }
      },
      "EditDescription": {
        "pageTitle": "Profilbeschreibung bearbeiten",
        "labels": {
          "updatingDialog": "Aktualisierung",
          "descriptionLabel": "Profilbeschreibung"
        },
        "validation": {
          "descriptionTooLong": "Profilbeschreibung ist zu lang"
        },
        "toasts": {
          "error": "Etwas ist schief gelaufen"
        }
      },
      "EditProfilePicture": {
        "pageTitle": "Profilbild ändern",
        "navigationLabels": {
          "changePicture": "Bild ändern",
          "deletePicture": "Bild löschen"
        },
        "labels": {
          "camera": "Kamera",
          "gallery": "Galerie",
          "uploadPicture": "Bild hochladen"
        },
        "toasts": {
          "profilePicUpdated": "Profilbild aktualisiert",
          "error": "Etwas ist schief gelaufen"
        },
        "buttons": {
          "cancel": "Abbrechen",
          "setPicture": "Als Profilbild festlegen"
        }
      }
    },
    "Settings": {
      "DeleteAccount": {
        "dialogTitle": "Konto löschen",
        "labels": {
          "deleteInfo1": "Sobald Sie bestätigen, werden alle Ihre Kontodaten gelöscht.",
          "deleteInfo2": "Die Löschung des Kontos ist ",
          "deleteInfo3": "endgültig",
          "deleteInfo4": ". Es gibt keine Möglichkeit, Ihr Konto wiederherzustellen.",
          "deleteInfo5": "Bitte geben Sie zur Bestätigung Ihre E-Mail-Adresse ein:"
        },
        "hints": {
          "enterEmail": "E-Mail eingeben",
          "email": "E-Mail"
        },
        "validation": {
          "inputValidEmail": "Bitte geben Sie eine gültige E-Mail ein"
        },
        "buttons": {
          "delete": "Löschen",
          "cancel": "Abbrechen"
        }
      },
      "ReportBug": {
        "pageTitle": "Einen Fehler melden",
        "labels": {
          "somethingIsntWorking": "Funktioniert etwas nicht wie erwartet?",
          "uploadScreenshots": "Screenshots hochladen"
        },
        "hints": {
          "issueReportHint": "Bitte erklären Sie kurz, was passiert ist und wie wir das Problem reproduzieren können."
        },
        "validation": {
          "invalidIssueDescription": "Beschreibung ist nicht gültig"
        },
        "dialogs": {
          "thankYouDialog": {
            "headerLabel": "Vielen Dank!",
            "messageLabel": "Ihr Beitrag wird unserem Team helfen, die Dienstleistungen für Sie zu verbessern.",
            "buttonLabel": "Zurück zu den Einstellungen"
          },
          "uploadingDialog": {
            "uploadingReport": "Bericht wird versendet"
          }
        },
        "toasts": {
          "error": "Etwas ist schief gelaufen"
        }
      },
      "ChangePassword": {
        "pageTitle": "Passwort ändern",
        "labels": {
          "forgotPasswordInstructions": "Wenn Sie Ihr Passwort vergessen haben, können Sie sich abmelden und ein neues Passwort anfordern",
          "updatingDialog": "Aktualisierung läuft"
        },
        "toasts": {
          "wrongPassword": "Altes Passwort ist falsch",
          "passwordUpdated": "Passwort aktualisiert"
        },
        "hints": {
          "enterOldPassword": "Geben Sie Ihr altes Passwort ein",
          "enterNewPassword": "Geben Sie Ihr neues Passwort ein"
        },
        "validation": {
          "inputOldPassword": "Bitte geben Sie Ihr altes Passwort ein",
          "inputNewPassword": "Passwort muss mindestens 8 Zeichen lang sein und Groß- und Kleinbuchstaben sowie Ziffern enthalten"
        },
        "buttons": {
          "changePassword": "Passwort ändern"
        }
      },
      "pageTitle": "Einstellungen",
      "subHeader": {
        "notifications": "Benachrichtigungen",
        "account": "Konto",
        "info": "Infos",
        "feedback": "Rückmeldung"
      },
      "navigationLabels": {
        "pushNotifications": "Push-Benachrichtigungen",
        "changePassword": "Passwort ändern",
        "logout": "Abmelden",
        "deleteAccount": "Konto löschen",
        "termsAndServices": "Nutzungsbedingungen",
        "privacyPolicy": "Datenschutzerklärung",
        "imprint": "Impressum",
        "leaveRating": "Bewertung abgeben",
        "reportBug": "Fehler melden"
      },
      "labels": {
        "loggingOutDialog": "Abmeldung läuft"
      }
    }
  },
  "Authentication": {
    "Register": {
      "pageTitle": "Registrieren",
      "labels": {
        "info": "Neues Konto erstellen",
        "signInInfo": "Mit der Anmeldung",
        "youAgree": "erklären Sie sich mit unserem"
      },
      "hints": {
        "confirmPasswordHint": "Passwort bestätigen",
        "passwordFieldHint": "Passwort eingeben"
      },
      "validation": {
        "passwordField": "Das Passwort muss mindestens 8 Zeichen lang sein und Groß- und Kleinbuchstaben sowie Ziffern enthalten",
        "confirmPassword": "Passwörter stimmen nicht überein"
      },
      "navigationLabels": {
        "privacyPolicy": "Datenschutzerklärung",
        "and": " und ",
        "tos": "AGB"
      },
      "toasts": {
        "couldnNotConnect": "Konnte keine Verbindung zu dieser Website herstellen"
      },
      "buttons": {
        "register": "Registrieren"
      },
      "successDialog": {
        "header": "Erfolgreich!",
        "message": "Bitte schauen Sie in Ihrem Posteingang nach. Sie erhalten in Kürze einen Bestätigungslink per E-Mail.",
        "button": "Zurück zur Anmeldung"
      }
    },
    "Login": {},
    "ForgotPassword": {
      "pageTItle": "Passwort vergessen?",
      "labels": {
        "instructionsLabel": "Geben Sie die mit Ihrem Konto verknüpfte E-Mail-Adresse ein, und wir senden Ihnen eine E-Mail mit Anweisungen zum Zurücksetzen Ihres Passworts."
      },
      "buttons": {
        "requestButton": "Anfrage senden"
      },
      "successDialog": {
        "header": "Prüfen Sie Ihren Posteingang",
        "message": "Wir haben eine Anleitung zur Wiederherstellung des Passworts an Ihre E-Mail geschickt.",
        "buttonText": "Zurück zur Anmeldung"
      }
    }
  },
  "Navigation": {
    "map": "Karte",
    "hosted": "Gehaltene",
    "joined": "Verbundene",
    "account": "Konto"
  },
  "Error": {
    "Event": {
      "noConnection": "Eine Verbindung zum Server konnte nicht hergestellt werden.",
      "create": {
        "400": "Ungültige Eingabe.",
        "403": "Sie müssen Ihren Namen eingeben, um ein Ereignis zu erstellen."
      },
      "delete": {
        "400": "Schlechte Anfrage.",
        "403": "Sie müssen der Gastgeber sein, um dieses Ereignis löschen zu können.",
        "404": "Die Veranstaltung, das Sie zu löschen versuchen, wurde nicht gefunden."
      },
      "update": {
        "403": "Sie sind zu dieser Aktion nicht berechtigt."
      }
    }
  },
  "Widgets": {
    "TextInput": {
      "EmailInput": {
        "hint": "E-Mail eingeben",
        "label": "E-mail",
        "validation": "Bitte geben Sie eine gültige E-Mail ein"
      },
      "PasswordInput": {
        "label": "Passwort"
      }
    },
    "NoAccountYet": {
      "buttons": {
        "noAccountYet1": "Haben Sie noch kein Konto?",
        "signUp": "Registrieren"
      }
    },
    "HaveAnAccount": {
      "haveAnAccount": "Haben Sie schon ein Konto?",
      "login": "Anmelden"
    }
  },
  "Others": {
    "Repositories": {}
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
        "updatingEvent": "Updating event"
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
    },
    "Location": {
      "header": {
        "title": "Choose Location"
      },
      "labels": {
        "loading": "Loading map"
      },
      "hints": {
        "search": "Search in the radius of 50km",
        "dismiss": "Touch the map to dismiss selection"
      },
      "btns": {
        "getLocation": "Tap to get location"
      }
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
      "loading": "Loading events"
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
        "pageTitle": "Change phone number",
        "label_verifyNumberInfo": "You will get an SMS message (carrier charges may apply) to confirm your phone number. Enter your phone number.",
        "errorToast_Error": "Error, something went wrong",
        "hintLabel_PhoneNumber": "Phone number",
        "validationLabel_InvalidNumber": "Invalid phone number",
        "button_Next": "Next",
        "ConfirmMobile": {
          "pageTitle": "Confirm your phone number",
          "toasts": {
            "wrongCode5Times": "Wrong code entered 5 times",
            "failedToUpdateNumber": "Failed to update phone number",
            "invalidPhone": "The provided phone number is not valid",
            "serviceUnavaialble": "This service is currently unavailable, please try again tomorrow.",
            "invalidOtp": "The provided OTP is not valid",
            "expiredOtp": "The provided code has expired"
          },
          "labels": {
            "confirmNumberInfo": "Please enter the 6-digit code that was sent to you",
            "confirmThisNumber": "Confirm",
            "resendOTP": "Resend OTP"
          },
          "buttons": {
            "confirmPhone": "Confirm"
          },
          "validation": {
            "inputValidOtp": "Please input a valid OTP"
          }
        },
        "label_sendingOtpDialog": "Seding code"
      },
      "EditName": {
        "pageTitle": "Edit name",
        "labels": {
          "nameLabel": "Name",
          "lastName": "Last name",
          "updatingDialog": "Updating"
        },
        "validation": {
          "inputValidName": "Please provide a valid name."
        },
        "toasts": {
          "error": "Something went wrong"
        }
      },
      "EditDescription": {
        "pageTitle": "Edit profile description",
        "labels": {
          "updatingDialog": "Updating",
          "descriptionLabel": "Profile description"
        },
        "validation": {
          "descriptionTooLong": "Profile description too long"
        },
        "toasts": {
          "error": "Something went wrong"
        }
      },
      "EditProfilePicture": {
        "pageTitle": "Change profile picture",
        "navigationLabels": {
          "changePicture": "Change picture",
          "deletePicture": "Delete picture"
        },
        "labels": {
          "camera": "Camera",
          "gallery": "Gallery",
          "uploadPicture": "Upload picture"
        },
        "toasts": {
          "profilePicUpdated": "Profile picture updated",
          "error": "Something went wrong"
        },
        "buttons": {
          "cancel": "Cancel",
          "setPicture": "Set as profile picture"
        }
      }
    },
    "Settings": {
      "DeleteAccount": {
        "dialogTitle": "Delete account",
        "labels": {
          "deleteInfo1": "Once you confirm, all of your account data will be deleted.",
          "deleteInfo2": "Account deletion is ",
          "deleteInfo3": "final",
          "deleteInfo4": ". There will be no way to restore your account.",
          "deleteInfo5": "Please enter your email address to confirm:"
        },
        "hints": {
          "enterEmail": "Enter your email",
          "email": "Email"
        },
        "validation": {
          "inputValidEmail": "Please input a valid email"
        },
        "buttons": {
          "delete": "Delete",
          "cancel": "Cancel"
        }
      },
      "ReportBug": {
        "pageTitle": "Report an issue",
        "labels": {
          "somethingIsntWorking": "Something isn\\'t working as expected?",
          "uploadScreenshots": "Upload screenshots"
        },
        "hints": {
          "issueReportHint": "Please explain briefly what happened and how can we reproduce the issue?"
        },
        "validation": {
          "invalidIssueDescription": "Description is not valid"
        },
        "dialogs": {
          "thankYouDialog": {
            "headerLabel": "Thank you!",
            "messageLabel": "Your input will significantly help our team improve the services we provide you.",
            "buttonLabel": "Back to settings"
          },
          "uploadingDialog": {
            "uploadingReport": "Sending report"
          }
        },
        "toasts": {
          "error": "Something went wrong"
        }
      },
      "ChangePassword": {
        "pageTitle": "Change password",
        "labels": {
          "forgotPasswordInstructions": "If you have forgotten your password, you can log out and request a password reset",
          "updatingDialog": "Updating"
        },
        "toasts": {
          "wrongPassword": "Old password is incorrect",
          "passwordUpdated": "Password updated"
        },
        "hints": {
          "enterOldPassword": "Enter your old password",
          "enterNewPassword": "Enter your new password"
        },
        "validation": {
          "inputOldPassword": "Please input your old password",
          "inputNewPassword": "Password must be at least 8 characters length, must contain upper, lower case letters and digits"
        },
        "buttons": {
          "changePassword": "Change password"
        }
      },
      "pageTitle": "Settings",
      "subHeader": {
        "notifications": "Notifications",
        "account": "Account",
        "info": "Info",
        "feedback": "Feedback"
      },
      "navigationLabels": {
        "pushNotifications": "Push notifications",
        "changePassword": "Change password",
        "logout": "Logout",
        "deleteAccount": "Delete account",
        "termsAndServices": "Terms of services",
        "privacyPolicy": "Privacy policy",
        "imprint": "Imprint",
        "leaveRating": "Leave a rating",
        "reportBug": "Report a bug"
      },
      "labels": {
        "loggingOutDialog": "Logging out"
      }
    }
  },
  "Authentication": {
    "Register": {
      "pageTitle": "Register",
      "labels": {
        "info": "Create new account",
        "signInInfo": "By signing up",
        "youAgree": "you agree to our"
      },
      "hints": {
        "confirmPasswordHint": "Confirm password",
        "passwordFieldHint": "Enter a password"
      },
      "validation": {
        "passwordField": "Password must be at least 8 characters length, must contain upper, lower case letters and digits",
        "confirmPassword": "Passwords don't match"
      },
      "navigationLabels": {
        "privacyPolicy": "Privacy Policy",
        "and": " and ",
        "tos": "Terms & Conditions"
      },
      "toasts": {
        "couldnNotConnect": "Couldn't connect to"
      },
      "buttons": {
        "register": "Sign Up"
      },
      "successDialog": {
        "header": "Success!",
        "message": "Please check your email. You will get soon an email confirmation link.",
        "button": "Back to login"
      }
    },
    "Login": {},
    "ForgotPassword": {
      "pageTItle": "Forgot Password?",
      "labels": {
        "instructionsLabel": "Enter the email associated with your account and we'll send an email with instructions to reset your password."
      },
      "buttons": {
        "requestButton": "Send request"
      },
      "successDialog": {
        "header": "Check your inbox",
        "message": "We have sent a password recover instructions to your email.",
        "buttonText": "Back to login"
      }
    }
  },
  "Navigation": {
    "map": "Map",
    "hosted": "Hosted",
    "joined": "Joined",
    "account": "Account"
  },
  "Error": {
    "Event": {
      "noConnection": "A connection to the server couldn't be established.",
      "create": {
        "400": "Invalid input.",
        "403": "You need to set your name to create an event."
      },
      "delete": {
        "400": "Bad request.",
        "403": "You need to be the host in order to delete this event.",
        "404": "The event you are trying to delete wasn't found."
      },
      "update": {
        "403": "You are not authorized for this action."
      }
    }
  },
  "Widgets": {
    "TextInput": {
      "EmailInput": {
        "hint": "Enter your email",
        "label": "Email",
        "validation": "Please input a valid email"
      },
      "PasswordInput": {
        "label": "Password"
      }
    },
    "NoAccountYet": {
      "buttons": {
        "noAccountYet1": "Don't have an account yet? ",
        "signUp": "Sign up"
      }
    },
    "HaveAnAccount": {
      "haveAnAccount": "Already have an account? ",
      "login": "Login"
    }
  },
  "Others": {
    "Repositories": {}
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"de": de, "en": en};
}
