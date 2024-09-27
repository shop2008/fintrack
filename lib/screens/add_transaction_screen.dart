import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack/services/transaction_service.dart';
import 'package:fintrack/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:fintrack/theme/app_colors.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TransactionCategory _selectedCategory = TransactionCategory.other;
  String _selectedAccount = 'Cash';
  TransactionType _transactionType = TransactionType.expense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('New Transaction'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _submitForm,
              child: Text('SAVE'),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20.0),
            children: [
              _buildTransactionTypeSelector(),
              SizedBox(height: 20),
              _buildInputField(_amountController, 'Amount', Icons.attach_money,
                  TextInputType.number),
              SizedBox(height: 20),
              _buildInputField(_noteController, 'Note', Icons.note),
              SizedBox(height: 20),
              _buildCategoryDropdown(),
              SizedBox(height: 20),
              _buildDatePicker(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: TransactionType.values.map((type) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () => setState(() => _transactionType = type),
                style: ElevatedButton.styleFrom(
                  primary: _transactionType == type
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  onPrimary: _transactionType == type
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyText1!.color,
                  elevation: _transactionType == type ? 4 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    type.displayName,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, String label, IconData icon,
      [TextInputType? keyboardType]) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.lightGrey,
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonFormField<TransactionCategory>(
        value: _selectedCategory,
        onChanged: (TransactionCategory? newValue) {
          setState(() {
            _selectedCategory = newValue!;
          });
        },
        items: TransactionCategory.values.map((category) {
          return DropdownMenuItem(
            value: category,
            child: Text(category.toString().split('.').last),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Category',
          prefixIcon:
              Icon(Icons.category, color: Theme.of(context).primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.lightGrey,
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading:
            Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
        title: Text('Date'),
        subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: Theme.of(context).primaryColor,
                  colorScheme: ColorScheme.light(
                      primary: Theme.of(context).primaryColor),
                  buttonTheme:
                      ButtonThemeData(textTheme: ButtonTextTheme.primary),
                ),
                child: child!,
              );
            },
          );
          if (picked != null && picked != _selectedDate) {
            setState(() {
              _selectedDate = picked;
            });
          }
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: double.parse(_amountController.text),
        title: _noteController.text,
        date: _selectedDate,
        category: _selectedCategory,
        account: _selectedAccount,
        type: _transactionType,
      );

      ref.read(transactionServiceProvider.notifier).addTransaction(transaction);
      Navigator.pop(context);
    }
  }
}
