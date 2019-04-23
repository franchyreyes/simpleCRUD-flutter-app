import 'package:flutter_app/locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/todolist.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).title(),
      theme: ThemeData(

        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: "todos"),
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        const Locale('en',''),
        const Locale('es',''),
      ],
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(widget.title),
      ),
      body: TodoList(),
    );
  }
}
