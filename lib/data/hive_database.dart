import 'package:hive_flutter/hive_flutter.dart';
import 'package:marks/models/expense_item.dart';

class HiveDataBase {
  //reference our box
  final _myBox = Hive.box("expense_database");

  //write data
  void saveData(List<ExpenseItem> allExpense) {
    /*
      Hive can only store strings and datetime, not custom objects like expenseitem.
      so lets convert expense item in a type such that they can be stored in database






   
    */
    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpense) {
      //convert each expense item in the list of storable type(string, datetime..)
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];

      allExpensesFormatted.add(expenseFormatted);
    }

    //finally lets store in database
    _myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }

  //read data
  List<ExpenseItem> readData() {
    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];
    for (int i = 0; i < savedExpenses.length; i++) {
      //collect individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      //create expense item
      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      //add expense to overall list of expenses
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}
