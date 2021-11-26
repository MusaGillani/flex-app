import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart'; // as Auth;

import './home_screen.dart';
import './favorites_screen.dart';
import './rate_screen.dart';
import './profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen(this.isRes, {Key? key}) : super(key: key);
  final bool isRes;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedPageIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    if (widget.isRes)
      _pages = [
        /// home tab body
        HomeScreen(isRes: widget.isRes),

        /// rate tab body
        RateScreen(),

        /// profile tab
        ProfileScreen(widget.isRes),
      ];
    else
      _pages = [
        /// home tab body
        HomeScreen(isRes: widget.isRes),

        /// likes tab body
        FavoritesScreen(),

        /// profile tab
        ProfileScreen(widget.isRes),
      ];
  }

  void _selectPage(int index) => setState(() => _selectedPageIndex = index);

  @override
  Widget build(BuildContext context) {
    print(widget.isRes);
    return Scaffold(
      drawer: Drawer(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context)
                .pop(); // closing app drawer as well before loggin out
            // Navigator.of(context)
            //     .pushReplacementNamed('/'); // to make sure we go to home page
            // Navigator.of(context)
            //     .pushNamedAndRemoveUntil('/', (route) => false);
            // so the logic there runs every time and no unexpected behaviour for logging out
            // FirebaseAuth.instance.signOut();
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
          if (!widget.isRes)
            BottomNavyBarItem(
              icon: Icon(Icons.favorite_border),
              title: Text('Favorites'),
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: Colors.grey,
            ),
          if (widget.isRes)
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
