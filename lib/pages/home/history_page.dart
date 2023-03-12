import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('History Page'),
    );
  }
}
