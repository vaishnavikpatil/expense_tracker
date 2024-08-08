// ignore_for_file: camel_case_types

import 'package:expense_tracker/exports.dart';

import 'package:flutter/material.dart';


class deletetag extends StatefulWidget {

 

   const deletetag({super.key, });

  @override
  State<deletetag> createState() => _deletetagState();
}

class _deletetagState extends State<deletetag> {
TextEditingController _tagcontroller=TextEditingController();
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
height:250,
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                   Text("Delete Tag", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
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
             
                                  value: _tagcontroller.text,
                                  onSaved: (value) {
                                    setState(() {
                                  
                                      _tagcontroller.text = value;
                                     
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      
                                      _tagcontroller.text = value;
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
       
            SizedBox(height: 20),
            button(text: "Delete Tag",   onPressed: () {
                  deletetag();
                Navigator.of(context).pop();
              },)
      
         
             
          ],
        ),
      ),
    );
 
  }
void deletetag() async {
  int result = await DatabaseHelper.instance.deleteTag(int.parse(_tagcontroller.text));
  print('Add tag result: $result');
}

     void _loadData() async {
   
    List a = await DatabaseHelper.instance.getAllTags();
   setState(() {
     tags=a;
   });


  }
}
