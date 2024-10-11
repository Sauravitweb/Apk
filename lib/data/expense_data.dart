import 'package:flutter/material.dart';
import 'package:marks/data/hive_database.dart';
import 'package:marks/datetime/date_time_helper.dart';
import 'package:marks/models/expense_item.dart';

class ExpenseData extends ChangeNotifier {
//List of ALL expenses
  List<ExpenseItem> overallExpenseList = [];

//get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

// prepare data to display
  final db = HiveDataBase();
  void prepareData() {
    //if there exist data get it
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

//add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

//delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

//get weekday(mon, tues, etc) from a dataTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  //get the date for the start of the week
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get todays date
    DateTime today = DateTime.now();

    //go backwards from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  /*
    [ 20230130: $23 ],
    [ 20230131: $2 ],
    [ 20230102: $3 ],
    [ 20230103: $1 ],
    [ 20230104: $9 ],
  */
  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      //date (yyyymmdd) : amounttotalForDay
    };

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }
}
