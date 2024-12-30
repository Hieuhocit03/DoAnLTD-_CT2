import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'carscreen.dart';
=======
import 'srceens/home_screen.dart';
import 'srceens/login_screen.dart';
import 'srceens/register_screen.dart';

>>>>>>> 1931a2c66a32c17b40edc5a52bbada99d369cdda
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
<<<<<<< HEAD
      home: CarDetailScreen(),
    );
  }
}

=======
      home: HomeScreen(),
    );
  }
}
>>>>>>> 1931a2c66a32c17b40edc5a52bbada99d369cdda
