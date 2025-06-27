import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import this

final _logger = Logger();

class SettingsPage extends StatefulWidget {
  final void Function(Widget?) onSubPageChange;

  const SettingsPage({super.key, required this.onSubPageChange});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = false;
  static const String _notificationsKey = 'notifications_enabled'; // Key for SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Load settings when the page initializes
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifications = prefs.getBool(_notificationsKey) ?? false; // Get value or default to false
    });
    _logger.i('Notifications loaded: $_notifications');
  }

  Future<void> _saveNotificationsSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
    _logger.i('Notifications saved: $value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('App'),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Notifications'),
                leading: const Icon(Icons.notifications),
                // Use the state variable directly for initialValue
                initialValue: _notifications,
                onToggle: (bool value) {
                  setState(() {
                    _notifications = value; // Update UI state
                  });
                  _saveNotificationsSetting(value); // Save to persistent storage
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
