import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:get_out/login_page.dart';
import 'package:get_out/user_repo.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() => runApp(MyApp2());

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage2(),
    );
  }
}

class HomePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRepository.instance(),
      child: Consumer(
        builder: (context, UserRepository user, _) {
          switch (user.status) {
            case Status.Uninitialized:
              return Splash();
            case Status.Unauthenticated:
              return LoginPage();
            case Status.Authenticating:
              return LoginPage();
            case Status.Authenticated:
              return UserInfoPage(user: user.user);
          }
        },
      ),
    );
  }
}

class UserInfoPage extends StatelessWidget {
  final GoogleSignInAccount user;

  const UserInfoPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IIT Jammu GetOut"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(content: GetOutFormWidget());
              });
        },
        tooltip: 'go Out',
        child: const Icon(Icons.directions_run),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(user.email),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed: () =>
                  Provider.of<UserRepository>(context, listen: false).signOut(),
            )
          ],
        ),
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("IIT JMU Entry App")),
      body: const Center(child: HintText()),
    );
  }
}

class GetOutFormWidget extends StatefulWidget {
  GetOutFormWidget({Key key}) : super(key: key);

  @override
  _GetOutFormWidgetState createState() => _GetOutFormWidgetState();
}

class _GetOutFormWidgetState extends State<GetOutFormWidget> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
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
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                // else if()
                return null;
              },
            ),
            SizedBox(height:15),
            RaisedButton(
              child: Text("Submit"),
              onPressed: (){
                
                
              },
            )
          ],
        ),
      ),
    );
  }
}

class HintText extends StatelessWidget {
  const HintText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final insideCampus = Provider.of<InsideCampus>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // insideCampus.inside
        // ? Text(
        //     'you are inside IIT Jammu campus. Press the button at bottom right',
        //     style: Theme.of(context).textTheme.display1,
        //   )
        // :
        Text(
          'you are outside IIT Jammu campus. Scan the QR to get in',
          style: Theme.of(context).textTheme.display1,
        ),
      ],
    );
  }
}
