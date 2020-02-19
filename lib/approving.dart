import 'package:flutter/material.dart';
import 'package:get_out/user_repo.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:get_out/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Approving extends StatefulWidget {
  GoogleSignInAccount user;
  Approving({Key key, this.user}) : super(key: key);

  @override
  _ApprovingState createState() => _ApprovingState();
}

class _ApprovingState extends State<Approving> {
  static const String _loadingTextRussian = 'Loading...';
  @override
  Widget build(BuildContext context) {
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
              if (!snapshot.hasData)
                return const Center(
                    child: Text(
                  _loadingTextRussian,
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
                        data: snapshot.data.documents[0].reference.documentID
                                .toString() +
                            "_" +
                            widget.user.email),
                    RaisedButton(
                      child: Text("SIGN OUT"),
                      onPressed: () =>
                          Provider.of<UserRepository>(context, listen: false)
                              .signOut(),
                    ),
                  ]
                      // ListView(children: getExpenseItems(snapshot))
                      ));
            },
          ),
        ));
  }
}
