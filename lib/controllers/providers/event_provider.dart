import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/api.dart';
import 'package:hopaut/config/constants/constraint.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/controllers/providers/search_page_provider.dart';
import 'package:hopaut/data/domain/request_result.dart';
import 'package:hopaut/data/models/event_list.dart';
import 'package:hopaut/data/models/mini_post.dart';
import 'package:hopaut/data/models/picture.dart';
import 'package:hopaut/data/models/post.dart';
import 'package:hopaut/data/models/report.dart';
import 'package:hopaut/data/repositories/event_repository.dart';
import 'package:hopaut/data/repositories/report_repository.dart';
import 'package:hopaut/data/repositories/tag_repository.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/utils/image_utilities.dart';
import 'package:injectable/injectable.dart';

enum EventProviderStatus { Idle, Loading, Error }

@lazySingleton
class EventProvider extends ChangeNotifier {
  EventRepository eventRepository = getIt<EventRepository>();
  ReportRepository reportRepository = getIt<ReportRepository>();
  TagRepository tagRepository = getIt<TagRepository>();
  HashMap<String, EventList> eventsMap = HashMap();
  Post post = Post.empty();

  bool isLocationValid = true;
  bool isDateValid = true;

  BaseFormStatus eventLoadingStatus = Idle();
  BaseFormStatus reportPostLoadingStatus = Idle();

  EventProvider() {
    _initEventMap();
  }

  MiniPost? getActiveMiniPost() {
    if (eventsMap[API.MY_ACTIVE] == null) {
      return null;
    }

    return eventsMap[API.MY_ACTIVE]!
        .events
        .firstWhere((miniPost) => miniPost.postId == post.id, orElse: null);
  }

  Future<void> fetchEventList(String type) async {
    if (eventsMap[type]!.state == EventListState.notYetLoaded) {
      eventsMap[type]!.state = EventListState.loading;
      List<MiniPost>? response = await eventRepository.getEventMiniPosts(type);
      if (response != null) {
        eventsMap[type]!.events.addAll([...response]);
        eventsMap[type]!
            .events
            .sort((a, b) => a.startTime.compareTo(b.startTime));
      }
      eventsMap[type]!.state = EventListState.idle;
      notifyListeners();
    }
  }

  Future<MiniPost?> createEvent() async {
    eventLoadingStatus = Submitted();
    notifyListeners();
    MiniPost? miniPost;
    if (eventsMap[API.MY_ACTIVE] != null) {
      var result = await eventRepository.create(post);
      if (result.isSuccessful) {
        miniPost = result.data;
        eventsMap[API.MY_ACTIVE]!.events.insert(0, miniPost!);
      } else {
        showNewErrorSnackbar(result.errorMessage);
      }
      eventLoadingStatus = Idle();
      notifyListeners();
    }
    return miniPost;
  }

  Future<bool> updateEvent() async {
    eventLoadingStatus = Submitted();
    notifyListeners();
    RequestResult? result;
    if (post != Post.empty()) {
      result = await eventRepository.update(post);
      if (!result.isSuccessful) {
        showNewErrorSnackbar(result.errorMessage);
      }
      eventLoadingStatus = Idle();
      notifyListeners();
    }
    return result!.isSuccessful;
  }

  Future<bool> deleteEvent(int postId) async {
    var result = await eventRepository.delete(postId);
    if (result.isSuccessful) {
      return true;
    }
    showNewErrorSnackbar(result.errorMessage);
    return false;
  }

  void removeEvent(int id) {
    if (eventsMap[API.MY_ACTIVE] != null) {
      eventsMap[API.MY_ACTIVE]!
          .events
          .removeWhere((event) => event.postId == id);
      notifyListeners();
    }
  }

  Future<List<String>> getTagSuggestions(
      String pattern, List<String> currentTags) async {
    List<String> suggestionList = [];
    pattern = pattern
        .replaceAll(RegExp(r"[^\s\w]"), '')
        .replaceAll(RegExp(r" "), '-');
    if (pattern.length > 2) {
      List<String> tagResultList = await tagRepository.get(pattern);
      if (tagResultList.isNotEmpty && pattern == tagResultList.first) {
        tagResultList.removeAt(0);
      }
      suggestionList = [pattern, ...tagResultList];
      currentTags.forEach((tag) {
        if (pattern == tag) {
          suggestionList.removeAt(0);
        }
      });
    }
    return suggestionList;
  }

