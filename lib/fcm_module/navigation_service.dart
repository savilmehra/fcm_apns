import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName,
      dynamic remoteMessage) {

    return navigatorKey.currentState!.pushNamed(routeName, arguments: remoteMessage);
  }


}
