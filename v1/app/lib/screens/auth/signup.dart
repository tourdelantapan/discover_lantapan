import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  Function goToLogIn;
  SignUp({Key? key, required this.goToLogIn}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool showPasswordA = false;
  bool showPasswordB = false;

  Map<String, dynamic> payload = {"fullName": "", "email": "", "password": ""};

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Form(
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
              if (userProvider.loading == "signup")
                const LinearProgressIndicator(),
              const SizedBox(height: 15),
              TextFormField(
                onChanged: (e) =>
                    setState(() => payload["fullName"] = e.trim()),
                validator: (val) {
                  if (val!.isEmpty) {
                    return "This field is required";
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Full Name",
                    prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 15),
              TextFormField(
                onChanged: (e) => setState(() => payload["email"] = e.trim()),
                validator: (val) {
                  if (val!.isEmpty) {
                    return "This field is required";
                  }
                  if (!EmailValidator.validate(val)) {
                    return "Email invalid";
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 15),
              TextFormField(
                  onChanged: (e) => setState(() => payload["password"] = e),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "This field is required";
                    }
                  },
                  obscureText: !showPasswordA,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.key_rounded),
                      suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => showPasswordA = !showPasswordA),
                          icon: Icon(
                            Icons.remove_red_eye_rounded,
                            color: !showPasswordA ? Colors.grey : Colors.red,
                          )))),
              const SizedBox(height: 15),
              TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "This field is required";
                    }
                    if (payload["password"] != val) {
                      return "Passwords don't match";
                    }
                  },
                  obscureText: !showPasswordB,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Confirm Password",
                      prefixIcon: const Icon(Icons.key_rounded),
                      suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => showPasswordB = !showPasswordB),
                          icon: Icon(
                            Icons.remove_red_eye_rounded,
                            color: !showPasswordB ? Colors.grey : Colors.red,
                          )))),
              const SizedBox(height: 15),
              Button(
                  label: "Log In",
                  onPress: () {
                    if (_formKey.currentState!.validate()) {
                      Provider.of<UserProvider>(context, listen: false).signup(
                          payload: payload,
                          callback: (code, message) {
                            if (code != 200) {
                              launchSnackbar(
                                  context: context,
                                  mode: "ERROR",
                                  message: message ?? "Error!");
                              return;
                            }
                            _formKey.currentState!.reset();
                            launchSnackbar(
                                context: context,
                                mode: "SUCCESS",
                                message: message ?? "Success!");
                            widget.goToLogIn();
                          });
                    }
                  },
                  padding: const EdgeInsets.symmetric(vertical: 15))
            ],
          ),
        ));
  }
}
