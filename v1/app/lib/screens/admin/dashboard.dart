import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text("AdminDashboard"),
    );
  }
}
