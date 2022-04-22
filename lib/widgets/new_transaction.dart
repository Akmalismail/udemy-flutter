import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function(String, double) addNewTransaction;

  NewTransaction(this.addNewTransaction);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void onSubmitTransaction() {
    final enteredTitle = titleController.text;
    final enteredAmount = amountController.text.isNotEmpty
        ? double.parse(amountController.text)
        : 0;

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    widget.addNewTransaction(enteredTitle, enteredAmount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              onSubmitted: (_) => onSubmitTransaction(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => onSubmitTransaction(),
            ),
            TextButton(
              onPressed: onSubmitTransaction,
              child: Text('Add Transaction'),
              style: TextButton.styleFrom(
                primary: Colors.purple,
              ),
            )
          ],
        ),
      ),
    );
  }
}
