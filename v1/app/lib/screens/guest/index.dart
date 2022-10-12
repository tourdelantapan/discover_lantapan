import 'package:app/models/user_model.dart';
import 'package:app/provider/location_provider.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/screens/guest/drawer_pages/about_lantapan.dart';
import 'package:app/screens/guest/drawer_pages/contacts.dart';
import 'package:app/screens/guest/drawer_pages/developers.dart';
import 'package:app/screens/guest/drawer_pages/history.dart';
import 'package:app/screens/guest/drawer_pages/home_feed.dart';
import 'package:app/screens/guest/drawer_pages/tourism_staff.dart';
import 'package:app/screens/guest/select_location.dart';
import 'package:app/utilities/reverse_geocode.dart';
import 'package:app/widgets/bottom_modal.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_loaders.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Guest extends StatefulWidget {
  Guest({Key? key}) : super(key: key);

  @override
  State<Guest> createState() => _GuestState();
}

class _GuestState extends State<Guest> {
  PageController page = PageController();
  int pageIndex = 0;
  bool detectingLocation = true;

  List<IconTextModel> drawerItems = [
    IconTextModel(Icons.home, "Home"),
    IconTextModel(Icons.history_edu_rounded, "History"),
    IconTextModel(Icons.people_alt_rounded, "Tourism Staff"),
    IconTextModel(Icons.info_outline_rounded, "About Lantapan"),
    IconTextModel(Icons.contact_mail_rounded, "Contacts"),
    IconTextModel(Icons.developer_mode_rounded, "Developers"),
    IconTextModel(Icons.qr_code_2_rounded, "Scan QR"),
  ];

  void setLocation() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Modal(
                title: "Long press to pin your location",
                heightInPercentage: .9,
                content: SelectLocation(
                    value: Provider.of<LocationProvider>(context, listen: false)
                        .coordinates,
                    willDetectLocation:
                        Provider.of<LocationProvider>(context, listen: false)
                            .address
                            .isEmpty,
                    onSelectLocation: (coordinates, address) {
                      Provider.of<LocationProvider>(context, listen: false)
                          .setCoordinates(coordinates, address);
                    }));
          });
        });
  }

  void determinePosition() {
    Provider.of<LocationProvider>(context, listen: false)
        .determinePosition(context, (res, isSuccess) async {
      if (isSuccess) {
        String address = await AddressRepository.reverseGeocode(
            coordinates: LatLng(res.latitude, res.longitude));
        if (!mounted) return;
        Provider.of<LocationProvider>(context, listen: false)
            .setCoordinates(LatLng(res.latitude, res.longitude), address);

        launchSnackbar(
            context: context,
            mode: "SUCCESS",
            duration: 7000,
            icon: Icons.pin_drop_rounded,
            message:
                "Location detected: $address. Virtually change location to your liking by pressing the pin button on the top bar.");
      }

      setState(() => detectingLocation = false);
    });
  }

  bool checkIfVerified(List<EmailVerification> emailVerification) {
    for (int i = 0; i < emailVerification.length; i++) {
      if (emailVerification[i].isConfirmed) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      if (!mounted) return;
      determinePosition();
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
          if (userProvider.currentUser != null &&
              userProvider.currentUser!.scope.contains("ADMIN"))
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/admin');
                },
                icon: const Icon(Icons.switch_account_rounded)),
          if (detectingLocation)
            showDoubleBounce(size: 20)
          else
            IconButton(
                onPressed: () {
                  setLocation();
                },
                icon: const Icon(Icons.pin_drop_rounded)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search/place');
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: page,
                children: [
                  HomeFeed(),
                  History(),
                  TourismStaff(),
                  AboutLantapan(),
                  Contacts(),
                  Developers()
                ]),
          ),
          if (userProvider.currentUser != null &&
              !checkIfVerified(userProvider.currentUser!.emailVerification))
            Container(
                color: Colors.red,
                padding: const EdgeInsets.all(15),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconText(
                          label: "Email not verified!",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        Button(
                          isLoading: userProvider.loading == "generate-otp",
                          label: "Verify Now",
                          onPress: () {
                            userProvider.generatePin(
                                query: {
                                  "email": userProvider.currentUser!.email,
                                  "recipient_name":
                                      userProvider.currentUser!.fullName
                                },
                                callback: (code, message) {
                                  if (code == 200) {
                                    Navigator.pushNamed(context, '/verify/otp');
                                    return;
                                  }

                                  launchSnackbar(
                                      context: context,
                                      mode: "ERROR",
                                      message: message);
                                });
                          },
                          backgroundColor: Colors.white,
                          borderColor: Colors.transparent,
                          textColor: Colors.black,
                          borderRadius: 100,
                        )
                      ]),
                ]))
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(children: [
          Expanded(
              child: ListView(padding: EdgeInsets.zero, children: [
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
                      if (index == 6) {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/scan/qr');
                        return;
                      }

                      setState(() => pageIndex = index);
                      page.jumpToPage(index);
                      Navigator.pop(context);
                    }))
          ])),
          Button(
              icon: userProvider.currentUser == null
                  ? Icons.person
                  : Icons.logout_rounded,
              label: userProvider.currentUser == null
                  ? "Log In/Sign Up"
                  : "Log Out",
              borderColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              textColor: Colors.black,
              mainAxisAlignment: MainAxisAlignment.start,
              onPress: () {
                Navigator.pop(context);
                if (userProvider.currentUser != null) {
                  userProvider.signOut();
                  return;
                }

                Navigator.pushNamed(context, '/auth');
                return;
              })
        ]),
      ),
    );
  }
}

class IconTextModel {
  IconTextModel(this.icon, this.text);
  final IconData icon;
  final String text;
}
