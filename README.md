# Hopaut

Hopaut - Mobile

## Getting Started

## To regenerate the injection.config.dart file:
- flutter packages pub run build_runner watch

## To regenerate the LocalKeys.dart for the translations:
- flutter pub run easy_localization:generate --source-dir ./assets/translations
- flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir ./assets/translations

## To use the translations by key must import these 2:
- import 'package:easy_localization/easy_localization.dart';
- import 'package:hopaut/generated/locale_keys.g.dart';