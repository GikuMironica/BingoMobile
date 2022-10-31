String makeInitials({String? firstName, String? lastName}) {
  return '${firstName?.substring(0, 1)}${lastName?.substring(0, 1)}';
}
