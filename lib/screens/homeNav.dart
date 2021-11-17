import 'package:flutter/material.dart';
import './home_screen.dart';
import './home_pages/restaurants.dart';
import './home_pages/meals.dart';
import './home_pages/qr.dart';

class HomeNav extends StatelessWidget {
  const HomeNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Base navigator for all the pages inside the home tab
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        late WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            // home screen
            builder = (ctx) => HomeScreen();
            return MaterialPageRoute(builder: builder);

          case '/restaurant':
            builder = (ctx) => Restaurants();
            return MaterialPageRoute(builder: builder);
          case '/meals':
            builder = (ctx) => Meals();
            return MaterialPageRoute(builder: builder);
          case '/qr':
            builder = (ctx) => QrScanner();
            return MaterialPageRoute(builder: builder);

          default:
            return MaterialPageRoute(
              builder: (ctx) => Center(
                child: Text(
                    'No page registered in homeNav.dart\nwith route name ${settings.name}'),
              ),
            );
        }
      },
    );
  }
}
