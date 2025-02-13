import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/data/firebase_auth_repo.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_state.dart';
import 'package:socialx/features/auth/presentation/pages/auth_page.dart';
import 'package:socialx/features/home/presentation/pages/home_page.dart';
import 'package:socialx/features/post/data/firebase_post_repo.dart';
import 'package:socialx/features/post/presentation/cubits/post_cubit.dart';
import 'package:socialx/features/profile/data/firebase_profile_repo.dart';
import 'package:socialx/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:socialx/features/search/data/firebase_search_repo.dart';
import 'package:socialx/features/search/presentation/cubits/search_cubit.dart';
import 'package:socialx/features/storage/data/supabase_storage_repo.dart';
import 'package:socialx/themes/theme_cubit.dart';

class MyApp extends StatelessWidget {
  final authRepo = FirebaseAuthRepo();
  final profileRepo = FirebaseProfileRepo();
  final storageRepo = SupabaseStorageRepo();
  final postRepo = FirebasePostRepo();
  final searchRepo = FirebaseSearchRepo();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(authRepo: authRepo)..checkAuth()),
        BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
                profileRepo: profileRepo, storageRepo: storageRepo)),
        BlocProvider<PostCubit>(
            create: (context) =>
                PostCubit(postRepo: postRepo, storageRepo: storageRepo)),
        BlocProvider<SearchCubit>(
            create: (context) => SearchCubit(searchRepo: searchRepo)),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit())
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) {
          return MaterialApp(
              theme: currentTheme,
              debugShowCheckedModeBanner: false,
              home: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, authState) {
                  print(authState);
                  if (authState is UnAuthenticated) {
                    return AuthPage();
                  }
                  if (authState is Authenticated) {
                    return const HomePage();
                  } else {
                    return Scaffold(
                        body: Center(child: CircularProgressIndicator()));
                  }
                },
              ));
        },
      ),
    );
  }
}
