import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialx/features/home/presentation/components/my_drawer_tile.dart';
import 'package:socialx/features/profile/presentation/pages/profile_page.dart';
import 'package:socialx/features/search/presentation/pages/search_page.dart';
import 'package:socialx/features/settings/pages/setting_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Icon(Icons.person,
                      size: 80, color: Theme.of(context).colorScheme.primary),
                ),

                Divider(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                //home tile

                MyDrawerTile(
                    title: "Home",
                    icon: Icons.home,
                    onTap: () => Navigator.of(context).pop()),
                //profile
                MyDrawerTile(
                    title: "Profile",
                    icon: Icons.person_outlined,
                    onTap: () {
                      //pop page
                      Navigator.of(context).pop();
                      //get current user id
                      final user = context.read<AuthCubit>().currentUser;

                      String? uid = user!.uid;
                      //navigate to profile page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                    uid: uid,
                                  )));
                    }),

                //search
                MyDrawerTile(
                    title: "Search",
                    icon: Icons.search,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SearchPage()))),

                //settings
                MyDrawerTile(
                    title: "Settings",
                    icon: Icons.settings,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingPage()))),

                //Logout

                const Spacer(),

                MyDrawerTile(
                    title: "Logout",
                    icon: Icons.logout,
                    onTap: () {
                      context.read<AuthCubit>().logout();
                    })
              ],
            ),
          ),
        ));
  }
}
