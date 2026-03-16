import 'package:flutter/foundation.dart';

enum AppPlatform { windows, android, unsupported }

AppPlatform getAppPlatform() {
  switch (defaultTargetPlatform) {
    case TargetPlatform.windows:
      return AppPlatform.windows;
    case TargetPlatform.android:
      return AppPlatform.android;
    default:
      return AppPlatform.unsupported;
  }
}
