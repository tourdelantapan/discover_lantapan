import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Password Reset"),
        backgroundColor: textColor2,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: customSize(width, {
          "400": 15,
          "800": 15,
          "1080": width * .30,
          "1400": width * .30,
          "1800": width * .30,
          "2400": width * .30
        })),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextFormField(
            onChanged: (e) => setState(() => email = e.trim()),
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Email",
                prefixIcon: Icon(Icons.email)),
          ),
          const SizedBox(height: 15),
          Button(
              label: "Request Reset",
              isLoading: userProvider.loading == "password-reset",
              onPress: () {
                if (email.isEmpty) {
                  launchSnackbar(
                      context: context,
                      mode: "ERROR",
                      message: "Please enter email.");
                  return;
                }

                if (!EmailValidator.validate(email)) {
                  launchSnackbar(
                      context: context,
                      mode: "ERROR",
                      message: "Email invalid.");
                  return;
                }

                Provider.of<UserProvider>(context, listen: false)
                    .requestPasswordReset(
                        query: {"email": email},
                        callback: (code, message) {
                          launchSnackbar(
                              context: context,
                              mode: code == 200 ? "SUCCESS" : "ERROR",
                              message: message ?? "Success!");
                          if (code == 200) {
                            Navigator.pop(context);
                          }
                        });
              },
              padding: const EdgeInsets.symmetric(vertical: 15)),
        ]),
      ),
    );
  }
}
