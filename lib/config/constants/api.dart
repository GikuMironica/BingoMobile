class API {
  static const String API_ROOT_URL = 'https://hop-out.com/api/v1';

  // Identity ------------------------------------------------------------------
  static const String IDENTITY = '/identity';
  static const String LOGIN = '$IDENTITY/login';
  static const String FB_AUTH = '$IDENTITY/auth/fb';
  static const String REFRESH = '$IDENTITY/refresh';
  static const String FORGOT_PASSWORD = '$IDENTITY/forgotpassword';
  static const String CHANGE_PASSWORD = '$IDENTITY/changepassword';
  static const String ADD_PASSWORD = '$IDENTITY/addpassword';
  static const String REGISTER = '$IDENTITY/register';

  // Users ---------------------------------------------------------------------
  static const String USERS = '/users';

  // Posts ---------------------------------------------------------------------
  static const String POSTS = '/posts';
  static const String MY_ACTIVE = '$POSTS/myactive';
  static const String MY_INACTIVE = '$POSTS/myinactive';

  // Event Attendees -----------------------------------------------------------
  static const String ACCEPT_ATTENDEE = '/acceptattendee';
  static const String REJECT_ATTENDEE = '/rejectattendee';
  static const String FETCH_ATTENDEES_ALL = '/fetchallattendee';
  static const String FETCH_ATTENDEES_ACCEPTED = '/fetchallaccepted';
  static const String FETCH_ATTENDEES_PENDING = '/fetchallpending';
  static const String PARTICIPANTS = '/fetchaccepteddata';

  // Attending Events ----------------------------------------------------------
  static const String ATTEND = '/attend';
  static const String ATTENDING_ACTIVE = '/attendedactive';
  static const String ATTENDED_INACTIVE = '/attendedinactive';
  static const String UNATTEND = '/unattend';

  // Profile -------------------------------------------------------------------
  static const String PROFILE = '/profile';

  // Tags ----------------------------------------------------------------------
  static const String TAGS = '/tag';

  // Announcements -------------------------------------------------------------
  static const String ANNOUNCEMENTS = '/announcements';
  static const String POST_ANNOUNCEMENTS = '$ANNOUNCEMENTS/postId';
  static const String ANNOUNCEMENTS_INBOX = '$ANNOUNCEMENTS/inbox';
  static const String ANNOUNCEMENTS_OUTBOX = '$ANNOUNCEMENTS/outbox';

  // Ratings -------------------------------------------------------------------
  static const String RATINGS = '/ratings';
  static const String RATINGS_BY_USER = '/ratings/userId';

  // Report --------------------------------------------------------------------
  static const String REPORT = '/reports';
  static const String USER_REPORT = '/userreports';
}
