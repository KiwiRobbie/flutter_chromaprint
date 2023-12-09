import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_chromaprint_platform_interface.dart';

/// An implementation of [FlutterChromaprintPlatform] that uses method channels.
class MethodChannelFlutterChromaprint extends FlutterChromaprintPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_chromaprint');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
