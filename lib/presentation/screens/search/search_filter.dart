import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/controllers/providers/search_page_provider.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchPageFilter extends StatefulWidget {
  @override
  _SearchPageFilterState createState() => _SearchPageFilterState();
}

class _SearchPageFilterState extends State<SearchPageFilter> {
  CarouselController _carouselController = CarouselController();
  int _carouselLengh = 8;

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchPageProvider>(
      builder: (context, provider, __) => Card(
        color: Colors.white.withOpacity(0.9),
        elevation: provider.filter ? 4.0 : 0.25,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.symmetric(vertical: 60.0, horizontal: 24.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 4.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Ionicons.search_outline,
                        color: Color(0xFFED2F65)),
                    onPressed: () async => await provider.searchEvents(),
                  ),
                  Container(
                      height: 25,
                      child: VerticalDivider(
                        width: 10,
                        color: Theme.of(context).primaryColor,
                      )),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => provider.updateTag(v),
                      onTap: () => provider.toggleFilter(),
                      //focusNode: _focusNode,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 8.0),
                          hintText: LocaleKeys.Map_hints_search.tr(),
                          hintStyle: HATheme.FIELD_HINT_STYLE),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Ionicons.options_outline,
                      color: Color(0xFFED2F65),
                    ),
                    onPressed: () => provider.toggleFilter(),
                  )
                ],
              ),
              if (provider.filter) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        color: Color(0xFF707070),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        LocaleKeys.Map_labels_eventType.tr(),
                        style: TextStyle(
                          color: Color(0xFF2A2A2A),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _carouselController.animateToPage(1);
                            },
                            child: Text(
                              '❮',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: CarouselSlider(
                                carouselController: _carouselController,
                                options: CarouselOptions(
                                  //autoPlayAnimationDuration: Duration(milliseconds: 12000),
                                  //autoPlayInterval: Duration(milliseconds: 11900),
                                  //autoPlay: true,
                                  height: 46,
                                  initialPage: 1,
                                  viewportFraction: 0.45,
                                  enableInfiniteScroll: false,
                                  enlargeCenterPage: true,
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.scale,
                                  autoPlayCurve: Curves.linear,
                                ),
                                items: _carouselFilterItems(
                                    provider: provider, context: context)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              _carouselController.animateToPage(_carouselLengh);
                            },
                            child: Text(
                              '❯',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        LocaleKeys.Map_labels_searchRadius.tr(),
                        style: TextStyle(
                          color: Color(0xFF2A2A2A),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Slider(
                        value: provider.searchRadius.toDouble(),
                        divisions: 14,
                        label: provider.searchRadius.round().toString(),
                        min: 1,
                        max: 15,
                        onChanged: (v) {
                          provider.updateSearchRadius(v);
                        },
                        //onChangeEnd: (v) => provider.onSliderChangeEnd(),
                        activeColor: Colors.black54,
                        inactiveColor: HATheme.HOPAUT_GREY.withOpacity(0.5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1km',
                            style: TextStyle(
                              color: Color(0xFF2A2A2A),
                              fontSize: 11.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '15km',
                            style: TextStyle(
                              color: Color(0xFF2A2A2A),
                              fontSize: 11.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                LocaleKeys.Map_labels_today.tr(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0),
                              ),
                              CircularCheckBox(
                                value: provider.searchQuery.today,
                                onChanged: (v) => provider.filterToggleToday(),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                activeColor: HATheme.HOPAUT_PINK,
                                inactiveColor: HATheme.HOPAUT_PINK,
                              ),
                            ],
                          ),
                          _searchButton(provider)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> _carouselFilterItems(
    {SearchPageProvider provider, BuildContext context}) {
  return [
    _filterEventType(
        context: context,
        type: LocaleKeys.Hosted_Create_eventTypes_houseParty.tr(),
        value: provider.searchQuery.eventTypes[EventType.houseParty],
        onTap: (v) => provider.filterToggleEventType(EventType.houseParty)),
    _filterEventType(
        context: context,
        type: LocaleKeys.Hosted_Create_eventTypes_club.tr(),
        value: provider.searchQuery.eventTypes[EventType.club],
        onTap: (v) => provider.filterToggleEventType(EventType.club)),
    _filterEventType(
        context: context,
        type: LocaleKeys.Hosted_Create_eventTypes_streetParty.tr(),
        value: provider.searchQuery.eventTypes[EventType.streetParty],
        onTap: (v) => provider.filterToggleEventType(EventType.streetParty)),
    _filterEventType(
        context: context,
        type: LocaleKeys.Hosted_Create_eventTypes_bar.tr(),
        value: provider.searchQuery.eventTypes[EventType.bar],
        onTap: (v) => provider.filterToggleEventType(EventType.bar)),
    _filterEventType(
        context: context,
        type: LocaleKeys.Hosted_Create_eventTypes_bicycleMeet.tr(),
        value: provider.searchQuery.eventTypes[EventType.bicycleMeet],
        onTap: (v) => provider.filterToggleEventType(EventType.bicycleMeet)),
    _filterEventType(
        context: context,
        type: LocaleKeys.Hosted_Create_eventTypes_bikerMeet.tr(),
        value: provider.searchQuery.eventTypes[EventType.bikerMeet],
        onTap: (v) => provider.filterToggleEventType(EventType.bikerMeet)),
    _filterEventType(
        context: context,
        type: LocaleKeys.Hosted_Create_eventTypes_carMeet.tr(),
        value: provider.searchQuery.eventTypes[EventType.carMeet],
        onTap: (v) => provider.filterToggleEventType(EventType.carMeet)),
    _filterEventType(
        context: context,
        type: LocaleKeys.Hosted_Create_eventTypes_sport.tr(),
        value: provider.searchQuery.eventTypes[EventType.sport],
        onTap: (v) => provider.filterToggleEventType(EventType.sport)),
    _filterEventType(
        context: context,
        type: LocaleKeys.Hosted_Create_eventTypes_others.tr(),
        value: provider.searchQuery.eventTypes[EventType.other],
        onTap: (v) => provider.filterToggleEventType(EventType.other)),
  ];
}

OutlinedButton _searchButton(SearchPageProvider provider) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      enableFeedback: true,
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.transparent, width: 1),
      shadowColor: Colors.black,
      elevation: 20,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    ),
    child: const Text(LocaleKeys.Map_btns_search,
            style: TextStyle(
                color: HATheme.HOPAUT_PINK, fontWeight: FontWeight.w600))
        .tr(),
    onPressed: () async => await provider.searchEvents(),
  );
}

Widget _filterEventType(
        {String type,
        bool value,
        Function(bool) onTap,
        BuildContext context}) =>
    Card(
      elevation: 5,
      color: Colors.transparent,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Row(
          children: [
            CircularCheckBox(
              value: value,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: HATheme.HOPAUT_PINK,
              disabledColor: Color(0xFFE7E7E7),
              inactiveColor: HATheme.HOPAUT_PINK,
              onChanged: onTap,
            ),
            Text(
              type,
              style: TextStyle(
                color: Color(0xFF2A2A2A),
                fontSize: 11.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
