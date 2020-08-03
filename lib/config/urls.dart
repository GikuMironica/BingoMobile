final Map<String, String> apiUrl = {
  'baseUrl': 'https://hopout.eu/api/v1',

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
  'my_inactive': '/posts/myinactive',
  'my_active': '/posts/myactive',

  // Profile
  'profile': '/profile',

  // Tags
  'tags': '/tag',

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
  'images': '/images',
  'profiles': '/images/profiles'
};
