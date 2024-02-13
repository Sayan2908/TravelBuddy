import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:travel_checklist/firebase_options.dart';
import 'package:travel_checklist/screens/account_page.dart';
import 'package:travel_checklist/screens/home.dart';
import 'package:travel_checklist/screens/auth_screen.dart';
import 'package:travel_checklist/screens/shared_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  var box = await Hive.openBox('checklist');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    runApp(MyApp(user: user));
  });
}

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({Key? key, this.user}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: user != null ? '/home' : '/',
      routes: {
        '/': (context) => AuthPage(), // Default route
        '/home': (context) => MainScreen(), // Route for home page
        '/shared': (context) => SharedPage(),
        '/account': (context) => AccountPage(),
      },
    );
  }
}