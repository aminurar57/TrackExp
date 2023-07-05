import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_trackexpense/add_expenses.dart';
import 'core.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildTodayExpenses() {
    // Replace this with your Firestore query to fetch today's expenses
    // and return a widget to display the data
    return Center(
      child: HomeScreen(),
    );
  }

  Widget _buildAddDelete() {
    // Replace this with your implementation of the add/delete transactions screen
    // and return the corresponding widget
    return Center(
      child: AddTransactionsScreen(),
    );
  }

  Widget _buildProfile() {
    // Replace this with your implementation of the user's profile screen
    // and return the corresponding widget
    return Center(
      child: AnalysisScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TrackExp'),
      ),
      body: _currentIndex == 0
          ? _buildTodayExpenses()
          : _currentIndex == 1
          ? _buildAddDelete()
          : _buildProfile(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add/Delete',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
        ],
      ),
    );
  }
}
