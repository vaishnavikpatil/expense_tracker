
import 'package:expense_tracker/exports.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/views/delete_tag.dart';
import 'package:expense_tracker/views/expense_report.dart';
import 'package:expense_tracker/views/expense_summary.dart';
import 'package:expense_tracker/views/update_tag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class dashboardscreen extends StatefulWidget {
  const dashboardscreen({super.key});

  @override
  State<dashboardscreen> createState() => _dashboardscreenState();
}

class _dashboardscreenState extends State<dashboardscreen> {
  final dbHelper = DatabaseHelper.instance;
  List<String> dates = [];
  Map<String, List<Expense>> tasks = {};
List tags=[];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _deleteExpense(int id) async {
    print(id);
    await dbHelper.deleteExpense(id);
    _loadData();
  }

  void _loadData() async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
   String phoneNumber= prefs.containsKey('phoneNumber').toString();
     List<Expense> expenses = await DatabaseHelper.instance.getAllExpensesByPhoneNumber(phoneNumber);
  print('All expenses: $expenses');
print(expenses.first.date);
   tags = await DatabaseHelper.instance.getAllTags();
  print('All tags: $tags');




    dates.clear();
    tasks.clear();

    expenses.forEach((expense) {
      String? date = expense.date;
      if (!dates.contains(date)) {
        dates.add(date!);
        tasks[date] = [];
      }
      tasks[date]?.add(expense);
    });

    dates.sort((a, b) => DateFormat('dd/MM/yyyy').parse(b).compareTo(DateFormat('dd/MM/yyyy').parse(a)));

    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Expense expense=Expense();
          Navigator.push(context, MaterialPageRoute(builder: (context) => add_expense(expense: expense,))).then((value) => _loadData());
        },
        child: Icon(Icons.add, color: Constants.secondarycolor),
        backgroundColor: Constants.primarycolor,
      ),
      appBar: AppBar(
        backgroundColor: Constants.primarycolor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome",
              style: TextStyle(color: Constants.secondarycolor, fontSize: 18),
            ),
            Text(
              "9168771081", // Replace with actual user info retrieval logic
              style: TextStyle(color: Constants.secondarycolor, fontSize: 14),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, color: Constants.secondarycolor),
            onSelected: (String value) {
              // Handle menu item selection
              switch (value) {
                case 'Add Tags':
           showDialog(
        context: context,
        builder: (_) => const addtag( )
    ).then((value) => _loadData());
                  break;
                case 'Update Tags':
                  showDialog(
        context: context,
        builder: (_) => const updatetag( )
    ).then((value) => _loadData());
                  break;
                case 'Delete Tags':
                  showDialog(
        context: context,
        builder: (_) => const deletetag( )
    ).then((value) => _loadData());
                  break;
                case 'Set Monthly Budget':
                  // Implement action
                  break;
                case 'Expense Summary':
           Navigator.push(context, MaterialPageRoute(builder: ((context) => expense_summary()))).then((value) => _loadData());
                  break;
                case 'Expense Report':
                Navigator.push(context, MaterialPageRoute(builder: ((context) => expense_report()))).then((value) => _loadData());
            break;
                case 'Log Out':
                logout();
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                "Add Tags",
                "Update Tags",
                "Delete Tags",
                "Set Monthly Budget",
                "Expense Summary",
                "Expense Report",
                "Log Out"
              ].map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dates.length,
        itemBuilder: (BuildContext context, int index) {
          String date = dates[index];
          List<Expense> dailyTasks = tasks[date] ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dailyTasks.length,
                itemBuilder: (BuildContext context, int taskIndex) {
                  Expense expense = dailyTasks[taskIndex];
                  return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListTile(
        tileColor: const Color(0xFFEAEAEA),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${expense.name}-${expense.amount}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.black),
              onSelected: (String value) {
                if(value=="Update Expense"){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>add_expense(expense: expense,))).then((value) => _loadData());
                }else{
                  _deleteExpense(expense.id!.toInt());
                }
              },
              itemBuilder: (BuildContext context) {
                return ["Update Expense", "Delete Expense"].map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              },
            )
          ],
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
             'Tag - ${expense.tag}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
           'Remarks - ${expense.remarks ?? 'N/A'}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
            'Expense via - ${expense.expenseVia ?? 'N/A'}',
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
                },
              ),
            ],
          );
        },
      ),
    );
  }
  logout()async{
       SharedPreferences preferences = await SharedPreferences.getInstance();
await preferences.clear();
Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => const MyApp())));
  }
}
