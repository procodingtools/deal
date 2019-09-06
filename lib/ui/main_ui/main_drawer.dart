import 'package:deal/entities/category.dart';
import 'package:deal/ui/about_ui/about_state.dart';
import 'package:deal/ui/auth_ui/auth_state.dart';
import 'package:deal/ui/categories_ui/categories_state.dart';
import 'package:deal/ui/chat_ui/chat_list/chat_list_state.dart';
import 'package:deal/ui/dialogs/auth/auth_dialog.dart';
import 'package:deal/ui/main_ui/main_state.dart';
import 'package:deal/ui/post_ui/post_state.dart';
import 'package:deal/ui/profile_ui/profile_state.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatelessWidget {
  final Function(CategoryEntity category, CategoryEntity subCat)
  catgoryCallback;

  const MainDrawer({Key key, this.catgoryCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 4.0,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: InkWell(
              onTap: (){
                Navigator.pop(context);

                if (AppData.User == null) {
                  showDialog(context: context,
                      builder: (context) =>
                          AuthDialog(loginStatus: (status) => print(status),));
                } else
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen()));
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.0)),
                      padding: EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(500.0),
                        child: TransitionToImage(
                          width: 60.0,
                          image: AdvancedNetworkImage( AppData.User?.thumb??"lnlk",
                              useDiskCache: true,
                              cacheRule: CacheRule(maxAge: Duration(days: 10))),
                          loadingWidget: Image.asset(
                            "assets/icon_profile_default.png",
                            width: 60.0,
                          ),
                          placeholder: Image.asset(
                            "assets/icon_profile_default.png",
                            width: 60.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Hello ${AppData.User?.name ?? "Geust"}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: "SF",
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(color: Values.primaryColor),
          ),
          ListTile(
            title: Text("My Profile"),
            leading: Icon(
              Icons.person,
              size: 25.0,
              color: Values.iconsColor,
            ),
            onTap: () {
              Navigator.pop(context);
              if (AppData.User == null) {
                showDialog(context: context,
                    builder: (context) =>
                        AuthDialog(loginStatus: (status) => print(status),));
              } else
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
            onTap: () => Navigator.pop(context),
            title: Text("Browse"),
            leading: Icon(FontAwesomeIcons.thLarge,
                size: 25.0, color: Values.iconsColor),
          ),
          ListTile(
            title: Text("Post"),
            onTap: () {
              Navigator.pop(context);
              if (AppData.User == null) {
                showDialog(context: context,
                    builder: (context) =>
                        AuthDialog(loginStatus: (status) => print(status),));
              } else
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PostScreen()));
            },
            leading: Image.asset("assets/icon_post.png", width: 25.0),
          ),
          ListTile(
            title: Text("Chat"),
            leading: Image.asset("assets/icon_chat.png", width: 25.0),
            onTap: () {
              Navigator.pop(context);
              if (AppData.User == null) {
                showDialog(context: context,
                    builder: (context) =>
                        AuthDialog(loginStatus: (status) => print(status),));
              } else
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatListScreen()));
            },
          ),
          ListTile(
              title: Text("Categories"),
              leading:
              Icon(Icons.view_list, size: 25.0, color: Values.iconsColor),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CategoriesScreen(
                              catgoryCallback: catgoryCallback,
                            )));
              }),
          ListTile(
              title: Text("About"),
              leading: Icon(Icons.info, size: 25.0, color: Values.iconsColor),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutScreen()));
              }),
          ListTile(
            title: Text(AppData.User == null ? "Login" : "Logout"),
            leading: Image.asset(
              AppData.User == null
                  ? "assets/ic_login.png"
                  : "assets/icon_log_out.png",
              width: 25.0,
            ),
            onTap: () async {
              if (AppData.User != null) {
                AppData.User = null;
                AppData.Token = null;
                await SharedPreferences.getInstance()..remove("user");
              }
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AuthScreen(route: MainScreen(),)));
            },
          ),
        ],
      ),
    );
  }
}
