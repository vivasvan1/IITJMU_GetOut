import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_out/user_state.dart';
import 'utls/inout_entry.dart';
import 'package:get_out/inside.dart';
import 'package:get_out/approving.dart';
class UserInfoPage extends StatelessWidget {
  final GoogleSignInAccount user;

  const UserInfoPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyUserState(user: user),
      child: Consumer<MyUserState>(
        builder: (context, MyUserState user_state, _) {
          switch (user_state.state) {
            case MyState.Inside:
              return Inside(user: user);
            case MyState.Approving:
              return Approving(user: user);
            case MyState.Outside:
            case MyState.Loading:
              return Center(child: CircularProgressIndicator(),);
            // return LoginPage();
          }
        },
      ),
    );
  }
}
