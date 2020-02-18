import 'package:flutter/material.dart';
import 'package:get_out/user_repo.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:get_out/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Inside extends StatefulWidget {
  final GoogleSignInAccount user;
  Inside({Key key, this.user}) : super(key: key);

  @override
  _InsideState createState() => _InsideState();
}

class _InsideState extends State<Inside> {
  @override
  Widget build(BuildContext context) {
    MyUserState myUserState = Provider.of<MyUserState>(context,listen: false);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(Provider.of<UserRepository>(context, listen: false)
                    .user
                    .email),
                Text("To register going out press the floating"),
                Icon(Icons.directions_run),
                Text(" icon below."),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text("Your Inout Register"),
                  onPressed: () => {},
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
      ),
    );
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
  final phoneController = TextEditingController();
  final purposeController = TextEditingController();
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
            widget.userState.isloading ? CircularProgressIndicator() : Text(""),
          ],
        ),
      ),
    );
  }
}

