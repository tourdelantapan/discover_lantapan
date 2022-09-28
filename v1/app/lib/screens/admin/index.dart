// ignore_for_file: must_be_immutable

import 'package:app/provider/user_provider.dart';
import 'package:app/screens/admin/dashboard.dart';
import 'package:app/screens/admin/manage_places.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  PageController page = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    UserProvider userProvider = context.watch<UserProvider>();

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text(
            "Lantapan Admin",
            style: TextStyle(color: Colors.black),
          ),
          actions: [],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SideMenu(
              controller: page,
              title: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.admin_panel_settings_rounded,
                            size: 30),
                        if (width > 600)
                          Text("${userProvider.currentUser?.fullName}",
                              style: const TextStyle(fontSize: 15)),
                      ])),
              style: SideMenuStyle(
                  displayMode: SideMenuDisplayMode.auto,
                  hoverColor: Colors.grey[100],
                  selectedTitleTextStyle:
                      const TextStyle(color: Colors.black87, fontSize: 15),
                  unselectedTitleTextStyle:
                      const TextStyle(color: Colors.black87, fontSize: 15),
                  selectedIconColor: Colors.black87,
                  backgroundColor: Colors.white),
              items: [
                SideMenuItem(
                  priority: 0,
                  title: 'Dashboard',
                  onTap: () {
                    setState(() => pageIndex = 0);
                    page.jumpToPage(0);
                  },
                  icon: const Icon(Icons.dashboard_rounded),
                ),
                SideMenuItem(
                  priority: 1,
                  title: 'Places',
                  onTap: () {
                    setState(() => pageIndex = 1);
                    page.jumpToPage(1);
                  },
                  icon: const Icon(Icons.place_rounded),
                ),
              ],
            ),
            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 247, 247, 247),
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: page,
                  children: [
                    AdminDashboard(),
                    ManagePlaces(
                      arguments: const {"mode": "admin"},
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
