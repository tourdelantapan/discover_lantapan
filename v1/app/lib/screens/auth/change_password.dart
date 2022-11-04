import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _SignUpState();
}

class _SignUpState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  bool showPasswordA = false;
  bool showPasswordB = false;
  bool showPasswordC = false;

  Map<String, dynamic> payload = {
    "oldPassword": "",
    "newPassword": "",
    "confirmPassword": ""
  };

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text("Change Password"),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              padding: EdgeInsets.only(
                  top: height * .15,
                  bottom: 15,
                  right: isMobile(context) ? 0 : width * .3,
                  left: isMobile(context) ? 0 : width * .3),
              children: [
                TextFormField(
                    onChanged: (e) =>
                        setState(() => payload["oldPassword"] = e),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "This field is required";
                      }
                    },
                    obscureText: !showPasswordA,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Old Password",
                        prefixIcon: const Icon(Icons.key_rounded),
                        suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => showPasswordA = !showPasswordA),
                            icon: Icon(
                              Icons.remove_red_eye_rounded,
                              color: !showPasswordA ? Colors.grey : Colors.red,
                            )))),
                const SizedBox(height: 35),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(height: 15),
                TextFormField(
                    onChanged: (e) =>
                        setState(() => payload["newPassword"] = e),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "This field is required";
                      }
                    },
                    obscureText: !showPasswordB,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "New Password",
                        prefixIcon: const Icon(Icons.key_rounded),
                        suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => showPasswordB = !showPasswordB),
                            icon: Icon(
                              Icons.remove_red_eye_rounded,
                              color: !showPasswordB ? Colors.grey : Colors.red,
                            )))),
                const SizedBox(height: 15),
                TextFormField(
                    onChanged: (e) =>
                        setState(() => payload["confirmPassword"] = e),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "This field is required";
                      }
                      if (payload["newPassword"] != val) {
                        return "Passwords don't match";
                      }
                    },
                    obscureText: !showPasswordC,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Confirm Password",
                        prefixIcon: const Icon(Icons.key_rounded),
                        suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => showPasswordC = !showPasswordC),
                            icon: Icon(
                              Icons.remove_red_eye_rounded,
                              color: !showPasswordC ? Colors.grey : Colors.red,
                            )))),
                const SizedBox(height: 15),
                Button(
                    label: "Change Password",
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        //   Provider.of<UserProvider>(context, listen: false)
                        //       .signup(
                        //           payload: payload,
                        //           callback: (code, message) {
                        //             if (code != 200) {
                        //               launchSnackbar(
                        //                   context: context,
                        //                   mode: "ERROR",
                        //                   message: message ?? "Error!");
                        //               return;
                        //             }
                        //             _formKey.currentState!.reset();
                        //             launchSnackbar(
                        //                 context: context,
                        //                 mode: "SUCCESS",
                        //                 message: message ?? "Success!");
                        //           });
                      }
                    },
                    padding: const EdgeInsets.symmetric(vertical: 15))
              ],
            ),
          )),
    );
  }
}
