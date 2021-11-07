import 'package:hopaut/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'config/injection.dart';
import 'controllers/providers/account_provider.dart';
import 'controllers/providers/change_password_provider.dart';
import 'controllers/providers/event_provider.dart';
import 'controllers/providers/legacy_location_provider.dart';
import 'controllers/providers/location_provider.dart';
import 'controllers/providers/map_location_provider.dart';
import 'controllers/providers/search_page_provider.dart';
import 'controllers/providers/settings_provider.dart';

List<SingleChildWidget> providerList = [
  ChangeNotifierProvider<AuthenticationService>(
      create: (context) => getIt<AuthenticationService>()),
  ChangeNotifierProvider<SettingsProvider>(
      create: (context) => getIt<SettingsProvider>()),
  ChangeNotifierProvider<AccountProvider>(
      create: (context) => getIt<AccountProvider>()),
  ChangeNotifierProvider<ChangePasswordProvider>(
    create: (_) => getIt<ChangePasswordProvider>(),
    lazy: true,
  ),
  ChangeNotifierProvider<SearchPageProvider>(
    create: (_) => SearchPageProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<EventProvider>(
    create: (_) => getIt<EventProvider>(),
    lazy: true,
  ),
  ChangeNotifierProvider<GeolocationProvider>(
      create: (context) => getIt<GeolocationProvider>()),
  ChangeNotifierProvider<LocationServiceProvider>(
      create: (context) => getIt<LocationServiceProvider>()),
  ChangeNotifierProvider<MapLocationProvider>(
    create: (_) => MapLocationProvider(),
    lazy: true,
  ),
];
