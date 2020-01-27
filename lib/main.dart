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
            supportedLocales: const [Locale('en')],
            localizationsDelegates: [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              _ExampleLocalizationsDelegate(insideCampus.inside),
            ],
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

class ExampleLocalizations {
  static ExampleLocalizations of(BuildContext context) {
    return Localizations.of<ExampleLocalizations>(
        context, ExampleLocalizations);
  }

  const ExampleLocalizations(this._count);

  final bool _count;

  String get title => 'Tapped $_count times';
}

class _ExampleLocalizationsDelegate
    extends LocalizationsDelegate<ExampleLocalizations> {
  const _ExampleLocalizationsDelegate(this.count);

  final bool count;

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<ExampleLocalizations> load(Locale locale) {
    return SynchronousFuture(ExampleLocalizations(count));
  }

  @override
  bool shouldReload(_ExampleLocalizationsDelegate old) => old.count != count;
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Tons of small widgets!
      ///
      /// Splitting our app in small widgets like [Title] or [CounterLabel] is
      /// useful for rebuild optimization.
      ///
      /// Since they are instanciated using `const`, they won't unnecessarily
      /// rebuild when their parent changes.
      /// But they can still have dynamic content, as they can obtain providers!
      ///
      /// This means only the widgets that depends on a provider to rebuild when they change.
      /// Alternatively, we could use [Consumer] or [Selector] to acheive the
      /// same result.
      appBar: AppBar(title: Text("IIT JMU Entry App")),
      body: const Center(child: CounterLabel()),
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
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BasicDateTimeField(),
          SizedBox(height: 24),
          // RaisedButton()
        ],
      ),
    );
  }
}

class BasicDateTimeField extends StatelessWidget {
  final format = DateFormat("dd-MM-yyyy HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText:"Purpose",border: OutlineInputBorder()),
          )
        ]);
  }
}

class CounterLabel extends StatelessWidget {
  const CounterLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final insideCampus = Provider.of<InsideCampus>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        QrImage(
          data: 'This is a simple QR code',
          version: QrVersions.auto,
          size: 320,
          gapless: false,
        ),
        Text(
          '${insideCampus.inside}',
          style: Theme.of(context).textTheme.display1,
        ),
      ],
    );
  }
}
