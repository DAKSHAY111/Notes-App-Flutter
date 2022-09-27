import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const imgUrl =
        "https://media-exp2.licdn.com/dms/image/C4E03AQEfkiLK-o9knw/profile-displayphoto-shrink_200_200/0/1616073626281?e=2147483647&v=beta&t=DYZizwN3OiL1VVJaNMcPp-pUu6q6aO2b87OpRxpSojY";
    return Drawer(
      backgroundColor: bgColor,
      child: ListView(
        children: [
          const DrawerHeader(
              curve: Curves.bounceOut,
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                // decoration: Decoration(),
                accountName: Text("Dakshay"),
                accountEmail: Text("dakshaysolanki@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(imgUrl),
                ),
              )),
          ListTile(
            leading: Icon(
              Icons.lightbulb_outline_rounded,
              color: Colors.white.withOpacity(0.7),
            ),
            title: Text(
              "Notes",
              textScaleFactor: 1.4,
              style: TextStyle(color: white.withOpacity(0.7)),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.archive_outlined,
              color: Colors.white.withOpacity(0.7),
            ),
            title: Text(
              "Achieve",
              textScaleFactor: 1.4,
              style: TextStyle(color: white.withOpacity(0.7)),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings_outlined,
              color: Colors.white.withOpacity(0.7),
            ),
            title: Text(
              "Settings",
              textScaleFactor: 1.4,
              style: TextStyle(color: white.withOpacity(0.7)),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: Colors.white.withOpacity(0.7),
            ),
            title: Text(
              "About Us",
              textScaleFactor: 1.4,
              style: TextStyle(color: white.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }
}
