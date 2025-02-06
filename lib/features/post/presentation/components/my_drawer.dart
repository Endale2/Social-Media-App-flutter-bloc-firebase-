import 'package:flutter/material.dart';
import 'package:socialx/features/post/presentation/components/my_drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Icon(Icons.person,
                  size: 80, color: Theme.of(context).colorScheme.primary),
              //home tile

              MyDrawerTile(title: "Home", icon: Icons.home, onTap: () {}),
              //profile
              MyDrawerTile(
                  title: "Profile",
                  icon: Icons.person_off_outlined,
                  onTap: () {}),

              //search
              MyDrawerTile(title: "Search", icon: Icons.search, onTap: () {}),

              //settings
              MyDrawerTile(
                  title: "Settings", icon: Icons.settings, onTap: () {}),

              //Logout

              MyDrawerTile(title: "Logout", icon: Icons.logout, onTap: () {})
            ],
          ),
        ));
  }
}
