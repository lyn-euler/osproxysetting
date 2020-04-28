import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:osproxysetting/os_proxy_settings.dart';

void main() {
  const MethodChannel channel = MethodChannel('osproxysetting');

  TestWidgetsFlutterBinding.ensureInitialized();
  const settings = {'test': 1};
  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return settings;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await OsProxySetting.settings, settings);
  });
}
