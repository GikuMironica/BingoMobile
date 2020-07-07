final Map<String, String> apiUrl = {
  'baseUrl': 'https://hopout.de/api/v1',

  // Identity
  'login': '/identity/login',
  'register': '/identity/register',
  'fb-auth': '/identity/auth/fb',
  'refresh': '/identity/refresh',
  'forgotPassword': '/identity/forgotpassword',
  'changePassword': '/identity/changePassword',

  // Users
  'users': '/users',

  // Posts
  'posts': '/posts',

  // Profile
  'profile': '/profile',

  // Announcements
  'announcements': '/announcements',
  'postAnnouncements': '/announcements/postId',

  // Attend Events
  'attend': '/attend',
  'attendingActive': '/attendedactive',
  'attendedInactive': '/attendedinactive',
  'unattend': '/unattend',

  // Event Attendees
  'acceptAttendee': '/acceptattendee',
  'rejectAttendee': '/rejectattendee',
  'fetchAttendees': '/fetchallattendee',
  'fetchAllAccepted': '/fetchallaccepted',
  'fetchAllPending': '/fetchallpending',
};

final Map<String, String> webUrl = {
  'baseUrl': 'https://www.hopaut.com',
  'images': '/assets/images',
  'profiles': '/assets/profiles'
};
