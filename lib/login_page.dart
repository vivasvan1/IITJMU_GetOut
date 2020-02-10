import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_out/user_repo.dart';

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
                : OutlineButton(
                    splashColor: Colors.grey,
                    onPressed: () async {
                      if (!await user.signInWithGoogle())
                        _key.currentState.showSnackBar(SnackBar(
                          content: Text("Something is wrong"),
                        ));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                              image: AssetImage("assets/google_logo.png"),
                              height: 35.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
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
