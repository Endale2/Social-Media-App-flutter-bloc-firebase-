import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialx/features/auth/domain/entities/app_user.dart';
import 'package:socialx/features/auth/domain/repos/auth_repos.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      //create user
      AppUser user =
          AppUser(email: email, name: "", uid: userCredential.user!.uid);
      return user;
    } catch (e) {
      throw Exception("Login failed $e");
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      //create user
      AppUser user =
          AppUser(email: email, name: name, uid: userCredential.user!.uid);
      return user;
    } catch (e) {
      throw Exception("register failed $e");
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }

    return AppUser(email: firebaseUser.email!, name: "", uid: firebaseUser.uid);
  }
}
