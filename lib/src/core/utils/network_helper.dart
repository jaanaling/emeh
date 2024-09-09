import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

class NetworkHelper {
  static ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);

  static Future<bool> connected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return isConnected.value = connectivityResult != ConnectivityResult.none;
  }
}
