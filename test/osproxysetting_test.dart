import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:osproxysetting/os_proxy_settings.dart';

void main() {
  const MethodChannel channel = MethodChannel('osproxysetting');

  TestWidgetsFlutterBinding.ensureInitialized();
  const settings = {'enable': false, 'host': null, 'port': null};
  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return settings;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('get proxy setting', () async {
    final setting = await OsProxySetting.setting;
    expect(setting.toString(), settings.toString());
  });
}
