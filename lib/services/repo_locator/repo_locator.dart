import 'package:hopaut/data/repositories/repositories.dart';

class RepoLocator{
  static RepoLocator _repoLocator;
  EventRepository _eventRepository;
  AnnouncementRepository _announcementRepository;
  HostRepository _hostRepository;
  IdentityRepository _identityRepository;
  ParticipantRepository _participantRepository;
  PostRepository _postRepository;
  ProfileRepository _profileRepository;
  RatingsRepository _ratingsRepository;
  ReportRepository _reportRepository;
  TagsRepository _tagsRepository;
  UserRepository _userRepository;

  factory RepoLocator() {
    return _repoLocator ??= RepoLocator._();
  }

  RepoLocator._(){
    _eventRepository = EventRepository();
    _announcementRepository = AnnouncementRepository();
    _hostRepository = HostRepository();
    _identityRepository = IdentityRepository();
    _participantRepository = ParticipantRepository();
    _postRepository = PostRepository();
    _profileRepository = ProfileRepository();
    _ratingsRepository = RatingsRepository();
    _reportRepository = ReportRepository();
    _tagsRepository = TagsRepository();
    _userRepository = UserRepository();
  }

  EventRepository get events => _eventRepository;
  AnnouncementRepository get announcements => _announcementRepository;
  HostRepository get hosts => _hostRepository;
  IdentityRepository get identity => _identityRepository;
  ParticipantRepository get participants => _participantRepository;
  PostRepository get posts => _postRepository;
  ProfileRepository get profiles => _profileRepository;
  RatingsRepository get ratings => _ratingsRepository;
  ReportRepository get reports => _reportRepository;
  TagsRepository get tags => _tagsRepository;
  UserRepository get users => _userRepository;
}