import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chromaprint/flutter_chromaprint.dart';
import 'package:flutter_chromaprint/flutter_chromaprint_platform_interface.dart';
import 'package:flutter_chromaprint/flutter_chromaprint_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterChromaprintPlatform
    with MockPlatformInterfaceMixin
    implements FlutterChromaprintPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterChromaprintPlatform initialPlatform = FlutterChromaprintPlatform.instance;

  test('$MethodChannelFlutterChromaprint is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterChromaprint>());
  });

  test('getPlatformVersion', () async {
    FlutterChromaprint flutterChromaprintPlugin = FlutterChromaprint();
    MockFlutterChromaprintPlatform fakePlatform = MockFlutterChromaprintPlatform();
    FlutterChromaprintPlatform.instance = fakePlatform;

    expect(await flutterChromaprintPlugin.getPlatformVersion(), '42');
  });
}
