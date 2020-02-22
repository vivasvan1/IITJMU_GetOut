import 'package:flutter/material.dart';
import 'package:get_out/user_repo.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:get_out/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Outside extends StatefulWidget {
  GoogleSignInAccount user;
  Outside({Key key, this.user}) : super(key: key);

  @override
  _OutsideState createState() => _OutsideState();
}

class _OutsideState extends State<Outside> {
  static const String _loadingText = 'Loading...';
  DocumentSnapshot docSnapdocRef;

  @override
  Widget build(BuildContext context) {
    try {
      kuchbhi() async {
        docSnapdocRef = await Provider.of<MyUserState>(context, listen: false)
            .getuserdocRef();
      }

      kuchbhi();

      return Scaffold(
        appBar: AppBar(
          title: Text("IIT Jammu GetOut"),
        ),
        body: Container(
          child: Provider.of<MyUserState>(context, listen: false).waitingForDocs
              ? Center(child: CircularProgressIndicator())
              : StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(widget.user.email.substring(0, 11))
                      .collection("inout_register")
                      .document(docSnapdocRef.data["docRef"])
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.data.exists) {
                        if (snapshot.data.data.isNotEmpty) {
                          if (!snapshot.data.data.containsKey("in_datetime")) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  "Your Request is Approved. Scan below qr while returning.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                ),
                                QrImage(
                                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                    data: widget.user.email +
                                        "_" +
                                        snapshot.data.data["phone"] +
                                        "_" +
                                        snapshot.data.data["purpose"] +
                                        "_" +
                                        "1",
                                    foregroundColor:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    RaisedButton(
                                      child: Text("SIGN OUT"),
                                      onPressed: () =>
                                          Provider.of<UserRepository>(context,
                                                  listen: false)
                                              .signOut(),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            print("____________________________________");
                            print("request was accepted!");
                            print("____________________________________");
                            Provider.of<MyUserState>(context, listen: false)
                                .insideEntryApproved(
                                    docSnapdocRef.data);
                            return Text("");
                          }
                        } else {
                          return Text("");
                        }
                      } else {}
                    }
                  }),
        ),
      );
    } catch (e) {
      // print(e);
    }
  }
}
