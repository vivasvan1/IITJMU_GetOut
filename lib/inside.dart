import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_out/user_repo.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:get_out/user_state.dart';
import 'package:intl/intl.dart';

class Inside extends StatefulWidget {
  final GoogleSignInAccount user;
  Inside({Key key, this.user}) : super(key: key);

  @override
  _InsideState createState() => _InsideState();
}

class _InsideState extends State<Inside> {
  getEntryItems(snapshot) {
    List<DocumentSnapshot> x = snapshot.data.documents;
    x.removeWhere((item) => item.documentID == "null");
    // print(x.data);
    if (x.length != 0) {
      return x
          .map((doc) => ExpansionTile(
                title: Text(doc.data["out_datetime"].substring(8, 11) +
                    doc.data["out_datetime"].substring(5, 7) +
                    "-" +
                    doc.data["out_datetime"].substring(0, 4) +
                    " | " +
                    doc.data["out_datetime"].substring(11, 19)),

                children: <Widget>[
                  Text("Purpose " +
                      doc.data["purpose"] +
                      "\nIn Time " +
                      doc.data["in_datetime"].substring(11, 19) +
                      "\nPhone " +
                      doc.data["phone"] +
                      "\n")
                ],
                // subtitle: new Text(doc.documentID)
              ))
          .toList();
    } else {
      return [ListTile(title: Text("No one is outside"))];
    }
  }

  @override
  Widget build(BuildContext context) {
    MyUserState myUserState = Provider.of<MyUserState>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text("IIT Jammu GetOut"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      content: GetOutFormWidget(
                          userState: myUserState, user: widget.user));
                });
          },
          tooltip: 'go Out',
          child: const Icon(Icons.directions_run),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              AlertDialog(
                title: Text(
                  Provider.of<UserRepository>(context, listen: false)
                      .user
                      .email
                      .substring(0, 11)
                      .toUpperCase(),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("To go out press "),
                  Icon(Icons.directions_run),
                  Text(" icon below."),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Your Inout Register"),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          // height: 50,
                          child: AlertDialog(
                            // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            actions: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 30, 20),
                                // color: Colors.black,
                                child: RaisedButton(
                                  child: Text("CANCEL"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                            // backgroundColor: Colors.transparent,
                            title: Text("History"),
                            content: StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection("users")
                                  .document(widget.user.email.substring(0, 11))
                                  .collection("inout_register")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData)
                                  return new Text("No Data yet");
                                // switch(snapshot.connectionState){
                                //   case ConnectionState.waiting:
                                //     return Center(child: CircularProgressIndicator(),);
                                //   case ConnectionState.done:
                                return ListView(
                                  children: getEntryItems(snapshot),
                                );
                                // }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  RaisedButton(
                    child: Text("SIGN OUT"),
                    onPressed: () =>
                        Provider.of<UserRepository>(context, listen: false)
                            .signOut(),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class GetOutFormWidget extends StatefulWidget {
  final MyUserState userState;
  final GoogleSignInAccount user;
  GetOutFormWidget({Key key, this.user, this.userState}) : super(key: key);

  @override
  _GetOutFormWidgetState createState() => _GetOutFormWidgetState();
}

class _GetOutFormWidgetState extends State<GetOutFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController(text: "1234567890");
  final purposeController = TextEditingController(text: "1234567890");
  final phoneValidator = PatternValidator(r'^([0-9]{10})$',
      errorText: "please enter a valid phone number");
  bool entry_status;

  @override
  Widget build(BuildContext context) {
    // print(widget.user);
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              // initialValue: "1234567890",
              controller: purposeController,
              decoration: InputDecoration(
                labelText: "Purpose",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              // initialValue: "1234567890",
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
              validator: phoneValidator,
            ),
            SizedBox(height: 15),
            RaisedButton(
                child: Text("Submit"),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    entry_status = await widget.userState.doEntry(
                      email: widget.user.email.substring(0, 11),
                      phone: phoneController.text,
                      purpose: purposeController.text,
                    );
                    print(entry_status);
                    Navigator.pop(context);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
