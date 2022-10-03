import 'package:app/screens/admin/add_place.dart';
import 'package:app/screens/admin/index.dart';
import 'package:app/screens/auth/index.dart';
import 'package:app/screens/guest/add_review.dart';
import 'package:app/screens/guest/index.dart';
import 'package:app/screens/guest/mapview.dart';
import 'package:app/screens/guest/place_info.dart';
import 'package:app/screens/guest/review_list.dart';
import 'package:app/screens/guest/scan_qr.dart';
import 'package:app/screens/guest/search_place.dart';
import 'package:app/screens/guest/visitor_form.dart';
import 'package:app/screens/initialize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(builder: (_) => const InitializeScreen());
      case '/guest':
        return CupertinoPageRoute(builder: (_) => Guest());
      case '/admin':
        return CupertinoPageRoute(builder: (_) => Admin());
      case '/place/info':
        return CupertinoPageRoute(
            builder: (_) => PlaceInfo(arguments: args as Map<String, dynamic>));
      case '/search/place':
        return CupertinoPageRoute(builder: (_) => SearchPlace());
      case '/mapview':
        return CupertinoPageRoute(builder: (_) => MapView());
      case '/auth':
        return CupertinoPageRoute(builder: (_) => Auth());
      case '/place/add':
        return CupertinoPageRoute(
            builder: (_) => AddPlace(arguments: args as Map<String, dynamic>));
      case '/review/add':
        return CupertinoPageRoute(builder: (_) => AddReview());
      case '/review/list':
        return CupertinoPageRoute(builder: (_) => ReviewList());
      case '/scan/qr':
        return CupertinoPageRoute(builder: (_) => QRScanner());
      case '/visitor/form':
        return CupertinoPageRoute(builder: (_) => VisitorForm());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (context) {
      return Scaffold(appBar: AppBar(title: const Text('Welcome')));
    });
  }
}
