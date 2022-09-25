import 'package:app/screens/auth/index.dart';
import 'package:app/screens/guest/index.dart';
import 'package:app/screens/guest/mapview.dart';
import 'package:app/screens/guest/place_info.dart';
import 'package:app/screens/guest/search_place.dart';
import 'package:app/screens/initialize.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const InitializeScreen());
      case '/guest':
        return MaterialPageRoute(builder: (_) => Guest());
      case '/place/info':
        return MaterialPageRoute(
            builder: (_) => PlaceInfo(arguments: args as Map<String, dynamic>));
      case '/search/place':
        return MaterialPageRoute(builder: (_) => SearchPlace());
      case '/mapview':
        return MaterialPageRoute(builder: (_) => MapView());
      case '/auth':
        return MaterialPageRoute(builder: (_) => Auth());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(appBar: AppBar(title: const Text('Welcome')));
    });
  }
}
