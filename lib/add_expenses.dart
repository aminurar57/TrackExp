import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTransactionsScreen extends StatefulWidget {
  @override
  _AddTransactionsScreenState createState() => _AddTransactionsScreenState();
}

class _AddTransactionsScreenState extends State<AddTransactionsScreen> {
  final _typeController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _paymentModeController = TextEditingController();

  void _addTransaction() {
    // Get the transaction data from the input fields
    String type = _typeController.text;
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    String category = _categoryController.text;
    String paymentMode = _paymentModeController.text;

    // Save the transaction data to Firestore
    FirebaseFirestore.instance.collection('transactions').add({
      'type': type,
      'amount': amount,
      'category': category,
      'paymentMode': paymentMode,
    });

    // Clear the input fields
    _typeController.clear();
    _amountController.clear();
    _categoryController.clear();
    _paymentModeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transactions'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _paymentModeController,
              decoration: InputDecoration(labelText: 'Payment Mode'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addTransaction,
              child: Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalysisScreen extends StatefulWidget {
  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  List<Map<String, dynamic>> _analysisData = [];

  @override
  void initState() {
    super.initState();
    _fetchAnalysisData();
  }

  Future<void> _fetchAnalysisData() async {
    final snapshot = await FirebaseFirestore.instance.collection('transactions').get();
    List<Map<String, dynamic>> data = [];

    snapshot.docs.forEach((doc) {
      Map<String, dynamic> transaction = doc.data() as Map<String, dynamic>;
      data.add(transaction);
    });

    setState(() {
      _analysisData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis'),
      ),
      body: ListView.builder(
        itemCount: _analysisData.length,
        itemBuilder: (context, index) {
          final transaction = _analysisData[index];
          return ListTile(
            leading: Icon(Icons.attach_money),
            title: Text(transaction['type']),
            subtitle: Text(transaction['category']),
            trailing: Text(transaction['amount'].toString()),
          );
        },
      ),
    );
  }
}
