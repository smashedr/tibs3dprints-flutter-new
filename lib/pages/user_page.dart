import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tibs3dprints/pages/vote_page.dart';

final _logger = Logger();

class UserPage extends StatefulWidget {
  final void Function(Widget?) onSubPageChange;

  const UserPage({super.key, required this.onSubPageChange});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    // Replace 'your_preference_key' with the actual key you want to read
    final value = prefs.getString('email');
    _logger.i('email: $value');

    setState(() {
      _email = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var heading = (_email != null) ? "Welcome" : "No User is Good User";

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            heading,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          if (_email != null) ...[
            Text(
              'Account: $_email',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onSubPageChange(
                VotePage(onBack: () => widget.onSubPageChange(null)),
              );
            },
            child: Text('Vote'),
          ),
        ],
      ),
    );
  }
}
