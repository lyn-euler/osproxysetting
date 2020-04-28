import 'dart:async';

import 'package:flutter/services.dart';

class _OsProxySettingKey {
  static final httpsEnable = 'HTTPSEnable';
  static final httpEnable = 'HTTPEnable';
  static final host = 'HTTPProxy';
  static final port = 'HTTPPort';
}

/// system proxy setting entity class
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

  /// 异步获取系统代理配置
  static Future<ProxySetting> get setting async {
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

  static const _DefaultMaxCacheTime = Duration.secondsPerMinute / 6;
  static ProxySetting _proxySetting;
  static DateTime _preFetchTime;

  /// 非实时数据
  static ProxySetting cacheSetting(
      {double maxCacheTime = _DefaultMaxCacheTime}) {
    final now = DateTime.now();
    if (_preFetchTime == null ||
        _proxySetting == null ||
        now.second - _preFetchTime.second > maxCacheTime) {
      setting.then((settings) {
        _proxySetting = settings;
        _preFetchTime = now;
      });
    }
    return _proxySetting;
  }
}
