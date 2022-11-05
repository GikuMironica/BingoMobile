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
    "hints": {
      "search": "Suche nach Tags"
    },
    "labels": {
      "eventType": "Veranstaltungstyp:",
      "searchRadius": "Suchradius:",
      "today": "Heute",
      "loading": "Veranstaltungen werden geladen"
    },
    "btns": {
      "search": "Suche"
    }
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
        "time": "Uhrzeit",
        "tags": "Tags",
        "description": "Beschreibung",
        "requirements": "Anforderungen",
        "creating": "Veranstaltung erstellen",
        "guests": "Anzahl der Gäste",
        "price": "Eintrittspreis"
      },
      "hints": {
        "eventType": "Veranstaltungstyp",
        "startTime": "Beginn",
        "endTime": "Ende",
        "tagsLimit": "Du kannst bis zu 5 Tags hinzufügen.",
        "addTags": "Tags hinzufügen",
        "price": "Preis"
      },
      "btns": {
        "create": "Erstellen"
      },
      "validation": {
        "title": "Bitte gib einen gültigen Titel an.",
        "eventType": "Veranstaltungstyp ist erforderlich.",
        "location": "Bitte wähle einen Standort.",
        "time": "Beginn und Endzeit sind erforderlich.",
        "description": "Bitte eine gültige Beschreibung angeben.",
        "fillAll": "Bitte fülle alle geforderten Felder aus"
      },
      "eventTypes": {
        "houseParty": "Hausparty",
        "club": "Club",
        "bar": "Bar",
        "bikerMeet": "Bikertreffen",
        "bicycleMeet": "Fahrradtreffen",
        "carMeet": "Autotreffen",
        "streetParty": "Street Party",
        "sport": "Sport",
        "others": "Sonstiges"
      },
      "dialogs": {
        "noPhoneDialog": {
          "header": "Veranstaltung erstellt",
          "message": "Deine Veranstaltung wurde erfolgreich erstellt. Bitte aktualisiere deine Telefonnummer, damit die Gäste dich erreichen können.",
          "button": "Einstellungen"
        }
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
        "editPlaces": "Anzahl der verfügbaren Plätze bearbeiten"
      },
      "toasts": {
        "eventUpdated": "Veranstaltung aktualisiert."
      }
    },
    "header": {
      "title": "Meine Veranstaltungen"
    },
    "Location": {
      "header": {
        "title": "Standort auswählen"
      },
      "labels": {
        "loading": "Karte lädt"
      },
      "hints": {
        "search": "Suche im Umkreis von 50km",
        "dismiss": "Karte berühren, um die Auswahl aufzuheben."
      },
      "btns": {
        "getLocation": "Tippen, um den Standort abzurufen"
      }
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
        "pageTitle": "Telefonnummer ändern",
        "label_verifyNumberInfo": "Du erhältst eine SMS-Nachricht (es können Gebühren anfallen) zur Bestätigung deiner Telefonnummer. Gib deine Telefonnummer ein.",
        "errorToast_Error": "Fehler, etwas ist schief gelaufen",
        "hintLabel_PhoneNumber": "Telefonnummer",
        "validationLabel_InvalidNumber": "Ungültige Telefonnummer",
        "button_Next": "Weiter",
        "ConfirmMobile": {
          "pageTitle": "Rufnummer bestätigen",
          "toasts": {
            "wrongCode5Times": "Falscher Code 5 Mal eingegeben",
            "failedToUpdateNumber": "Aktualisierung der Telefonnummer fehlgeschlagen",
            "invalidPhone": "Die angegebene Rufnummer ist ungültig",
            "serviceUnavaialble": "Dieser Dienst ist derzeit nicht verfügbar. Bitte versuch es morgen erneut. ",
            "invalidOtp": "Das angegebene OTP ist ungültig",
            "expiredOtp": "Der angegebene Code ist abgelaufen"
          },
          "labels": {
            "confirmNumberInfo": "Bitte den gesendeten 6-stelligen Code eingeben",
            "confirmThisNumber": "Bestätigen",
            "resendOTP": "Code erneut senden"
          },
          "buttons": {
            "confirmPhone": "Bestätigen"
          },
          "validation": {
            "inputValidOtp": "Bitte einen gültigen Code eingeben"
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
          "inputValidName": "Bitte einen gültigen Namen eingeben"
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
          "deleteInfo1": "Nach der Bestätigung, werden alle deine Kontodaten gelöscht.",
          "deleteInfo2": "Die Löschung des Kontos ist ",
          "deleteInfo3": "endgültig",
          "deleteInfo4": ". Dein Konto wird unwiderruflich gelöscht.",
          "deleteInfo5": "Bitte zur Bestätigung deine E-Mail-Adresse eingeben:"
        },
        "hints": {
          "enterEmail": "E-Mail eingeben",
          "email": "E-Mail"
        },
        "validation": {
          "inputValidEmail": "Bitte eine gültige E-Mail-Adresse eingeben"
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
          "issueReportHint": "Bitte kurz erklären, was passiert ist und wie wir das Problem reproduzieren können."
        },
        "validation": {
          "invalidIssueDescription": "Beschreibung ist nicht gültig"
        },
        "dialogs": {
          "thankYouDialog": {
            "headerLabel": "Vielen Dank!",
            "messageLabel": "Dein Beitrag wird unserem Team helfen, die Dienstleistungen für Dich zu verbessern.",
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
          "forgotPasswordInstructions": "Wenn du dein Passwort vergessen hast, bitte melde dich ab und fordere ein neues Passwort an.",
          "updatingDialog": "Aktualisierung läuft"
        },
        "toasts": {
          "wrongPassword": "Altes Passwort ist falsch",
          "passwordUpdated": "Passwort aktualisiert"
        },
        "hints": {
          "enterOldPassword": "Altes Passwort eingeben",
          "enterNewPassword": "Neues Passwort eingeben"
        },
        "validation": {
          "inputOldPassword": "Altes Passwort eingebe",
          "inputNewPassword": "Das Passwort muss mindestens 8 Zeichen lang sein und mindestens einen Buchstaben und eine Zahl enthalten."
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
        "passwordField": "Das Passwort muss mindestens 8 Zeichen lang sein und mindestens einen Buchstaben und eine Zahl enthalten.",
        "confirmPassword": "Passwörter stimmen nicht überein"
      },
      "navigationLabels": {
        "privacyPolicy": " Datenschutzerklärung ",
        "and": " und ",
        "tos": "AGB"
      },
      "toasts": {
        "couldnNotConnect": "Konnte keine Verbindung zu dieser Website herstellen",
        "internalError": "Interner Fehler"
      },
      "buttons": {
        "register": "Registrieren"
      },
      "successDialog": {
        "header": "Erfolgreich!",
        "message": "Bitte schau in deinem Posteingang nach. Du erhälst in Kürze einen Bestätigungslink per E-Mail.",
        "button": "Zurück zur Anmeldung"
      }
    },
    "Login": {
      "pageTitle": "Willkommen!",
      "labels": {
        "info": "Einloggen um fortzufahren",
        "dividerText": " Oder weiter mit  "
      },
      "hints": {
        "enterPass": "Bitte Passwort eingeben"
      },
      "validation": {
        "inputPass": "Bitte Passwort eingeben"
      },
      "buttons": {
        "login": "Einloggen"
      },
      "toasts": {
        "internalError": "Interner Fehler",
        "wentWrong": "Etwas ist schief gelaufen"
      }
    },
    "ForgotPassword": {
      "pageTItle": "Passwort vergessen?",
      "labels": {
        "instructionsLabel": "Bitte die mit deinem Konto verknüpfte E-Mail-Adresse eingeben. In Kürze erhältst du eine E-Mail mit Anweisungen für die Wiederherstellung des Passworts."
      },
      "buttons": {
        "requestButton": "Anfrage senden"
      },
      "successDialog": {
        "header": "Bitte schaue in deinem E-Mail-Posteingang",
        "message": "Wir haben eine Anleitung zur Wiederherstellung des Passworts an Deine E-Mail geschickt.",
        "buttonText": "Zurück zur Anmeldung"
      },
      "toasts": {
        "internalError": "Interner Fehler"
      }
    }
  },
  "Navigation": {
    "map": "Karte",
    "hosted": "Meine Events",
    "joined": "Archivierte",
    "account": "Konto",
    "noFullNameDialog": {
      "header": "Hallo!",
      "message": "Bitte vervollständige die Registrierung durch Eingabe deines Namens.",
      "button": "Einstellungen"
    }
  },
  "Error": {
    "Event": {
      "noConnection": "Eine Verbindung zum Server konnte nicht hergestellt werden.",
      "create": {
        "400": "Ungültige Eingabe.",
        "403": "Veranstaltung konnte nicht erstellt werden"
      },
      "delete": {
        "400": "Schlechte Anfrage.",
        "403": "Du muss der Gastgeber sein, um diese Veranstaltung löschen zu können.",
        "404": "Die Veranstaltung, die Du zu löschen versuchst, wurde nicht gefunden."
      },
      "update": {
        "403": "Du bist zu dieser Aktion nicht berechtigt."
      }
    }
  },
  "Widgets": {
    "TextInput": {
      "EmailInput": {
        "hint": "E-Mail eingeben",
        "label": "E-mail",
        "validation": "Bitte eine gültige E-Mail eingeben"
      },
      "PasswordInput": {
        "label": "Passwort"
      }
    },
    "NoAccountYet": {
      "buttons": {
        "noAccountYet1": "Hast Du noch kein Konto?",
        "signUp": " Registrieren"
      }
    },
    "HaveAnAccount": {
      "haveAnAccount": "Hast Du schon ein Konto?",
      "login": "Anmelden"
    },
    "MiniPost": {
      "unknownAddress": "Unbekannte Adresse"
    }
  },
  "Others": {
    "Repositories": {
      "Authentication": {
        "confirmEmail": "Bitte bestätige deine E-Mail",
        "tooManyAttempts": "Zu viele ungültige Anmeldeversuche, versuche es später noch einmal",
        "invalidCredentials": "Ungültiger Benutzername oder Passwort",
        "accountExists": "Ein Konto mit dieser E-Mail existiert bereits"
      },
      "Report": {
        "reportedAlready": "Du hast diese Veranstaltung bereits gemeldet",
        "cantSendReport": "Bericht konnte nicht gesendet werden"
      },
      "Rating": {
        "ratedAlready": "Du hast dieses Ereignis bereits bewertet",
        "cantRate": "Bewertung konnte nicht abgegeben werden"
      },
      "User": {
        "cantSaveImage": "Bild konnte nicht gespeichert werden",
        "error": "Interner Fehler"
      }
    },
    "Services": {
      "DioService": {
        "requestQuotaExceed": "Überschrittene Anfragenquote"
      },
      "Location": {
        "serviceDisabled": "Standortdienst ist deaktiviert",
        "locationPermissionDenied": "Standortgenehmigung abgelehnt"
      }
    },
    "Providers": {
      "SearchPage": {
        "noEventsFound": "Keine Veranstaltungen in diesem Bereich gefunden"
      },
      "Settings": {
        "inputurEmail": "Konto E-Mail eingeben",
        "accountDeleted": "Konto gelöscht",
        "failedAccountDelete": "Konto konnte nicht gelöscht werden"
      }
    }
  },
  "Event": {
    "dialogs": {
      "loadingEvent": "Wird geladen",
      "NoNameJoinEventDialog": {
        "header": "Hey!",
        "message": "Du muss dein Namen eingeben, bevor du an Veranstaltungen teilnehmen oder solche erstellen kannst.",
        "button": "Einstellungen"
      }
    },
    "labels": {
      "unknownAdress": "Unbekannte Adresse",
      "tags": "Tags",
      "eventRated": "Gastgeber bewertet",
      "rateEvent": "Veranstaltung bewerten",
      "reportEvent": "Diese Veranstaltung melden",
      "editEvent": "Diese Veranstaltung bearbeiten",
      "delete": "Diese Veranstaltung löschen",
      "description": "Beschreibung",
      "requirements": "Anforderungen"
    },
    "buttons": {
      "attend": "Teilnahme an",
      "notInterested": "Nicht interessiert?"
    },
    "detailsLabels": {
      "date": "Datum",
      "tim": "Uhrzeit",
      "price": "Eintrittspreis",
      "availablePlaces": "Verfügbare Plätze"
    },
    "participators": {
      "pageTitle": "Liste der Gäste",
      "noMembersYet": "Noch keine Gäste"
    },
    "requestList": {
      "requests": "Anfragen",
      "noReqsYet": "Noch keine Anfragen"
    },
    "Rating": {
      "pageTitle": "Veranstaltung bewerten",
      "validation": "Bitte gib uns ein kurzes Feedback",
      "button": "Bewertung abgeben",
      "dialog": "Hochladen",
      "outOf": " von 5"
    },
    "Report": {
      "reportEvent": "Veranstaltung melden",
      "doesntExist": "Diese Veranstaltung existiert nicht",
      "inappropriateContet": "Unangemessener Inhalt",
      "spam": "Spam"
    },
    "Delete": {
      "title": "Veranstaltung löschen",
      "confirmDelete": "Sobald Du bestätigst, wird diese Veranstaltung gelöscht",
      "confirm": "Löschen",
      "deleteSuccess": "Veranstaltung wurde erfolgreich gelöscht.",
      "cancel": "Abbrechen"
    }
  },
  "Home": {
    "FullScreenDialog": {
      "header": "Hallo!",
      "messege": "Vervollständige die Registrierung durch Eingabe Deines Namens, um Veranstaltungen zu erstellen oder ihnen beizutreten.",
      "btnText": "Einstellungen"
    },
    "PermissionDialog": {
      "header": "Haben wir Ihre Zustimmung?",
      "message": "Lassen Sie uns Ihren Standort verwenden, um Veranstaltungen in Ihrer Nähe zu finden, und stellen Sie sicher, dass die Standortdienste aktiviert sind.",
      "btn_location_permission": "Zugriff auf den Standort zulassen",
      "btn_location_service": "Standortdienst aktivieren"
    }
  },
  "Archieved": {
    "header": {
      "title": "Archivierte Veranstaltungen",
      "currentTab": "Von mir veranstaltet",
      "pastTab": "Besucht"
    },
    "labels": {
      "noEventsFound": "Keine Veranstaltungen gefunden",
      "loading": "Veranstaltungen laden"
    }
  }
};
static const Map<String,dynamic> en = {
  "Map": {
    "hints": {
      "search": "Search for events by tag"
    },
    "labels": {
      "eventType": "Event Type:",
      "searchRadius": "Search Radius:",
      "today": "Today",
      "loading": "Loading events"
    },
    "btns": {
      "search": "Search"
    }
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
        "startTime": "Start Time",
        "endTime": "End Time",
        "tagsLimit": "You can add up to 5 tags.",
        "addTags": "Add Tags",
        "price": "Price"
      },
      "btns": {
        "create": "Create"
      },
      "validation": {
        "title": "Please provide a valid title.",
        "eventType": "Event type is required.",
        "location": "Please choose a location.",
        "time": "Start and end time is required.",
        "description": "Please provide a valid description.",
        "fillAll": "Please fill in all required fields"
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
      },
      "dialogs": {
        "noPhoneDialog": {
          "header": "Event created!",
          "message": "Your event was successfully created. Please update your phone number so the guests can reach you out.",
          "button": "Settings"
        }
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
      "title": "My Events"
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
          "somethingIsntWorking": "Something isn't working as expected?",
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
          "inputNewPassword": "Password must be at least 8 characters length, must contain at least one letter and one number."
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
        "passwordField": "Password must be at least 8 characters length, must contain at least one letter and one number.",
        "confirmPassword": "Passwords don't match"
      },
      "navigationLabels": {
        "privacyPolicy": " Privacy Policy",
        "and": " and ",
        "tos": "Terms & Conditions"
      },
      "toasts": {
        "couldnNotConnect": "Couldn't connect to",
        "internalError": "Internal Error"
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
    "Login": {
      "pageTitle": "Welcome!",
      "labels": {
        "info": "Login to continue",
        "dividerText": " Or continue with "
      },
      "hints": {
        "enterPass": "Enter your password"
      },
      "validation": {
        "inputPass": "Please input your password"
      },
      "buttons": {
        "login": "Login"
      },
      "toasts": {
        "internalError": "Internal Error",
        "wentWrong": "Something went wrong"
      }
    },
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
      },
      "toasts": {
        "internalError": "Internal Error"
      }
    }
  },
  "Navigation": {
    "map": "Map",
    "hosted": "My Events",
    "joined": "Archieved",
    "account": "Account",
    "noFullNameDialog": {
      "header": "Hey there!",
      "message": "Complete the registration by entering your name.",
      "button": "Settings"
    }
  },
  "Error": {
    "Event": {
      "noConnection": "A connection to the server couldn't be established.",
      "create": {
        "400": "Invalid input.",
        "403": "Event could not be created"
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
        "signUp": " Sign up"
      }
    },
    "HaveAnAccount": {
      "haveAnAccount": "Already have an account? ",
      "login": "Login"
    },
    "MiniPost": {
      "unknownAddress": "Unknown address"
    }
  },
  "Others": {
    "Repositories": {
      "Authentication": {
        "confirmEmail": "Please confirm your email",
        "tooManyAttempts": "Too many invalid login attempts, try again later",
        "invalidCredentials": "Invalid username or password",
        "accountExists": "An account with this email already exists"
      },
      "Report": {
        "reportedAlready": "You've reported this event already",
        "cantSendReport": "Report could not be sent"
      },
      "Rating": {
        "ratedAlready": "You've rated this event already",
        "cantRate": "Rating could not be submitted"
      },
      "User": {
        "cantSaveImage": "Image could not be saved",
        "error": "Internal error"
      }
    },
    "Services": {
      "DioService": {
        "requestQuotaExceed": "Exceeded requests quota"
      },
      "Location": {
        "serviceDisabled": "Location service is disabled",
        "locationPermissionDenied": "Location permission denied"
      }
    },
    "Providers": {
      "SearchPage": {
        "noEventsFound": "No events found in this area"
      },
      "Settings": {
        "inputurEmail": "Input your account email",
        "accountDeleted": "Account deleted",
        "failedAccountDelete": "Unable to delete account"
      }
    }
  },
  "Event": {
    "dialogs": {
      "loadingEvent": "Loading",
      "NoNameJoinEventDialog": {
        "header": "Hey!",
        "message": "You have to enter your name before attending or creating events",
        "button": "Settings"
      }
    },
    "labels": {
      "unknownAdress": "Unknown address",
      "tags": "Tags",
      "eventRated": "Event host rated",
      "rateEvent": "Rate event",
      "reportEvent": "Report this event",
      "editEvent": "Edit this event",
      "delete": "Delete this event",
      "description": "Description",
      "requirements": "Requirements"
    },
    "buttons": {
      "attend": "Attend",
      "notInterested": "Not Interested?"
    },
    "detailsLabels": {
      "date": "Date",
      "tim": "Time",
      "price": "Entrance Price",
      "availablePlaces": "Available Places"
    },
    "participators": {
      "pageTitle": "Guests List",
      "noMembersYet": "No guests yet"
    },
    "requestList": {
      "requests": "Requests",
      "noReqsYet": "No requests yet"
    },
    "Rating": {
      "pageTitle": "Rate Event",
      "validation": "Provide a brief feedback",
      "button": "Submit Rating",
      "dialog": "Uploading",
      "outOf": " of 5"
    },
    "Report": {
      "reportEvent": "Report Event",
      "doesntExist": "Event does not exist",
      "inappropriateContet": "Inappropriate Content",
      "spam": "Spam"
    },
    "Delete": {
      "title": "Delete Event",
      "confirmDelete": "Once you confirm, this event will be deleted",
      "confirm": "Delete",
      "deleteSuccess": "Event was successfully deleted.",
      "cancel": "Cancel"
    }
  },
  "Home": {
    "FullScreenDialog": {
      "header": "Hey there!",
      "messege": "Complete the registration by entering your name to create or join events.",
      "btnText": "Settings"
    },
    "PermissionDialog": {
      "header": "Do we have your permission?",
      "message": "Let us use your location to find events near you, and make sure location services are enabled.",
      "btn_location_permission": "Allow location access",
      "btn_location_service": "Enable location service"
    }
  },
  "Archieved": {
    "header": {
      "title": "Archived Events",
      "currentTab": "Hosted by me",
      "pastTab": "Visited"
    },
    "labels": {
      "noEventsFound": "No events found",
      "loading": "Loading events"
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"de": de, "en": en};
}
