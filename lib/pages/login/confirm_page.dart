import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_service.dart';
import '../../home_app.dart';
import 'login_state.dart';

final _logger = Logger();
final session = LoginSession();

class ConfirmPage extends StatelessWidget {
  const ConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    _logger.d(
      'Session set: email=${session.email}, state=${session.stateToken}',
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmation Code')),
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
                      "Enter Code",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const MyCustomForm(),
                    const SizedBox(height: 16),
                    const Text("Check your E-Mail and Enter the Code."),
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
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _confirmCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      _logger.w("Code field is empty");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the code from the e-mail.')),
      );
    } else {
      _logger.d("code: $code");
      _logger.d("email: ${session.email}");
      _logger.d("stateToken: ${session.stateToken}");

      final apiService = ApiService();

      if (session.email == null || session.stateToken == null) {
        return;
      }

      final result = await apiService.processLogin(
        email: session.email!,
        state: session.stateToken!,
        code: code,
      );
      _logger.d("result: $result");
      if (result.success && result.user != null) {
        _logger.d("Success: $result");
        _logger.d("user: ${result.user}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Winner Winner Chicken Dinner')));
        // Navigator.popUntil(context, (route) => route.isFirst);

        final prefs = await SharedPreferences.getInstance();
        prefs.setString("email", session.email!);
        prefs.setString("authorization", result.user!.authorization);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavBarWrapper(selectedIndex: 2),
          ),
          (route) => false,
        );
      } else {
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
          controller: _codeController,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Code',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _confirmCode,
          child: const Text('Confirm Code'),
        ),
      ],
    );
  }
}
