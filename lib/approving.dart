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

class Approving extends StatefulWidget {
  GoogleSignInAccount user;
  Approving({Key key, this.user}) : super(key: key);

  @override
  _ApprovingState createState() => _ApprovingState();
}

class _ApprovingState extends State<Approving> {
  static const String _loadingText = 'Loading...';
  String myApproved;

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          title: Text("IIT Jammu GetOut"),
        ),
        body: Container(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(widget.user.email.substring(0, 11))
                .collection("inout_register")
                .where("approved", isEqualTo: false)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data.documents[0].data['approved']) {
                myApproved = "0";
              } else {
                myApproved = "1";
              }
              if (!snapshot.hasData)
                return const Center(
                    child: Text(
                  _loadingText,
                  style: TextStyle(fontSize: 25.0, color: Colors.grey),
                ));
              return Center(
                child: Column(
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
                            snapshot.data.documents[0].data["phone"] +
                            "_" +
                            snapshot.data.documents[0].data["purpose"] +
                            "_" +
                            myApproved,
                        foregroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: Text("CANCEL"),
                          onPressed: () =>
                              Provider.of<MyUserState>(context, listen: false)
                                  .doCancelEntry(),
                        ),
                        RaisedButton(
                          child: Text("SIGN OUT"),
                          onPressed: () => Provider.of<UserRepository>(context,
                                  listen: false)
                              .signOut(),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      print(e);
      
    }
  }
}
