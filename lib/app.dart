import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/app_ctrl.dart';
import 'package:flutter_todo_app/network/api_services.dart';
import 'package:flutter_todo_app/view/splash_screen/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'common/values.dart';
import 'config/shared_preferences_helper.dart';

Future<void> initServices() async {
  await Get.putAsync(() => ApiServices().init());
  Get.put(AppCtrl());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> getUDIDAndSave() async {
    final prefsHelper = SharedPreferencesHelper();

    String? deviceUDID;

    deviceUDID = await prefsHelper.getString(Values.udid);
    if (deviceUDID == null) {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        // Android device
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceUDID = androidInfo.id; // UDID for Android
      } else if (Platform.isIOS) {
        // iOS device
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceUDID = iosInfo.identifierForVendor ?? "Unknown"; // UDID for iOS
      } else {
        deviceUDID = "Unsupported Platform";
      }
      await prefsHelper.saveString(Values.udid, deviceUDID);
    }
  }

  @override
  void initState() {
    super.initState();
    getUDIDAndSave();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      home: const SplashScreen(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const SplashScreen(),
      // },
    );
  }
}
