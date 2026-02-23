import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:alien_invasion/app/bloc/main_bloc/main_bloc.dart';

import '../app_design/app_colors.dart';
import '../localizations/app_localizations.dart';
import 'repositories/score_repository.dart';
import 'router/app_route_parser.dart';
import 'router/app_router_delegate.dart';
import 'services/app_logger.dart';

class AlienInvasionApp extends StatefulWidget {
  const AlienInvasionApp({this.enableLevelTicker = true, super.key});

  final bool enableLevelTicker;

  @override
  State<AlienInvasionApp> createState() => _AlienInvasionAppState();
}

class _AlienInvasionAppState extends State<AlienInvasionApp> {
  late final MainBloc _mainBloc;
  late final AppRouterDelegate _routerDelegate;
  final AppRouteParser _routeParser = AppRouteParser();

  @override
  void initState() {
    super.initState();
    configureAppLogger();
    _mainBloc = MainBloc(
      scoreRepository: ScoreRepository(),
      enableLevelTicker: widget.enableLevelTicker,
    )..add(const MainStarted());
    _routerDelegate = AppRouterDelegate(mainBloc: _mainBloc);
  }

  @override
  void dispose() {
    _routerDelegate.dispose();
    _mainBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mainBloc,
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Alien Invasion',
            debugShowCheckedModeBanner: false,
            locale: state.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeParser,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.purple,
                brightness: Brightness.dark,
                primary: AppColors.purple,
                secondary: AppColors.gray,
              ),
              scaffoldBackgroundColor: AppColors.purple,
              textTheme: ThemeData.dark().textTheme.apply(
                bodyColor: AppColors.white,
                displayColor: AppColors.white,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.purple,
                foregroundColor: AppColors.white,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.menuButton,
                  foregroundColor: AppColors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
