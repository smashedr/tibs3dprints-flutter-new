import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:tibs3dprints/pages/login/login_page.dart';

import '../pages/home_page.dart';
import '../pages/news_page.dart';
import '../pages/settings_page.dart';
import '../pages/user_page.dart';

final _logger = Logger();

class BottomNavBar extends StatefulWidget {
  final int initialSelectedIndex;

  const BottomNavBar({super.key, this.initialSelectedIndex = 0});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIndex;
  Widget? _subPage;

  final List<Widget Function(void Function(Widget?))> _widgetBuilders = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
    _widgetBuilders.addAll([
          (onSubPageChange) => const HomePage(),
          (onSubPageChange) => NewsPage(onSubPageChange: onSubPageChange),
          (onSubPageChange) => UserPage(onSubPageChange: onSubPageChange),
          (onSubPageChange) => SettingsPage(onSubPageChange: onSubPageChange),
    ]);
  }

  void _setSubPage(Widget? page) {
    setState(() {
      _subPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tibs3DPrints'),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.tiktok),
            onPressed: () async {
              final selectedTabIndex = await Navigator.push<int>(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
              if (selectedTabIndex != null) {
                setState(() {
                  _selectedIndex = selectedTabIndex;
                  _subPage = null;
                });
              }
            },
          ),
        ],
      ),
      body: _subPage ?? _widgetBuilders[_selectedIndex](_setSubPage),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
            _subPage = null;
          });
        },
        indicatorColor: const Color(0xFF01AAC1),
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.rss_feed),
            icon: Badge(child: Icon(Icons.rss_feed_outlined)),
            label: 'News',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: 'User',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Wrapper widget to allow setting initial selected tab when resetting navigation stack
class BottomNavBarWrapper extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBarWrapper({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavBar(initialSelectedIndex: selectedIndex);
  }
}
