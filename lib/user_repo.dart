import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    _onAuthStateChanged(null);
  }

  Status get status => _status;
  GoogleSignInAccount get user => _googleUser;

  Future<bool> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      _googleSignIn.signIn().then((onValue) async {
        print(onValue);
        print("------------------------------------");
        _googleUser = onValue;
        if (_googleUser.email.substring(11, 26) == "@iitjammu.ac.in") {
          final GoogleSignInAuthentication googleAuth =
              await _googleUser.authentication;
          final AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          await _auth.signInWithCredential(credential);
          // Firebase.instance.

        } else {
          _googleSignIn.signOut();
          _status = Status.Unauthenticated;
          notifyListeners();
        }
      }).catchError((onError) {
        // print(onError);
        _googleSignIn.signOut();
          Fluttertoast.showToast(msg: "Please ensure you use Institute ID (example : 2016ucs0001@iitjammu.ac.in).");
        _status = Status.Unauthenticated;
        notifyListeners();
        // _googleSignIn.signOut();
      });
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      Fluttertoast.showToast(msg: "$e");
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

  void _onAuthStateChanged(GoogleSignInAccount account) {
    if (account == null) {
      // print("user variable is null.");
      _status = Status.Unauthenticated;
    } else {
      _googleUser = account;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
