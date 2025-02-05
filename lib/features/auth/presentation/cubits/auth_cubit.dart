import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/domain/entities/app_user.dart';
import 'package:socialx/features/auth/domain/repos/auth_repos.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentuser;
  AuthCubit({required this.authRepo}) : super(AuthInitial());

  //check if the user is already  authenticated.
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();
    if (user != null) {
      _currentuser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
  }

//get current user
  AppUser? get currentUser => _currentuser;
//login with email

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, password);
      if (user != null) {
        _currentuser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      final user =
          await authRepo.registerWithEmailPassword(name, email, password);
      if (user != null) {
        _currentuser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  Future<void> logout() async {
    authRepo.logout();
    emit(UnAuthenticated());
  }
}
