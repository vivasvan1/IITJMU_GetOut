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
import 'package:fluttertoast/fluttertoast.dart';

class Approving extends StatefulWidget {
  GoogleSignInAccount user;
  Approving({Key key, this.user}) : super(key: key);

  @override
  _ApprovingState createState() => _ApprovingState();
}

class _ApprovingState extends State<Approving> {
  static const String _loadingText = 'Loading...';
  DocumentSnapshot docSnapdocRef = null;

  @override
  void initState() {
    kuchbhi() async {
      docSnapdocRef = await Provider.of<MyUserState>(context, listen: false)
          .getuserdocRef();
    }

    kuchbhi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          title: Text("IIT Jammu GetOut"),
        ),
        body: Container(
          child: docSnapdocRef == null 
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
                          if (snapshot.data.data["approved"] == false) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  "Waiting for approval\nScan this at guard post",
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
                                        "0",
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
                                      child: Text("CANCEL"),
                                      onPressed: () => Provider.of<MyUserState>(
                                              context,
                                              listen: false)
                                          .doCancelEntry(),
                                    ),
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
                                .entryApproved();
                            return Text("");
                          }
                        } else {
                          return Text("");
                        }
                      } else {
                        // Request was rejected
                        print("____________________________________");
                        print("request was rejected!");
                        print("____________________________________");
                        Provider.of<MyUserState>(context, listen: false)
                            .entryRejected();
                        return Text("");
                      }
                    }
                  }),
        ),
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
      return Scaffold(
          appBar: AppBar(
            title: Text("IIT Jammu GetOut"),
          ),
          body: Text("$e"));
    }
  }
}
