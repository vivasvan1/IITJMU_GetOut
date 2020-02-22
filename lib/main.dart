import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_out/login_page.dart';
import 'package:get_out/user_repo.dart';
import 'package:get_out/home.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


void main() => runApp(MyApp2());

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
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
