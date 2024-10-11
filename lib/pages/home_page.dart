import 'package:flutter/material.dart';
import 'package:marks/components/expense_summary.dart';
import 'package:marks/components/expense_tile.dart';
import 'package:marks/data/expense_data.dart';
import 'package:marks/models/expense_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // add new expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(hintText: "Expense name"),
            ),

            Row(
              children: [
                //dollars
                Expanded(
                  child: TextField(
                    controller: newExpenseDollarController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Dollars"),
                  ),
                ),

                //cents
                Expanded(
                  child: TextField(
                    controller: newExpenseCentsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Dollars"),
                  ),
                ),
              ],
            )
          ],
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),

          // CAncel Button
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  // Save
  void save() {
    //only save expences if all fields are filled
    if (newExpenseCentsController.text.isNotEmpty &&
        newExpenseDollarController.text.isNotEmpty &&
        newExpenseNameController.text.isNotEmpty) {
      String amount =
          '${newExpenseDollarController.text}.${newExpenseCentsController.text}';

      //create expense item
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );
      // add the new expense
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }

    Navigator.pop(context);
    clear();
  }

  // cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  //clear controllers
  void clear() {
    newExpenseNameController.clear();
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (Context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
        body: ListView(children: [
          // Weekly summary
          ExpenseSummary(startOfWeek: value.startOfWeekDate()),

          const SizedBox(height: 20),
          // expense list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: value.getAllExpenseList().length,
            itemBuilder: (context, index) => ExpenseTile(
              name: value.getAllExpenseList()[index].name,
              amount: value.getAllExpenseList()[index].amount,
              dateTime: value.getAllExpenseList()[index].dateTime,
              deleteTapped: (p0) =>
                  deleteExpense(value.getAllExpenseList()[index]),
            ),
          )
        ]),
      ),
    );
  }
}
