import 'dart:io';

import 'package:app/models/user_model.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  bool showPasswordA = false;
  bool showPasswordB = false;
  CroppedFile? croppedImage;
  Map<String, dynamic> payload = {"_id": "", "fullName": "", "email": ""};

  @override
  void initState() {
    payload =
        Provider.of<UserProvider>(context, listen: false).currentUser!.toJson();
    payload.removeWhere((key, value) => [
          "password",
          "photo",
          "emailVerification",
          "scope",
          "createdAt",
          "updatedAt"
        ].contains(key));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text("Edit Profile"),
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
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: croppedImage == null
                          ? Image.network(
                              userProvider.currentUser?.photo?.small ??
                                  placeholderImage,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(croppedImage!.path),
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )),
                ),
                TextButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      CroppedFile? croppedImage =
                          await ImageCropper.platform.cropImage(
                        sourcePath: image!.path,
                      );
                      setState(() {
                        this.croppedImage = croppedImage;
                      });
                    },
                    child: IconText(
                      label: "Change Photo",
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      mainAxisAlignment: MainAxisAlignment.center,
                      icon: Icons.photo_size_select_actual_rounded,
                    )),
                if (userProvider.loading == "signup")
                  const LinearProgressIndicator(),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: userProvider.currentUser!.fullName,
                  onChanged: (e) =>
                      setState(() => payload["fullName"] = e.trim()),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "This field is required";
                    }
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Full Name"),
                      prefixIcon: Icon(Icons.person)),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: userProvider.currentUser!.email,
                  onChanged: (e) => setState(() => payload["email"] = e.trim()),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "This field is required";
                    }
                    if (!EmailValidator.validate(val)) {
                      return "Email invalid";
                    }
                  },
                  readOnly: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Email (Not changeable)"),
                      prefixIcon: Icon(Icons.email)),
                ),
                const SizedBox(height: 15),
                Button(
                    isLoading: userProvider.loading == "profile-edit",
                    label: "Save Changes",
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<UserProvider>(context, listen: false)
                            .editProfile(
                                payload: payload,
                                photo: croppedImage == null
                                    ? null
                                    : File(croppedImage!.path),
                                callback: (code, message) {
                                  launchSnackbar(
                                      context: context,
                                      mode: code == 200 ? "SUCCESS" : "ERROR",
                                      message: message);

                                  if (code == 200) {
                                    Navigator.pop(context);
                                    return;
                                  }
                                });
                      }
                    },
                    padding: const EdgeInsets.symmetric(vertical: 15)),
                const SizedBox(height: 15),
                const Divider(),
                TextButton(
                    onPressed: () async {
                      Navigator.pushNamed(
                          context, '/user/profile/change-password');
                    },
                    child: IconText(
                      label: "Change Password",
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      icon: Icons.key_rounded,
                    )),
              ],
            ),
          )),
    );
  }
}