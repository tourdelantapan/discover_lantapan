import 'package:app/models/user_model.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/debouncer.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/search_bar.dart';
import 'package:app/widgets/shimmer/box_shimmer.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  int pageSize = 20;
  int page = 0;
  bool isEndReached = false;
  String searchKey = "";
  final _debouncer = Debouncer(milliseconds: 1000);
  Map<String, String> query = {};
  late ScrollController controller;

  initFetch({required String fetchMode, required page}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<UserProvider>(context, listen: false).getUsers(
          fetchMode: fetchMode,
          query: {
            "pageSize": pageSize.toString(),
            "page": page.toString(),
            ...query
          },
          callback: (code, message, isEndReached) {
            if (code != 200) {
              launchSnackbar(context: context, mode: "ERROR", message: message);
              return;
            }
            this.isEndReached = isEndReached;
          });
    });
  }

  void _scrollListener() {
    if (controller.position.extentAfter == 0 &&
        !isEndReached &&
        !Provider.of<UserProvider>(context, listen: false)
            .loading
            .contains("users_more")) {
      page += 1;
      initFetch(fetchMode: "users_more", page: page);
    }
  }

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    initFetch(fetchMode: "users_pull", page: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    var width = MediaQuery.of(context).size.width;

    return Column(children: [
      SearchBar(
          searchKey: searchKey,
          onChanged: (val) {
            _debouncer.run(() {
              setState(() {
                searchKey = val;
                query = {...query, "searchKey": val};
              });
              initFetch(fetchMode: "users_pull", page: 0);
            });
          }),
      if (userProvider.loading == "users_pull")
        Expanded(
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.red,
              strokeWidth: 2,
            ),
          ),
        )
      else if (userProvider.userList.isEmpty)
        Expanded(
          child: Center(
            child: IconText(
              icon: Icons.list_alt,
              mainAxisAlignment: MainAxisAlignment.center,
              label: "List Empty",
              color: Colors.grey,
            ),
          ),
        )
      else
        Expanded(
            child: RefreshIndicator(
          onRefresh: () {
            setState(() {
              page = 0;
              isEndReached = false;
            });
            return initFetch(fetchMode: "users_pull", page: 0);
          },
          child: ListView.builder(
              controller: controller,
              padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: userProvider.userList.length,
              itemBuilder: (context, index) {
                if (userProvider.userList.length == index + 1 &&
                    !isEndReached &&
                    userProvider.loading == "users_more") {
                  return BoxShimmer();
                }

                User user = userProvider.userList[index];

                return Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.withOpacity(.2)))),
                    child: Row(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            user.photo?.small ?? placeholderImage,
                            fit: BoxFit.cover,
                            height: 40,
                            width: 40,
                          )),
                      const SizedBox(width: 10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.fullName),
                            IconText(
                              label: user.scope.join(", ").toLowerCase(),
                              color: Colors.grey,
                              size: 11,
                            )
                          ]),
                      Expanded(child: Container()),
                      Material(
                        child: PopupMenuButton(
                          child: userProvider.loading == "delete_user_$index"
                              ? CircularProgressIndicator(
                                  strokeWidth: 1,
                                  color: Colors.red,
                                )
                              : IconText(
                                  label: "Delete User",
                                  icon: Icons.person_remove_rounded,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                          onSelected: (value) {
                            if (value == "YES") {
                              userProvider.deleteUser(
                                  index: index,
                                  userId: user.id,
                                  callback: (code, message) {
                                    launchSnackbar(
                                        context: context,
                                        mode: code == 200 ? "SUCCESS" : "ERROR",
                                        message: message);
                                  });
                            }
                          },
                          itemBuilder: (BuildContext bc) {
                            return [
                              PopupMenuItem(
                                value: 'NO',
                                child: IconText(
                                  label: "Cancel",
                                  icon: Icons.close,
                                  color: Colors.black,
                                ),
                              ),
                              PopupMenuItem(
                                value: 'YES',
                                child: IconText(
                                  color: Colors.red,
                                  label: "Confirm Delete",
                                  icon: Icons.remove_circle,
                                ),
                              ),
                            ];
                          },
                        ),
                      ),
                    ]));
              }),
        ))
    ]);
  }
}
