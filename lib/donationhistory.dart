import 'package:flutter/material.dart';

import 'user.dart';

class DonationHistoryScreen extends StatefulWidget {
  final User user;

  DonationHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _DonationHistoryScreenState createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height:250,
            width: 220,
            color: Colors.blue,
            child: Container(
            height:150,
            width: 120,
            color: Colors.green,
            child: Text('Hi'),
          ),
        ),
      ),
    );
  }
}
