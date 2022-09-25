import 'package:app/models/user_modal.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/screens/guest/drawer_pages/about_lantapan.dart';
import 'package:app/screens/guest/drawer_pages/contacts.dart';
import 'package:app/screens/guest/drawer_pages/developers.dart';
import 'package:app/screens/guest/drawer_pages/home_feed.dart';
import 'package:app/screens/guest/drawer_pages/tourism_staff.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Guest extends StatefulWidget {
  Guest({Key? key}) : super(key: key);

  @override
  State<Guest> createState() => _GuestState();
}

class _GuestState extends State<Guest> {
  PageController page = PageController();
  int pageIndex = 0;

  List<IconTextModel> drawerItems = [
    IconTextModel(Icons.home, "Home"),
    IconTextModel(Icons.people_alt_rounded, "Tourism Staff"),
    IconTextModel(Icons.info_outline_rounded, "About Lantapan"),
    IconTextModel(Icons.contact_mail_rounded, "Contacts"),
    IconTextModel(Icons.developer_mode_rounded, "Developers"),
  ];

  @override
  void initState() {
    () {
      Future.delayed(Duration.zero);
      if (Provider.of<UserProvider>(context, listen: false).currentUser ==
          null) {
        drawerItems.add(IconTextModel(Icons.person, "Log In/Sign Up"));
      } else {
        drawerItems.add(IconTextModel(Icons.logout_rounded, "Log Out"));
      }
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: .5,
        title: const Text("Discover Lantapan"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search/place');
              },
              icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: page,
        children: [
          HomeFeed(),
          TourismStaff(),
          AboutLantapan(),
          Contacts(),
          Developers()
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Column(children: [
                  IconText(
                    mainAxisAlignment: MainAxisAlignment.start,
                    label: "Tour De Lantapan",
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    size: 17,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 15,
                  ),
                  IconText(
                    mainAxisAlignment: MainAxisAlignment.start,
                    label: "Welcome,",
                    icon: Icons.favorite,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    size: 17,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  IconText(
                    mainAxisAlignment: MainAxisAlignment.start,
                    label: userProvider.currentUser?.fullName ?? "Guest",
                    color: Colors.black,
                    size: 17,
                  ),
                ])),
            ListView.builder(
                shrinkWrap: true,
                itemCount: drawerItems.length,
                itemBuilder: (context, index) => Button(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    mainAxisAlignment: MainAxisAlignment.start,
                    backgroundColor: pageIndex == index
                        ? Colors.grey[200]
                        : Colors.transparent,
                    borderColor: Colors.transparent,
                    textColor:
                        pageIndex == index ? Colors.black : Colors.grey[700],
                    fontSize: 17,
                    icon: drawerItems[index].icon,
                    label: drawerItems[index].text,
                    onPress: () {
                      if (userProvider.currentUser != null && index == 5) {
                        userProvider.signOut();
                        Navigator.pop(context);
                        return;
                      }

                      if (index == 5) {
                        Navigator.pushNamed(context, '/auth');
                        return;
                      }

                      setState(() => pageIndex = index);
                      page.jumpToPage(index);
                      Navigator.pop(context);
                    }))
          ],
        ),
      ),
    );
  }
}

class IconTextModel {
  IconTextModel(this.icon, this.text);
  final IconData icon;
  final String text;
}
