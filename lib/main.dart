
//IT20190002
//T.D.M.A.Doloswala
import 'package:ctserecipeapplabtest/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CTSE Lab Test',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home:  LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

