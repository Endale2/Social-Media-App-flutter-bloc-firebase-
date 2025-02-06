import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/data/firebase_auth_repo.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_state.dart';
import 'package:socialx/features/auth/presentation/pages/auth_page.dart';
import 'package:socialx/features/post/presentation/pages/home_page.dart';
import 'package:socialx/themes/light_mode.dart';

class MyApp extends StatelessWidget {
  final authRepo = FirebaseAuthRepo();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
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
