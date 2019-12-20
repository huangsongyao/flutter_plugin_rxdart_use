import 'dart:async';
import 'package:flutter/services.dart';
import 'rxdart_use.dart';

class FlutterPluginRxdartUse {
  static const MethodChannel _channel =
      const MethodChannel('flutter_plugin_rxdart_use');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');

    return version;
  }
}
