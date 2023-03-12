import 'package:classroom_attendance/pages/home/attendance_page.dart';
import 'package:classroom_attendance/pages/home/history_page.dart';
import 'package:flutter/material.dart';

import '../../models/student.dart';

class HomePage extends StatefulWidget {
  final Student student;

  const HomePage({Key? key, required this.student}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _activeTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.student.firstName} ${widget.student.lastName}')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeTabIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Class',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        onTap: (index) {
          setState(() {
            _activeTabIndex = index;
          });
        },
      ),
      body: _activeTabIndex == 0 ? const AttendancePage() : const HistoryPage(),
    );
  }
}
