import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/presentation/widgets/hopaut_btm_nav_bar/hopaut_nav_bar_item.dart';

class HopautNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<HopautNavBarItem> items;
  final ValueChanged<int> onItemSelected;

  HopautNavBar(
      {required this.items,
      required this.selectedIndex,
      required this.onItemSelected});

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
            color: isSelected ? HATheme.HOPAUT_PINK : Colors.grey.shade500,
          )),
          Material(
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
          )
        ],
      ),
    );
  }
}
