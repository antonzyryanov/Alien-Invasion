import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

class AppodealAdService {
  static const String _fakeTestAppKey = 'APPODEAL_FAKE_TEST_APP_KEY';

  bool _initialized = false;
  Completer<bool>? _rewardedCompleter;
  bool _rewardedFinished = false;

  bool get _isSupportedPlatform {
    if (kIsWeb) {
      return false;
    }
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  Future<void> initialize() async {
    if (_initialized || !_isSupportedPlatform) {
      return;
    }

    Appodeal.setTesting(true);
    Appodeal.initialize(
      appKey: _fakeTestAppKey,
      adTypes: [AppodealAdType.Banner, AppodealAdType.RewardedVideo],
      onInitializationFinished: (_) {},
    );
    Appodeal.cache(AppodealAdType.RewardedVideo);
    _initialized = true;
  }

  Future<bool> showRewardedVideoAndWait() async {
    if (!_isSupportedPlatform) {
      return true;
    }

    await initialize();

    final canShow = await Appodeal.canShow(AppodealAdType.RewardedVideo);
    if (!canShow) {
      Appodeal.cache(AppodealAdType.RewardedVideo);
      return false;
    }

    if (_rewardedCompleter != null && !_rewardedCompleter!.isCompleted) {
      return false;
    }

    _rewardedFinished = false;
    final completer = Completer<bool>();
    _rewardedCompleter = completer;

    Appodeal.setRewardedVideoCallbacks(
      onRewardedVideoLoaded: (_) {},
      onRewardedVideoFailedToLoad: () {
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      },
      onRewardedVideoShown: () {},
      onRewardedVideoShowFailed: () {
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      },
      onRewardedVideoFinished: (amount, reward) {
        _rewardedFinished = true;
      },
      onRewardedVideoClosed: (isFinished) {
        if (!completer.isCompleted) {
          completer.complete(_rewardedFinished || isFinished);
        }
      },
      onRewardedVideoExpired: () {
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      },
      onRewardedVideoClicked: () {},
    );

    Appodeal.show(AppodealAdType.RewardedVideo);

    try {
      final finished = await completer.future.timeout(
        const Duration(seconds: 90),
        onTimeout: () => false,
      );
      Appodeal.cache(AppodealAdType.RewardedVideo);
      return finished;
    } finally {
      _rewardedCompleter = null;
    }
  }
}
