import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:get_out/utls/inout_entry.dart';

enum MyState { Outside, Inside, Approving, Loading }

class MyUserState extends ChangeNotifier {
  MyState _state = MyState.Loading;
  // bool _isloading = false;
  InOutEntry inout_entry;
  GoogleSignInAccount user;
  bool waitingForDocs = true;

  getuserdocRef() async {
    DocumentSnapshot docSnapdocRef;
    docSnapdocRef = await Firestore.instance
        .collection("users")
        .document(user.email.substring(0, 11))
        .get();
    // print("docSnapdocRef");
    // print(docSnapdocRef.data);
    waitingForDocs = false;
    notifyListeners();
    return docSnapdocRef;
  }

  setinitState() async {
    await Firestore.instance
        .collection('users')
        .document(user.email.substring(0, 11))
        .get()
        .then((result) {
      print(result.data['state'] == "1");
      if (result.data['state'] == "0") {
        _state = MyState.Inside;
        notifyListeners();
      } else if (result.data['state'] == '1') {
        _state = MyState.Approving;
        notifyListeners();
      } else if (result.data['state'] == '2') {
        _state = MyState.Outside;
        notifyListeners();
      }
    }).catchError((error) {
      _state = MyState.Approving;
      print("$error");
      Fluttertoast.showToast(msg: 'Error: $error');
      return false;
    });
  }

  MyUserState({this.user}) {
    setinitState();
  }

  MyState get state => _state;
  InOutEntry get inoutentry => inout_entry;
  // bool get isloading => _isloading;

  entryApproved() {
    _state = MyState.Outside;
    waitingForDocs = true;
    notifyListeners();
  }

  entryRejected() {
    _state = MyState.Inside;
    waitingForDocs = true;
    notifyListeners();
  }

  insideEntryRejected() {}

  insideEntryApproved(Map<String,dynamic> ref) {
    try {
      DateTime now = DateTime.now();
      DocumentReference docRef = Firestore.instance
          .collection('users')
          .document(user.email.substring(0, 11))
          .collection("inout_register")
          .document(ref['docRef']);
      DocumentReference stateRef = Firestore.instance
          .collection('users')
          .document(user.email.substring(0, 11));
      Firestore.instance.runTransaction((Transaction tx) async {
        await tx.set(stateRef, {"state": "0", "imgURL": ref["imgURL"]});
        await tx.update(docRef, {
          'in_datetime': DateFormat('yyyy-MM-dd-HH:mm:ss').format(now),
        });
      }).then((result) {
        // _isloading = false;
        // print("adkjfnasfnkjasdnfkjsadnf_________________________----------------------asdfjnlasjdfnkasdfnjk");
        _state = MyState.Inside;
        notifyListeners();
        //   // Provider.of<UserState>(context,listen: false);
        //   return true;
      }).catchError((error) {
        // _state = MyState.Inside;
        // _isloading = false;
        // notifyListeners();
        print("$error");
        Fluttertoast.showToast(msg: 'Error: $error');
        return false;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> doEntry({email, phone, purpose}) async {
    try {
      // DateTime now = DateTime.now();
      // _isloading = true;
      // notifyListeners();
      DocumentReference docRef = Firestore.instance
          .collection('users')
          .document(user.email.substring(0, 11))
          .collection("inout_register")
          .document();
      DocumentReference stateRef = Firestore.instance
          .collection('users')
          .document(user.email.substring(0, 11));
      Firestore.instance.runTransaction((Transaction tx) async {
        await tx.update(stateRef, {"state": "1", "docRef": docRef.documentID});
        await tx.set(docRef, {
          'approved': false,
          // 'in_datetime': DateFormat('yyyy-MM-dd-HH:mm:ss').format(now),
          // 'out_datetime': DateFormat('yyyy-MM-dd-HH:mm:ss').format(now),
          'phone': phone,
          'purpose': purpose,
        });
      }).then((result) {
        // _isloading = false;
        _state = MyState.Approving;
        inout_entry = InOutEntry.fromMap({
          'approved': false,
          'phone': phone,
          'purpose': purpose,
        }, docRef);
        notifyListeners();
        //   // Provider.of<UserState>(context,listen: false);
        //   return true;
      }).catchError((error) {
        _state = MyState.Inside;
        // _isloading = false;
        notifyListeners();
        print("$error");
        Fluttertoast.showToast(msg: 'Error: $error');
        return false;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  doCancelEntry() async {
    DocumentSnapshot docsnap = await Firestore.instance
        .collection('users')
        .document(user.email.substring(0, 11))
        .get();
    DocumentReference canceling = Firestore.instance
        .collection("users")
        .document(user.email.substring(0, 11))
        .collection("inout_register")
        .document(docsnap.data['docRef']);
    DocumentReference docRefdocRef = Firestore.instance
        .collection("users")
        .document(user.email.substring(0, 11));
    DocumentSnapshot docSnapdocRef = await Firestore.instance
        .collection("users")
        .document(user.email.substring(0, 11))
        .get();
    Map x = docSnapdocRef.data;
    x.remove("docRef");

    // docSnapdocRef.data.remove("docRef");
    x["state"] = "0";
    // print(x);
    Firestore.instance.runTransaction((Transaction tx) async {
      await tx.delete(canceling);
      await tx.set(docRefdocRef, x);
    }).then((result) {
      // _isloading = false;
      _state = MyState.Inside;
      notifyListeners();
    }).catchError((error) {
      // _state = MyState.Inside;
      // _isloading = false;
      // notifyListeners();
      print("$error");
      Fluttertoast.showToast(msg: 'Error: $error');
      return false;
    });
    // _state = MyState.Inside;
    // notifyListeners();
  }
}
