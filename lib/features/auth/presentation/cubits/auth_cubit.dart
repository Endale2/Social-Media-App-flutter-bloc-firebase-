import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/domain/entities/app_user.dart';
import 'package:socialx/features/auth/domain/repos/auth_repos.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentuser;
  AuthCubit({required this.authRepo}) : super(AuthInitial());

  //check if the user is already authenticated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();
    if (user != null) {
      _currentuser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
  }
}
