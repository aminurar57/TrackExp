import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference _expensesCollection =
  FirebaseFirestore.instance.collection('expenses');
  final CollectionReference _incomeCollection =
  FirebaseFirestore.instance.collection('income');

  double _totalExpenses = 0;
  double _totalIncome = 0;

  @override
  void initState() {
    super.initState();
    fetchTotalExpenses();
    fetchTotalIncome();
  }

  void fetchTotalExpenses() async {
    QuerySnapshot snapshot = await _expensesCollection.get();
    double total = 0;
    snapshot.docs.forEach((doc) {
      total += doc['amount'];
    });
    setState(() {
      _totalExpenses = total;
    });
  }

  void fetchTotalIncome() async {
    QuerySnapshot snapshot = await _incomeCollection.get();
    double total = 0;
    snapshot.docs.forEach((doc) {
      total += doc['amount'];
    });
    setState(() {
      _totalIncome = total;
    });
  }

  double getBalance() {
    return _totalIncome - _totalExpenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TrackExp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Current Month',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Total Expenses: \$$_totalExpenses',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Total Income: \$$_totalIncome',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Balance: \$${getBalance().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _expensesCollection.orderBy('timestamp', descending: true).limit(5).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error retrieving expenses');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!snapshot.hasData) {
                    return Text('No expenses found');
                  }

                  final expenses = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];

                      return ListTile(
                        leading: Icon(Icons.attach_money),
                        title: Text(expense['expense']),
                        subtitle: Text(expense['category']),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
