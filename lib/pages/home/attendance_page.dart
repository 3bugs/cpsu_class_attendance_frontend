import 'package:classroom_attendance/services/api.dart';
import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          var checkInSuccess = await ApiClient().studentCheckIn('555', 1);

          debugPrint(checkInSuccess.toString());
        },
        child: const Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('Check In Class 4'),
        ),
      ),
    );
  }
}
