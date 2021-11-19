import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import './home_screen.dart';
// import './homeNav.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedPageIndex = 0;
  final List<Widget> _pages = [
    // home tab body
    // HomeNav(),
    HomeScreen(),
    Container(),
    Container(),
    Container(),
  ];

  void _selectPage(int index) => setState(() => _selectedPageIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context)
                .pop(); // closing app drawer as well before loggin out
            // Navigator.of(context)
            //     .pushReplacementNamed('/'); // to make sure we go to home page
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
            // so the logic there runs every time and no unexpected behaviour for logging out
            Provider.of<Auth>(context, listen: false).logout();
          },
          icon: Icon(Icons.exit_to_app),
          label: Text('SignOut'),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavyBar(
        showElevation: false,
        selectedIndex: _selectedPageIndex,
        onItemSelected: _selectPage,
        containerHeight: 70,
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.grey,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text('Favorites'),
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.grey,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.star_border_outlined),
            title: Text('Rate'),
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.grey,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}