// ignore_for_file: camel_case_types

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:expense_tracker/exports.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class add_expense extends StatefulWidget {
 final Expense expense;
  const add_expense({ required this.expense,super.key});

  @override
  State<add_expense> createState() => _add_expenseState();
}

class _add_expenseState extends State<add_expense> {
  
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _amountcontroller = TextEditingController();
    final TextEditingController _remarkscontroller = TextEditingController();
          final TextEditingController _datecontroller = TextEditingController();

final dbHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  int id=0;
  String tag="";
  String expensevia="";
List<String> tags=[];
Expense expense=Expense();


  @override
  void initState(){
    expense=widget.expense;
print(expense.name);
if(expense.name==null){
  _loadData();
   if(mounted){
setState(() {
  
final random = Random();
 id = random.nextInt(9000) + 1000;
      _datecontroller.text=DateFormat('dd/MM/yyyy').format(DateTime.now());
    });

    }
}else{
  
_loadData();
if(mounted){
  setState(() {
    id=int.parse(expense.id.toString());
    _titlecontroller.text=expense.name??"";
_remarkscontroller.text=expense.remarks??"";
_amountcontroller.text=expense.amount.toString();
tag=expense.tag??"";
expensevia=expense.expenseVia??"";
_datecontroller.text=expense.date??"";
  });
}




}

  
    
    super.initState();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primarycolor,
        title: 
            Text(
    expense.name==null? "Add Expense":"Update Expense",
              style: TextStyle(color: Constants.secondarycolor, fontSize: 18),
            ),
           
      ),
      body: Form(
       key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const Text(
                      "Title",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                const SizedBox(height: 10),
                text_field(
                  controller: _titlecontroller,
                  hintText: "",
                  validator: (value) {
                    if (value!.isEmpty) {
      return 'Please Enter Title';
    }

    return null;
                  },
                ),
                 const SizedBox(height: 10),
                  const Text(
                      "Amount",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                const SizedBox(height: 10),
                text_field(
                  keyboardType: TextInputType.number,
                  controller: _amountcontroller,
                  hintText: "",
                   validator: (value) {
                    if (value!.isEmpty) {
      return 'Please Enter Amount';
    }

    return null;
                  },
                ),
 const SizedBox(height: 10),
                   const Text(
                      "Remarks",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                const SizedBox(height: 10),
                text_field(
                  maxlines: 4,
                  controller: _remarkscontroller,
                  hintText: "",
                ),
                const SizedBox(height: 10),
                   const Text(
                      "Tag",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      
                    ),
                const SizedBox(height: 10),
       dropdownfield(
             
                                  value: tag,
                                  onSaved: (value) {
                                    setState(() {
                                      tag = value;
                                     
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      tag = value;
                                      print(value);
                                    });
                                  },
                                  items: tags.map((item) {
                                    return DropdownMenuItem<dynamic>(
                                      value: item,
                                      child: Text(item.toString(),
                                          
                                          overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                             
                                ),
                           
      
                const SizedBox(height: 10),
                   const Text(
                      "Expense via",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                const SizedBox(height: 10),
            dropdownfield(
                            
                                  value: expensevia,
                                  onSaved: (value) {
                                    setState(() {
                                      expensevia = value;
                                     
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      expensevia = value;
                                      print(value);
                                    });
                                  },
                                  items: ['Card','Cash','UPI'].map((item) {
                                    return DropdownMenuItem<dynamic>(
                                      value: item,
                                      child: Text(item.toString(),
                                          
                                          overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                             
                                ),
            
                  const SizedBox(height: 10),
                   const Text(
                       "Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                const SizedBox(height: 10),
               datefield(controller: _datecontroller),

                           const SizedBox(height: 20),
                           button(text:expense.name==null?"Add Expense":"Update Expense", onPressed: () async {
                         if (_formKey.currentState!.validate()) {
                          expense.name==null?
                             addExpense().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> dashboardscreen())))
                  :             updateExpense().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> dashboardscreen())));
                        
                         }
                           })
              ],
            ),
          ),
        ),
      ),
        
    );
  }
   Future<void> addExpense() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoneNumber= prefs.containsKey('phoneNumber').toString();
 
 
    Expense expense = Expense(
      id: id,
      phoneNumber:phoneNumber,
      name: _titlecontroller.text.trim(),
      expenseVia:expensevia, 
      tag:tag, 
      remarks: _remarkscontroller.text.trim(),
      amount:double.parse(_amountcontroller.text.trim()),
      date:_datecontroller.text,
    );
    int result = await DatabaseHelper.instance.addExpense(expense);
  print('Add expense result: $result');
  
  }
   Future<void> updateExpense() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoneNumber= prefs.containsKey('phoneNumber').toString();
 
 
    Expense expense = Expense(
      id: id,
      phoneNumber:phoneNumber,
      name: _titlecontroller.text.trim(),
      expenseVia:expensevia, 
      tag:tag, 
      remarks: _remarkscontroller.text.trim(),
      amount:double.parse(_amountcontroller.text.trim()),
      date:_datecontroller.text,
    );
    int result = await DatabaseHelper.instance.updateExpense(expense);
  print('Update expense result: $result');
  
  }

     void _loadData() async {
   
    List data = await DatabaseHelper.instance.getAllTags();
    setState(() {
              tags = data.map((item) => item['name'].toString()).toList();
    });


  }
}