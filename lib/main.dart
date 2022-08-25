import 'dart:developer';

import 'package:clean_framework/clean_framework.dart';
import 'package:fcm_apns/providers.dart';
import 'package:fcm_apns/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'asset_feature_provider.dart';

import 'config/fcm_module/fcm_service.dart';
import 'locator.dart';
import 'firebase_options.dart';
const landingPage = '/landingPage';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFCM();
  setupLocator();
  loadProviders();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  final FcmService fcmService = locator<FcmService>();
  @override
  Widget build(BuildContext context) {
    fcmService.getFCM();
    return FeatureScope<AssetFeatureProvider>(
      register: () => AssetFeatureProvider(),
      loader: (featureProvider) async {
        // To demonstrate the lazy update triggered by change in feature flags.
        await Future.delayed(Duration(seconds: 2));
        await featureProvider.load('assets/flags.json');
      },
      onLoaded: () {
        log('Feature Flags activated.');
      },
      child: AppProvidersContainer(
        providersContext: providersContext,
        onBuild: (context, _) {},
        child: MaterialApp.router(
          routeInformationParser: router.informationParser,
          routerDelegate: router.delegate,
          routeInformationProvider: router.informationProvider,
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
              },
            ),
          ),
        ),
      ),
    );
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

        actions: [IconButton(onPressed: (){

          router.to(Routes.countries);
        }, icon: const Icon(Icons.ac_unit))],
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
