import 'package:helpnest/features/auth/data/models/user_model.dart';

abstract class AuthRepo {
  Future<void> addUser({required UserModel user});
  Future<void> signInWithGoogle();
}
