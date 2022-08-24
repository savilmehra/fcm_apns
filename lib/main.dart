import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'fcm_module/fcm_service.dart';
import 'package:firebase_core/firebase_core.dart';

import 'fcm_module/locator.dart';
import 'fcm_module/navigation_service.dart';
import 'firebase_options.dart';
const landingPage = '/landingPage';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFCM();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final FcmService fcmService = locator<FcmService>();

  @override
  Widget build(BuildContext context) {
    fcmService.getFCM();
    return MaterialApp(
      title: 'Notifications',
      onGenerateRoute: _routes(),///-------------for routing to different pages
      navigatorKey: locator<NavigationService>().navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Notifications'),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      Widget screen;
      dynamic  data = settings.arguments ;
      
      switch (settings.name) {
        case landingPage:
          screen = const LandingPage();
          break;
          default:
            screen = const MyHomePage(title: "HomePage");
      }
      return MaterialPageRoute(
        builder: (BuildContext context) => screen,
      );
    };
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    getfcmt();
    super.initState();
  }

  Future<void> getfcmt() async {
    String? token = await FirebaseMessaging.instance.getToken();

    print("fcm------${token ?? "-"}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text("Notifications"),
      ),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LandingPage"),
      ),
      body: const Center(
        child: Text("LandingPage on notification click"),
      ),
    );
  }
}
