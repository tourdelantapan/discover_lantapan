import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_loaders.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitializeScreen extends StatefulWidget {
  const InitializeScreen({Key? key}) : super(key: key);

  @override
  State<InitializeScreen> createState() => _InitializeScreenState();
}

class _InitializeScreenState extends State<InitializeScreen> {
  String initialize = "WAITING";

  initializeApp() {
    Future.delayed(const Duration(seconds: 1), () {
      Provider.of<UserProvider>(context, listen: false).profile(
          callback: (code, message) {
        if ([103, 500].contains(code)) {
          setState(() => initialize = "FAILED");
          return;
        }

        if ([200, 201].contains(code)) {
          if (BUILD_MODE == "ADMIN" && code == 200) {
            Navigator.pushNamedAndRemoveUntil(context, "/admin", (_) => false);
            return;
          }

          if (BUILD_MODE == "ADMIN") {
            Navigator.pushNamedAndRemoveUntil(
                context, "/auth/admin", (_) => false);
            return;
          }

          Navigator.pushNamedAndRemoveUntil(context, "/guest", (_) => false);
        } else {
          launchSnackbar(context: context, mode: "ERROR", message: message);
        }
      });
    });
  }

  @override
  void initState() {
    initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (initialize == "WAITING") {
      return Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
              image: const AssetImage('assets/images/logo.png'),
              height: MediaQuery.of(context).size.height * .30,
              width: MediaQuery.of(context).size.width *
                  (isMobile(context) ? .80 : .30)),
          const SizedBox(
            height: 15,
          ),
          IconText(
            mainAxisAlignment: MainAxisAlignment.center,
            label: "Tradisyon Hu Katatao",
            color: Colors.black,
            fontWeight: FontWeight.bold,
            size: 20,
          ),
          IconText(
            mainAxisAlignment: MainAxisAlignment.center,
            label: "A Tradition Of Excellence",
            color: Colors.black,
          ),
          const SizedBox(
            height: 100,
          ),
          showDoubleBounce(size: 30)
        ],
      ));
    }

    if (initialize == "FAILED") {
      return Scaffold(
          body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(child: Container()),
          const Icon(
            Icons.error_rounded,
            size: 30,
          ),
          const SizedBox(
            height: 10,
          ),
          IconText(
            mainAxisAlignment: MainAxisAlignment.center,
            label: "Failed to initialize app.",
            color: Colors.black,
            fontWeight: FontWeight.bold,
            size: 15,
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  backgroundColor: Colors.transparent,
                  borderColor: Colors.black,
                  textColor: Colors.black,
                  borderRadius: 100,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  icon: Icons.replay_outlined,
                  label: "Retry",
                  onPress: () {
                    setState(() => initialize = "WAITING");
                    initializeApp();
                  }),
            ],
          ),
          Expanded(child: Container()),
          IconText(
            mainAxisAlignment: MainAxisAlignment.center,
            label: "Discover Lantapan",
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom == 0.0
                ? 20
                : MediaQuery.of(context).padding.bottom,
          ),
        ]),
      ));
    }

    return Container();
  }
}
