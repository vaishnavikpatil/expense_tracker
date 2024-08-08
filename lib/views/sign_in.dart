
import 'package:flutter/material.dart';
import 'package:expense_tracker/exports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signinscreen extends StatefulWidget {
  const signinscreen({super.key});

  @override
  State<signinscreen> createState() => _signinscreenState();
}

class _signinscreenState extends State<signinscreen> {
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
              SizedBox(height: 20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Phone Number",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              SizedBox(height: 20),
              text_field(
                controller: _phonenumbercontroller,
                hintText: "Enter Phone Number",
              ),
              SizedBox(height: 50),
             
                 
                      button(text: "Sign In", onPressed: () {
                           signUpUser();
                      }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUpUser() async {
    String phoneNumber = _phonenumbercontroller.text.trim();
    var userId = await DatabaseHelper.instance.createUser(phoneNumber);

    // Save phoneNumber and userId in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNumber', phoneNumber);
    
print(userId);
    // Navigate to dashboard screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dashboardscreen()),
    );
  }

}
