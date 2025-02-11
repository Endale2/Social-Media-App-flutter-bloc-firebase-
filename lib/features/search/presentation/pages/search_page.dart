import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/profile/presentation/components/user_tile.dart';
import 'package:socialx/features/search/presentation/cubits/search_cubit.dart';
import 'package:socialx/features/search/presentation/cubits/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextField(
        controller: searchController,
        decoration: InputDecoration(
            hintText: "Search ...",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary)),
      )),

//for search result
      body: BlocBuilder<SearchCubit, SearchState>(builder: (context, state) {
        //loaded
        if (state is SearchLoaded) {
          if (state.users.isEmpty) {
            return Center(child: Text("No User Found"));
          }
          //users

          return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserTile(user: user!);
              });
        }
        //loading

        else if (state is SearchLoading) {
          return Center(child: CircularProgressIndicator());
        }

        //error
        else if (state is SearchError) {
          return Center(child: Text(state.message));
        }

        //default
        else {
          return Center(child: Text("Start searching ....."));
        }
      }),
    );
  }
}
