// ignore_for_file: camel_case_types

import 'package:expense_tracker/exports.dart';
import 'package:flutter/material.dart';


class addtag extends StatefulWidget {

 

   const addtag({super.key, });

  @override
  State<addtag> createState() => _addtagState();
}

class _addtagState extends State<addtag> {
TextEditingController _tagcontroller=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return  Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
height:250,
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                   Text("Add Tag", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
              
                Navigator.of(context).pop();
              },
            ),
              ],
            ),
         
            SizedBox(height: 10),
            text_field(controller: _tagcontroller),
            SizedBox(height: 20),
            button(text: "Add Tag",   onPressed: () {
                  addTag();
                Navigator.of(context).pop();
              },)
      
         
             
          ],
        ),
      ),
    );
 
  }
void addTag() async {
  int result = await DatabaseHelper.instance.addTag(_tagcontroller.text);
  print('Add tag result: $result');
}
}
