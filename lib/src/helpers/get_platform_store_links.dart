import 'dart:io';

import 'package:grateful/src/config/config.dart';

String getPlatformStoreLink() {
  if (Platform.isAndroid) {
    return Config.androidStoreLink;
  } else if (Platform.isIOS) {
    return Config.iOSStoreLink;
  }
  return Config.androidStoreLink;
}
