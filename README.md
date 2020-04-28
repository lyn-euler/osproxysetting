# osproxysetting

A new Flutter plugin to fetch os proxy setting.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

## Usage
U can use this plugin to fetch system proxy settings. And can set `HttpClient`'s findProxy method, so that u can use Charles(or other tools) to wireshark
Example in use dio in Flutter or other libary use HttpCilent.

```Dart
if (_debugMode) {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) async {
    client.findProxy = (uri) {
        final setting = OsProxySetting.cacheSetting();
        if (setting == null ||
            !setting.httpEnable ||
            setting.port == null ||
            setting.host == null) {
        return "DIRECT";
        }
        return "PROXY ${setting.host}:${setting.port}";
    };
    };
}
```
