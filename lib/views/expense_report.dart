import 'package:expense_tracker/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class expense_report extends StatefulWidget {
  const expense_report({super.key});

  @override
  State<expense_report> createState() => _expense_reportState();
}

class _expense_reportState extends State<expense_report> {
final TextEditingController _fromdatecontroller=TextEditingController();
final TextEditingController _todatecontroller = TextEditingController();

  List<Expense> expense = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primarycolor,
        title: Text(
          "Expense Report",
          style: TextStyle(color: Constants.secondarycolor, fontSize: 18),
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: datefield(controller: _fromdatecontroller)),
                  SizedBox(width: 5,),
                  Expanded(child: datefield(controller: _todatecontroller))
                ],
              ),
              SizedBox(height:10),
              button(text: "Search", onPressed: ()async{
              SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String phoneNumber =
                        prefs.containsKey('phoneNumber').toString();
                    List<Expense> tasks = await DatabaseHelper.instance
                        .getAllExpensesByPhoneNumber(phoneNumber);


  String startDateStr =_fromdatecontroller.text;
  String endDateStr = _todatecontroller.text;
  setState(() {
      expense = tasks.where((task) {
    DateTime startDate = _parseDate(startDateStr);
    DateTime endDate = _parseDate(endDateStr);
    DateTime taskDate = _parseDate(task.date.toString());
    return taskDate.isAfter(startDate.subtract(Duration(days: 1))) && taskDate.isBefore(endDate.add(Duration(days: 1)));
  }).toList();

  });


              }),

              expense.isEmpty?SizedBox():    ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expense.length,
                itemBuilder: (BuildContext context, int index) {
                  Expense task = expense[index];
                  return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListTile(
        tileColor: const Color(0xFFEAEAEA),
        title: 
            Text(
              "${task.name}-${task.amount}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
        
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
             'Tag - ${task.tag}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
           'Remarks - ${task.remarks ?? 'N/A'}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
            'Expense via - ${task.expenseVia ?? 'N/A'}',
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
                },
              ),
         
            ],
          ),

        ),
      ),
    );
  }
  DateTime _parseDate(String dateStr) {
  List<int> parts = dateStr.split('/').map(int.parse).toList();
  return DateTime(parts[2], parts[1], parts[0]);
}
}
