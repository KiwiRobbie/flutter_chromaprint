import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_chromaprint_method_channel.dart';

abstract class FlutterChromaprintPlatform extends PlatformInterface {
  /// Constructs a FlutterChromaprintPlatform.
  FlutterChromaprintPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterChromaprintPlatform _instance = MethodChannelFlutterChromaprint();

  /// The default instance of [FlutterChromaprintPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterChromaprint].
  static FlutterChromaprintPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterChromaprintPlatform] when
  /// they register themselves.
  static set instance(FlutterChromaprintPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