  void updateMiniPost() {
    MiniPost? eventProviderMiniPost = getActiveMiniPost();
    MiniPost? searchPageProvicerMiniPost =
        getIt<SearchPageProvider>().getMiniPostById(post.id);
    Picture? thumbnail = post.pictures.isNotEmpty ? post.pictures[0] : null;

    if (eventProviderMiniPost != null) {
      eventProviderMiniPost.thumbnail = thumbnail;
      eventProviderMiniPost.title = post.event.title;
      eventProviderMiniPost.address = post.location.address!;
      eventProviderMiniPost.startTime = post.eventTime;
      eventProviderMiniPost.endTime = post.endTime;
    }

    if (searchPageProvicerMiniPost != null) {
      searchPageProvicerMiniPost.thumbnail = thumbnail;
      searchPageProvicerMiniPost.title = post.event.title;
      searchPageProvicerMiniPost.address = post.location.address!;
      searchPageProvicerMiniPost.startTime = post.eventTime;
      searchPageProvicerMiniPost.endTime = post.endTime;
      getIt<SearchPageProvider>().buildMiniPostCards();
    }
  }

  Future<void> refreshAvailableSlots() async {
<<<<<<< HEAD
    _post.availableSlots =
        (await _eventRepository.get(post.id))?.availableSlots ?? 0;
=======
    post.availableSlots = (await eventRepository.get(post.id)).availableSlots;
>>>>>>> 857880b (Idk what I did)
  }

  bool validateTitle(String value) {
    return value != null &&
        value.characters.length > 0 &&
        value.characters.length <= Constraint.titleMaxLength;
  }

  void validateDates(TextEditingController startDateController,
      TextEditingController endDateController) {
    isDateValid = startDateController.text.isNotEmpty &&
        endDateController.text.isNotEmpty;
    notifyListeners();
  }

  void validateLocation() {
    isLocationValid = post.location != null;
    notifyListeners();
  }

  bool validateDescription(String value) {
    return value != null &&
        value.characters.length >= Constraint.descriptionMinLength &&
        value.characters.length <= Constraint.descriptionMaxLength;
  }

  bool validateRequirements(String value) {
    return value.characters.length <= Constraint.requirementsMaxLength;
  }

  void onFieldChange(TextEditingController controller, String value) {
    controller.text = value;
    notifyListeners();
  }

  Future<Picture?> selectPicture() async {
    return await choosePicture();
  }

  bool isFormValid(
      GlobalKey<FormState> formKey,
      TextEditingController startDateController,
      TextEditingController endDateController) {
    validateLocation();
    validateDates(startDateController, endDateController);
    return (formKey.currentState?.validate() ?? false) &&
        isLocationValid &&
        isDateValid;
  }

  Future<void> reportPost(
      {required int postId,
      required int reason,
      required BuildContext context}) async {
    PostReport report = PostReport(reason: reason, postId: postId);

    reportPostLoadingStatus = Submitted();
    notifyListeners();

    var result = await reportRepository.postReport(report);

    if (!result.isSuccessful) {
      showNewErrorSnackbar(result.errorMessage);
    }

    Application.router.pop(context, true);
    reportPostLoadingStatus = Idle();
    notifyListeners();
  }

  void reset() {
    _initEventMap();
    post = Post.empty();
    isLocationValid = true;
    isDateValid = true;
    eventLoadingStatus = Idle();
    reportPostLoadingStatus = Idle();
  }

  void _initEventMap() {
    eventsMap.addAll({
      API.MY_ACTIVE: EventList(),
      API.MY_INACTIVE: EventList(),
      API.ATTENDING_ACTIVE: EventList(),
      API.ATTENDED_INACTIVE: EventList()
    });
  }
}
