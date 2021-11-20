import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart'; //as Auth;

import './screens/wrapper.dart';
import './screens/authenticate_screen.dart';
import './screens/dashboard_screen.dart';

import './screens/home_pages/restaurants.dart';
import './screens/home_pages/meals.dart';
import './screens/home_pages/qr.dart';

import './utitlities/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Auth>(
      create: (ctx) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flex',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          canvasColor: Colors.white,
          unselectedWidgetColor: Colors.grey.shade300,
        ),
        home: Wrapper(),
        routes: {
          '/login': (ctx) => AuthenticateScreen(AuthMode.Login),
          '/signup': (ctx) => AuthenticateScreen(AuthMode.Signup),
          '/dashboard': (ctx) => DashboardScreen(),
        },
        onGenerateRoute: (RouteSettings settings) {
          late WidgetBuilder builder;
          switch (settings.name) {
            // case '/':
            //   builder = (BuildContext context) => SplashScreen();
            //   return MaterialPageRoute(builder: builder, settings: settings);

            // case '/login':
            //   builder = (BuildContext context) => LoginScreen();
            //   return MaterialPageRoute(builder: builder, settings: settings);

            // case '/dashboard':
            //   builder = (BuildContext context) => DashboardScreen();
            //   return MaterialPageRoute(builder: builder, settings: settings);

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
                      'No page registered in main.dart\nwith route name ${settings.name}'),
                ),
              );
          }
        },
      ),
    );
  }
}

      // StreamBuilder(
      //   stream: Auth.user,
      //   builder: (ctx, authSnapshot) {
      //     // DashboardScreen() : SplashScreen();
      //     if (authSnapshot.hasData) return DashboardScreen();

      //     return SplashScreen();
      //   },
      // )