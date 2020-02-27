import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_out/user_repo.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("IITJMU GetOut"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(shrinkWrap: true, children: <Widget>[
            user.status == Status.Authenticating
                ? Center(child: CircularProgressIndicator())
                : Container(
                  margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                    child: SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        if (!await user.signInWithGoogle()) {
                          _key.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Something is wrong"),
                            ),
                          );
                        }
                      },
                    ),
                  )
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
