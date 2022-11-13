import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/utilities/shared_preferences.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  bool showPassword = false;
  Map<String, dynamic> payload = {"email": "", "password": ""};

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
                if (userProvider.loading == "login")
                  const LinearProgressIndicator(),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: payload["email"],
                  onChanged: (e) => setState(() => payload["email"] = e.trim()),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "This field is required";
                    }

                    if (!EmailValidator.validate(val)) {
                      return "Email Invalid.";
                    }
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email)),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: payload["password"],
                  onChanged: (e) => setState(() => payload["password"] = e),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "This field is required";
                    }
                  },
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.key_rounded),
                      suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => showPassword = !showPassword),
                          icon: Icon(
                            Icons.remove_red_eye_rounded,
                            color: !showPassword ? Colors.grey : Colors.red,
                          ))),
                ),
                const SizedBox(height: 15),
                Button(
                    label: "Log In",
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<UserProvider>(context, listen: false).login(
                            payload: payload,
                            callback: (code, message, scope) {
                              if (code != 200) {
                                launchSnackbar(
                                    context: context,
                                    mode: "ERROR",
                                    message: message ?? "Error!");
                                return;
                              }

                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/guest", (route) => false);
                              return;
                            });
                      }
                    },
                    padding: const EdgeInsets.symmetric(vertical: 15)),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/auth/password/reset'),
                    child:
                        IconText(color: Colors.red, label: "Forgot Password?"))
              ]),
        ));
  }
}
