// ignore_for_file: camel_case_types

import 'package:expense_tracker/exports.dart';

import 'package:flutter/material.dart';


class updatetag extends StatefulWidget {

 

   const updatetag({super.key, });

  @override
  State<updatetag> createState() => _updatetagState();
}

class _updatetagState extends State<updatetag> {
TextEditingController _previoustagcontroller=TextEditingController();
TextEditingController _newtagcontroller=TextEditingController();
List tags=[];


@override
void initState(){
  _loadData();
  super.initState();
}
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
height:300,
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                   Text("Update Tag", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
              
                Navigator.of(context).pop();
              },
            ),
              ],
            ),
            SizedBox(height:10),
             dropdownfield(
             
                                  value: _previoustagcontroller.text,
                                  onSaved: (value) {
                                    setState(() {
                                  
                                      _previoustagcontroller.text = value;
                                     
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      
                                      _previoustagcontroller.text = value;
                                      print(value);
                                    });
                                  },
                                  items: tags.map((item) {
                                    return DropdownMenuItem<dynamic>(
                                      value: item['id'].toString(),
                                      child: Text(item['name'].toString(),
                                          
                                          overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                             
                                ),
            SizedBox(height: 10),
            text_field(controller: _newtagcontroller),
            SizedBox(height: 20),
            button(text: "Update Tag",   onPressed: () {
                  updatetag();
                Navigator.of(context).pop();
              },)
      
         
             
          ],
        ),
      ),
    );
 
  }
void updatetag() async {
  int result = await DatabaseHelper.instance.updateTag(int.parse(_previoustagcontroller.text), _newtagcontroller.text);
  print('Add tag result: $result');
}

     void _loadData() async {
   
    List a = await DatabaseHelper.instance.getAllTags();
   setState(() {
     tags=a;
   });


  }
}
