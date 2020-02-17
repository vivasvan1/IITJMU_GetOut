import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:get_out/utls/inout_entry.dart';
enum MyState { Outside, Inside, Approving }

class MyUserState extends ChangeNotifier {
  MyState _state = MyState.Inside;
  bool _isloading = false;
  InOutEntry inout_entry;
  GoogleSignInAccount user;
  MyUserState({this.user}) {
    // DocumentReference usrRef = Firestore.instance
    //     .collection('users')
    //     .document(user.id.substring(0, 11));

    // Firestore.instance.runTransaction((Transaction tx) async {
    //   DocumentSnapshot postSnapshot = await tx.get(usrRef);
    //   if (postSnapshot.exists) {
    //     print(postSnapshot.data);
    //     // Extend 'favorites' if the list does not contain the recipe ID:
    //     // if (!postSnapshot.data['status']) {
    //     //   await tx.update(favoritesReference, <String, dynamic>{
    //     //     'favorites': FieldValue.arrayUnion([recipeId])
    //     //   });
    //     // // Delete the recipe ID from 'favorites':
    //     // } else {
    //     //   await tx.update(favoritesReference, <String, dynamic>{
    //     //     'favorites': FieldValue.arrayRemove([recipeId])
    //     //   });
    //     // }
    //   } else {
    //     // Create a document for the current user in collection 'users'
    //     // and add a new array 'favorites' to the document:
    //     // await tx.set(favoritesReference, {
    //     //   'favorites': [recipeId]
    //     // });
    //   }
    // }).then((result) {
    //   return true;
    // }).catchError((error) {
    //   print('Error: $error');
    //   return false;
    // });
  }

  MyState get state => _state;
  bool get isloading => _isloading;

  Future<bool> doEntry({email, phone, purpose}) async {
    try {
      DateTime now = DateTime.now();
      _isloading = true;
      notifyListeners();
      DocumentReference docRef = Firestore.instance
          .collection('users')
          .document()
          .collection("inout_register")
          .document();
      Firestore.instance.runTransaction((Transaction tx) async {
        
        await tx.set(docRef, {
          'approved': false,
          'in_datetime': DateFormat('yyyy-MM-dd-HH:mm:ss').format(now),
          'out_datetime': DateFormat('yyyy-MM-dd-HH:mm:ss').format(now),
          'phone': phone,
          'purpose': purpose,
        });
      }).then((result) {
        _isloading = false;
        _state = MyState.Approving;
        inout_entry = InOutEntry.fromMap({
          'approved': false,
          'in_datetime': DateFormat('yyyy-MM-dd-HH:mm:ss').format(now),
          'out_datetime': DateFormat('yyyy-MM-dd-HH:mm:ss').format(now),
          'phone': phone,
          'purpose': purpose,
        },docRef);
        notifyListeners();
        // Provider.of<UserState>(context,listen: false);
        return true;
      }).catchError((error) {
        _isloading = false;
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
}
