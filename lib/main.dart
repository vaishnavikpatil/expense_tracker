import 'package:expense_tracker/views/login.dart';
import 'package:expense_tracker/views/dashboard.dart'; // Import the dashboard screen
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('phoneNumber');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If there's an error, show the login screen
          if (snapshot.hasError) {
            return const loginscreen();
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const dashboardscreen(); 
          } else {
            return const loginscreen();
          }
        },
      ),
    );
  }
}
