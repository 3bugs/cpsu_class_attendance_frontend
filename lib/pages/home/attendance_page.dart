import 'package:classroom_attendance/models/student.dart';
import 'package:classroom_attendance/services/api.dart';
import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<Student>? _studentList;
  bool _isLoading = false;
  bool _isError = false;
  String _errMessage = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    await Future.delayed(const Duration(seconds: 3), () {});

    try {
      var result = await ApiClient().getAllStudents();
      setState(() {
        _studentList = result;
      });
    } catch (e) {
      setState(() {
        _errMessage = e.toString();
        _isError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
// error message และปุ่ม retry
        if (_isError)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_errMessage),
                ElevatedButton(
                  onPressed: () {
                    loadData();
                  },
                  child: const Text('RETRY'),
                )
              ],
            ),
          ),

// listview
        _studentList == null
            ? const SizedBox.shrink()
            : ListView.builder(
                itemCount: _studentList!.length,
                itemBuilder: (context, index) {
                  return Text(_studentList![index].firstName);
                },
              ),

// progress indicator
        if (_isLoading) const Center(child: CircularProgressIndicator())
      ],
    );
  }
}
