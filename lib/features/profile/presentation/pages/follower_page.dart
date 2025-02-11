import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/profile/presentation/components/user_tile.dart';
import 'package:socialx/features/profile/presentation/cubits/profile_cubit.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerPage(
      {super.key, required this.followers, required this.following});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
                dividerColor: Colors.transparent,
                labelColor: Theme.of(context).colorScheme.inversePrimary,
                unselectedLabelColor: Theme.of(context).colorScheme.primary,
                tabs: [
                  Tab(child: Text("Followers")),
                  Tab(child: Text("Following"))
                ]),
          ),
          body: TabBarView(children: [
            _buildUserList(followers, "No Followers", context),
            _buildUserList(following, "No Following", context),
          ])),
    );
  }

  Widget _buildUserList(
      List<String> uids, String emptyMessage, BuildContext context) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              final uid = uids[index];
              return FutureBuilder(
                  future: context.read<ProfileCubit>().getUserProfile(uid),
                  builder: (context, snapshot) {
                    //loaded

                    if (snapshot.hasData) {
                      final user = snapshot.data!;
                      return UserTile(user: user);
                    }

                    //loading
                    else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ListTile(
                        title: Text("Loading...."),
                      );
                    }

                    //error or not found

                    else {
                      return ListTile(
                        title: Text("User Not Found"),
                      );
                    }
                  });
            });
  }
}
