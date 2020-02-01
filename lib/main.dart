import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:get_out/login.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() => runApp(MyApp());

class InsideCampus with ChangeNotifier {
  bool _inside = true;
  bool get inside => _inside;

  void getOut() {
    _inside = false;
    notifyListeners();
  }

  void getIn() {
    _inside = true;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InsideCampus()),
      ],
      child: Consumer<InsideCampus>(
        builder: (context, insideCampus, _) {
          return MaterialApp(
            home: const MyHomePage(),
          );
        },
      ),
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
      floatingActionButton: const GetOutButton(),
    );
  }
}

class GetOutButton extends StatelessWidget {
  const GetOutButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(content: GetOutFormWidget());
            });
        Provider.of<InsideCampus>(context, listen: false).getOut();
      },
      tooltip: 'go Out',
      child: const Icon(Icons.directions_run),
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
            // RaisedButton()
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
    final insideCampus = Provider.of<InsideCampus>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        insideCampus.inside
            ? Text(
                'you are inside IIT Jammu campus. Press the button at bottom right',
                style: Theme.of(context).textTheme.display1,
              )
            : Text(
                'you are outside IIT Jammu campus. Scan the QR to get in',
                style: Theme.of(context).textTheme.display1,
              ),
      ],
    );
  }
}
