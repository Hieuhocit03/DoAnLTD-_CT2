import 'package:do_an_app/srceens/test_login.dart';
import 'package:flutter/material.dart';
import 'package:do_an_app/srceens/user_list_admin.dart';

//import 'srceens/car_detail_screen.dart';
import 'srceens/home_screen.dart';

import 'srceens/login_screen.dart';
import 'srceens/register_screen.dart';
import 'srceens/Car_Input_Form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',//,git
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeAdminPage(),
    );
  }
}

