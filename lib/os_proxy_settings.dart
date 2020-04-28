import 'dart:async';

import 'package:flutter/services.dart';

class _OsProxySettingKey {
  static final httpsEnable = 'HTTPSEnable';
  static final httpEnable = 'HTTPEnable';
  static final host = 'HTTPProxy';
  static final port = 'HTTPPort';
}

class ProxySetting {
  final bool httpEnable;

//  final bool httpsEnable;
  final String host;
  final String port;

  ProxySetting({this.httpEnable = false, this.host, this.port});

  @override
  String toString() {
    return '{enable: $httpEnable, host: $host, port: $port}';
  }
}

class OsProxySetting {
  static const MethodChannel _channel = const MethodChannel('osproxysetting');

  static Future<ProxySetting> get settings async {
    final Map settings = await _channel.invokeMethod('settings');
    if (settings == null) {
      return ProxySetting();
    }
    var httpEnable = settings[_OsProxySettingKey.httpEnable] ?? false;
    if (httpEnable is String) {
      httpEnable = httpEnable == 'true' || (int.parse(httpEnable) != 0);
    }
    return ProxySetting(
      httpEnable: httpEnable,
//      httpsEnable: settings[_OsProxySettingKey.httpsEnable] ?? false,
      host: settings[_OsProxySettingKey.host],
      port: settings[_OsProxySettingKey.port],
    );
  }
}
