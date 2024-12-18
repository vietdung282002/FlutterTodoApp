import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/config/shared_preferences_helper.dart';
import 'package:flutter_todo_app/config/values.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_todo_app/view/home_screen/todo_list_view_model.dart';
import 'package:flutter_todo_app/view/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await dotenv.load();
  runApp(const MyApp());
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoListViewModel>(
          create: (_) => TodoListViewModel(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
        },
      ),
    );
  }
}
