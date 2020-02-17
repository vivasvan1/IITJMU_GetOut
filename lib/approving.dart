import 'package:flutter/material.dart';
import 'package:get_out/user_repo.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:get_out/user_state.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class Approving extends StatefulWidget {
  Approving({Key key}) : super(key: key);

  @override
  _ApprovingState createState() => _ApprovingState();
}

class _ApprovingState extends State<Approving> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IIT Jammu GetOut Aproving"),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: <Widget>[
      //       Column(
      //         children: <Widget>[
      //           Text(Provider.of<UserRepository>(context, listen: false)
      //               .user
      //               .email),
      //           Text("Please Scan below QrCode at the guard post for entry approval."),
      //           QrImage.withQr(qr: QrCode.fromData(data: "asdf", errorCorrectLevel: 2))
      //         ],
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: <Widget>[
      //           RaisedButton(
      //             child: Text("Your Inout Register"),
      //             onPressed: () => {},
      //           ),
      //           RaisedButton(
      //             child: Text("SIGN OUT"),
      //             onPressed: () =>
      //             {}
      //                 // Provider.of<UserRepository>(context, listen: false)
      //                 //     .signOut(),
      //           ),
      //         ],
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
