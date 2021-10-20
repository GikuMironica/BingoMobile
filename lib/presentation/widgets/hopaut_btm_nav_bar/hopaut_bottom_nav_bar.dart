import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/presentation/widgets/hopaut_btm_nav_bar/hopaut_nav_bar_item.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HopautNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<HopautNavBarItem> items;
  final ValueChanged<int> onItemSelected;

  HopautNavBar({this.items, this.selectedIndex, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            blurRadius: 3,
            spreadRadius: 1,
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, -4))
      ]),
      child: Container(
        color: Colors.white,
        child: Container(
            width: double.infinity,
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.map((i) {
                var idx = items.indexOf(i);
                return Flexible(
                  child: GestureDetector(
                    onTap: () => onItemSelected(idx),
                    child: _buildItem(i, selectedIndex == idx),
                  ),
                );
              }).toList(),
            )),
      ),
    );
  }

  Widget _buildItem(HopautNavBarItem item, bool isSelected) {
    return Container(
      alignment: Alignment.center,
      height: 60.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              child: Icon(
            item.svg,
            color: isSelected ? HATheme.HOPAUT_PINK : Colors.grey,
          )),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Material(
              type: MaterialType.transparency,
              child: FittedBox(
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
