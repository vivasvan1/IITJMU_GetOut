import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository extends ChangeNotifier {
  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _googleUser;
  Status _status = Status.Uninitialized;

  UserRepository.instance()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn() {
    _googleSignIn.onCurrentUserChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  GoogleSignInAccount get user => _googleUser;

  Future<bool> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      _googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _googleSignIn.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(GoogleSignInAccount account) {
      if (account == null) {
      _status = Status.Unauthenticated;
    } else {
      _googleUser = account;
      _status = Status.Authenticated;
    }
    notifyListeners();  
}
}