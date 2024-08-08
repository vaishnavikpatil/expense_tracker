import 'package:expense_tracker/exports.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class expense_summary extends StatefulWidget {
  const expense_summary({super.key});

  @override
  State<expense_summary> createState() => _expense_summaryState();
}

class _expense_summaryState extends State<expense_summary> {
  List Month = [
    {"id": "01", "month": "Jan"},
    {"id": "02", "month": "Feb"},
    {"id": "03", "month": "Mar"},
    {"id": "04", "month": "Apr"},
    {"id": "05", "month": "May"},
    {"id": "06", "month": "Jun"},
    {"id": "07", "month": "Jul"},
    {"id": "08", "month": "Aug"},
    {"id": "09", "month": "Sep"},
    {"id": "10", "month": "Oct"},
    {"id": "11", "month": "Nov"},
    {"id": "12", "month": "Dec"}
  ];
  String month = '';
  List<Map<String, dynamic>> result = [];
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
          "Expense Summary",
          style: TextStyle(color: Constants.secondarycolor, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              dropdownfield(
                value: month,
                onSaved: (value) {
                  setState(() {
                    month = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    month = value;
                    print(value);
                  });
                },
                items: Month.map((item) {
                  return DropdownMenuItem<dynamic>(
                    value: item['id'].toString(),
                    child: Text(item['month'].toString(),
                        overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
              ),
              SizedBox(height:10),
              button(
                  text: "Search",
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String phoneNumber =
                        prefs.containsKey('phoneNumber').toString();
                    List<Expense> expenses = await DatabaseHelper.instance
                        .getAllExpensesByPhoneNumber(phoneNumber);
                

                    Map<String, double> tagTotals = {};

                    for (var expense in expenses) {
                      String tag = expense.tag.toString();
                      double amount = double.parse(expense.amount.toString());
                      String date = expense.date.toString();

                      if (date.contains(month)) {
                        if (tagTotals.containsKey(tag)) {
                          tagTotals[tag] = tagTotals[tag]! + amount;
                        } else {
                          tagTotals[tag] = amount;
                        }
                      }
                    }

                    setState(() {
                      result = tagTotals.entries.map((entry) {
                        return {'tag': entry.key, 'amount': entry.value};
                      }).toList();
                    });

                    print(result);
                  }),
              result.isEmpty
                  ? SizedBox()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: result.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(result[index]['tag'].toString()),
                                Text(result[index]['amount'].toString()),
                              ],
                            ));
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
