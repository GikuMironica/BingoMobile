import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/event_types.dart';
import 'package:hopaut/controllers/providers/search_page_provider.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class SearchPageFilter extends StatefulWidget {
  @override
  _SearchPageFilterState createState() => _SearchPageFilterState();
}

class _SearchPageFilterState extends State<SearchPageFilter> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchPageProvider>(
      builder: (context, provider, __) => Card(
        color: provider.filter ? Colors.white : Colors.white.withOpacity(0.3),
        elevation: provider.filter ? 4.0 : 0.0,
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
                  Icon(
                    Ionicons.search_outline,
                    color: Color(0xFFED2F65),
                  ),
                  VerticalDivider(
                    width: 3,
                    color: Color(0xFFED2F65),
                  ),
                  Expanded(
                    child: TextField(
                      //focusNode: _focusNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 8.0),
                        hintText: 'Search for events',
                        hintStyle: TextStyle(
                          color: Color(0xFF818181).withOpacity(0.69),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
                        'Select Type:',
                        style: TextStyle(
                          color: Color(0xFF2A2A2A),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(
                        height: 36.0,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            _filterEventType(
                                context: context,
                                type: 'House Party',
                                value: provider.searchQuery
                                    .eventTypes[EventType.houseParty],
                                onTap: (v) => provider.filterToggleEventType(
                                    EventType.houseParty)),
                            _filterEventType(
                                context: context,
                                type: 'Bar',
                                value: provider
                                    .searchQuery.eventTypes[EventType.bar],
                                onTap: (v) => provider
                                    .filterToggleEventType(EventType.bar)),
                            _filterEventType(
                                context: context,
                                type: 'Club',
                                value: provider
                                    .searchQuery.eventTypes[EventType.club],
                                onTap: (v) => provider
                                    .filterToggleEventType(EventType.club)),
                            _filterEventType(
                                context: context,
                                type: 'Street Party',
                                value: provider.searchQuery
                                    .eventTypes[EventType.streetParty],
                                onTap: (v) => provider.filterToggleEventType(
                                    EventType.streetParty)),
                            _filterEventType(
                                context: context,
                                type: 'Bicycle Meet',
                                value: provider.searchQuery
                                    .eventTypes[EventType.bicycleMeet],
                                onTap: (v) => provider.filterToggleEventType(
                                    EventType.bicycleMeet)),
                            _filterEventType(
                                context: context,
                                type: 'Biker Meet',
                                value: provider.searchQuery
                                    .eventTypes[EventType.bikerMeet],
                                onTap: (v) => provider.filterToggleEventType(
                                    EventType.bikerMeet)),
                            _filterEventType(
                                context: context,
                                type: 'Car Meet',
                                value: provider
                                    .searchQuery.eventTypes[EventType.carMeet],
                                onTap: (v) => provider
                                    .filterToggleEventType(EventType.carMeet)),
                            _filterEventType(
                                context: context,
                                type: 'Marathon',
                                value: provider
                                    .searchQuery.eventTypes[EventType.marathon],
                                onTap: (v) => provider
                                    .filterToggleEventType(EventType.marathon)),
                            _filterEventType(
                                context: context,
                                type: 'Other',
                                value: provider
                                    .searchQuery.eventTypes[EventType.other],
                                onTap: (v) => provider
                                    .filterToggleEventType(EventType.other)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Happening Today',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12.0),
                          ),
                          CircularCheckBox(
                              value: provider.searchQuery.today,
                              onChanged: (v) => provider.filterToggleToday()),
                        ],
                      ),
                      RaisedButton(
                        child: Text('Search'),
                        onPressed: () async => await provider.searchEvents(),
                      ),
                      SizedBox(height: 16.0),
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

Padding _filterEventType(
        {String type,
        bool value,
        Function(bool) onTap,
        BuildContext context}) =>
    Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Row(
        children: [
          CircularCheckBox(
            value: value,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: Theme.of(context).primaryColor,
            disabledColor: Color(0xFFE7E7E7),
            inactiveColor: Color(0xFFE7E7E7),
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
    );
