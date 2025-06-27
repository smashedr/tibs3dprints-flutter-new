import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../api_service.dart';
import 'confirm_page.dart';
import 'login_state.dart';

final _logger = Logger();
final session = LoginSession();


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login or Register')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Login or Register",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const MyCustomForm(),
                    const SizedBox(height: 16),
                    const Text("We will only send you a verification code."),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _logEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _logger.w("Email field is empty");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
    } else {
      _logger.d("Entered email: $email");
      session.email = email;

      final apiService = ApiService();

      final state = generateStateToken();
      _logger.d("state: $state");
      session.stateToken = state;

      _logger.d('Session set: email=${session.email}, state=${session.stateToken}');

      final result = await apiService.startLogin(email: email, state: state);
      _logger.d("result: $result");

      if (result.success) {
        // Navigate to next page
        _logger.d("Success");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Code sent to: $email')));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ConfirmPage()),
        );
      } else {
        // Show error message from API
        _logger.d('Error: ${result.errorMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.errorMessage ?? "Unknown Error")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextField(
          autofocus: true,
          controller: _emailController,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter Your E-Mail Address',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _logEmail, child: const Text('E-Mail Code')),
      ],
    );
  }
}

// void example() async {
//   final response = await startLogin('user@example.com', 'some_state_value');
//
//   if (response.statusCode == 200) {
//     print('Login started successfully');
//   } else {
//     print('Failed to start login: ${response.statusCode}');
//     print('Response body: ${response.body}');
//   }
// }

// Future<http.Response> startLogin(String email, String state) async {
//   final url = Uri.parse('https://intranet.cssnr.com/api/auth/start/');
//
//   final requestBody = StartLoginRequest(email: email, state: state).toJson();
//
//   final response = await http.post(
//     url,
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode(requestBody),
//   );
//
//   return response;
// }

String generateStateToken({int length = 32}) {
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final rand = Random.secure();
  return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
}
