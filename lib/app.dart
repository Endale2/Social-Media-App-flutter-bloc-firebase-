import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/data/firebase_auth_repo.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_state.dart';
import 'package:socialx/features/auth/presentation/pages/auth_page.dart';
import 'package:socialx/features/home/presentation/pages/home_page.dart';
import 'package:socialx/features/profile/data/firebase_profile_repo.dart';
import 'package:socialx/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:socialx/themes/light_mode.dart';

class MyApp extends StatelessWidget {
  final authRepo = FirebaseAuthRepo();
  final profileRepo = FirebaseProfileRepo();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(authRepo: authRepo)..checkAuth()),
        BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(profileRepo: profileRepo))
      ],
      child: MaterialApp(
          theme: lightMode,
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
          )),
    );
  }
}
