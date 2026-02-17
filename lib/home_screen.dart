import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/scheduling/presentation/scheduling_screen.dart';
import 'features/inventory/presentation/inventory_screen.dart';
import 'features/payments/presentation/payments_screen.dart';
import 'core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    SchedulingScreen(),
    InventoryScreen(),
    PaymentsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartLine),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.calendarAlt),
            label: 'Agendamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.boxes),
            label: 'Estoque',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.wallet),
            label: 'Pagamentos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.accentGold,
        unselectedItemColor: AppTheme.textSecondary,
        onTap: _onItemTapped,
        backgroundColor: AppTheme.background,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
