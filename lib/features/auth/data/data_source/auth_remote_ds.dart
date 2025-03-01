import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:helpnest/features/auth/data/models/user_model.dart';
import 'package:helpnest/features/auth/domain/repo/auth_repo.dart';

class AuthRemoteDs implements AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<void> addUser({required UserModel user}) async {
    try {
      final userCollection = _firestore.collection('users');
      await userCollection.doc(user.id).set(user.toJson());
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        final userSnapshot =
            await _firestore.collection('users').doc(user.uid).get();
        if (!userSnapshot.exists) {
          final newUser = UserModel(
            id: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? "",
            phoneNumber: user.phoneNumber ?? '',
            location: UserLocationModel.fromJson({}),
            image: user.photoURL ?? '',
            gender: '',
            creationTD: Timestamp.now(),
            createdBy: user.uid,
            deactivate: false,
          );
          await addUser(user: newUser);
        }
      }
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }
}
