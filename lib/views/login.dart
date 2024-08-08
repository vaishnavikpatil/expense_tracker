
import 'package:flutter/material.dart';
import 'package:expense_tracker/exports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginscreen extends StatefulWidget {
  const loginscreen({super.key});

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  TextEditingController _phonenumbercontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/image.png"),
              const SizedBox(height: 20),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Phone Number",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const SizedBox(height: 20),
              text_field(
                controller: _phonenumbercontroller,
                hintText: "Enter Phone Number",
              ),
              const SizedBox(height: 50),
              button(text: "Log In", onPressed: () {
               loginUser();
              }),
              const SizedBox(height: 20),
              const Text("Don't have an account?"),
              const SizedBox(height: 20),
              button(text: "Sign In", onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) =>signinscreen() )));
              }),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> loginUser() async {
    String phoneNumber = _phonenumbercontroller.text.trim();

  



    var user = (await DatabaseHelper.instance.getUserByPhoneNumber(phoneNumber));
    if (user != null) {
      print(user);
      print(user);
      print(user);
          
    SharedPreferences prefs = await SharedPreferences.getInstance();
       await prefs.setString('phoneNumber', phoneNumber);
    // await prefs.setInt('userId', user);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>dashboardscreen())); // Example navigation
    } else {
      // Handle case where user is not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not found. Please sign up first.')),
      );
    }
  }
}
