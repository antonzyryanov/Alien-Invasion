import 'package:flutter/widgets.dart';

import '../models/app_route.dart';

class AppRouteParser extends RouteInformationParser<AppRoute> {
  @override
  Future<AppRoute> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final location = routeInformation.uri.path;
    return switch (location) {
      '/onboarding' => AppRoute.onboarding,
      '/menu' => AppRoute.menu,
      '/game' => AppRoute.game,
      '/scores' => AppRoute.scores,
      '/credits' => AppRoute.credits,
      '/settings' => AppRoute.settings,
      _ => AppRoute.enterName,
    };
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoute configuration) {
    final location = switch (configuration) {
      AppRoute.enterName => '/',
      AppRoute.onboarding => '/onboarding',
      AppRoute.menu => '/menu',
      AppRoute.game => '/game',
      AppRoute.scores => '/scores',
      AppRoute.credits => '/credits',
      AppRoute.settings => '/settings',
    };
    return RouteInformation(uri: Uri.parse(location));
  }
}
