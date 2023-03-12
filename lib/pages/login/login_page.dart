import 'package:classroom_attendance/pages/home/home_page.dart';
import 'package:classroom_attendance/services/api.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _usernameController.text = '123456789';
    _passwordController.text = '123456789';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('❤  CP-SU Classroom Attendance v0.0.1  ❤', style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/images/logo_cpsu.png', height: 140.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 48.0),
                    child: Text(
                      'CP-SU\nClassroom Attendance'.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'รหัสนักศึกษา',
                      ),
                      validator: (value) {
                        if (value == null || value.length != 9) {
                          return 'ต้องกรอกรหัสนักศึกษา 9 หลัก';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'รหัสผ่าน',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ต้องกรอกรหัสผ่าน';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 48.0),
                    child: ElevatedButton(
                      onPressed: _handleClickLogin,
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('LOGIN'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  void _handleClickLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        var student = await ApiClient().studentLogin(
          _usernameController.text,
          _passwordController.text,
        );

        if (!mounted) return;
        if (student != null) {
          var displayName = '${student.firstName} ${student.lastName}';
          debugPrint(displayName);
          _showSnackBar(
            'Hi, $displayName',
            durationSeconds: 10,
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {},
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(student: student)),
          );
        } else {
          _showSnackBar(
            'รหัสนักศึกษาหรือรหัสผ่าน ไม่ถูกต้อง !!!',
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {},
            ),
          );
        }
      } catch (e) {
        _showSnackBar(
          'เกิดข้อผิดพลาดในการเชื่อมต่อ API:\n${e.toString()}',
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {int? durationSeconds, SnackBarAction? action}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: durationSeconds ?? 365 * 24 * 60 * 60),
        action: action,
      ),
    );
  }
}
