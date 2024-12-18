import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_todo_app/view/home_screen/home_screen.dart';
import 'package:flutter_todo_app/view/login_screen/login_screen.dart';
import 'package:flutter_todo_app/view_model/todo_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? action = prefs.getString('device_udid');
    if (action == null) {
      final deviceInfo = DeviceInfoPlugin();
      String deviceUDID;

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
      await prefs.setString('device_udid', deviceUDID);
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
    return ChangeNotifierProvider<TodoListViewModel>(
      create: (_) => TodoListViewModel(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
