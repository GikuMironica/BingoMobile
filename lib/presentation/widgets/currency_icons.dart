import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

IconData currencyIcon(int currency){
  switch(currency){
    case 0:
      return MdiIcons.currencyEur;
      break;
    case 1:
      return MdiIcons.currencyUsd;
      break;
    case 2:
      return MdiIcons.currencyRub;
      break;
  }
}