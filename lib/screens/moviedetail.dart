import 'package:flutter/material.dart';
import 'package:flutter_app/locale/locales.dart';
import 'package:flutter_app/model/movie.dart';
import 'package:flutter_app/util/dbhelper.dart';
import 'package:intl/intl.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;

  MovieDetail(this.movie);

  @override
  State<StatefulWidget> createState() => MovieDetailState(movie);
}

class MovieDetailState extends State {
  Movie movie;

  MovieDetailState(this.movie);

  final _priorities = ['High', 'Medium', 'Low'];

  DbHelper dbHelper = DbHelper();

  final List<String> choices = const <String>[
    'Save & Back',
    'Delete',
    'Back to List'
  ];

  static const menuSave = 'Save & Back';
  static const menuDelete = 'Delete';
  static const menuBack = 'Back to List';

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = movie.title;
    descriptionController.text = movie.description;
    TextStyle textStyle = TextStyle(
        fontSize: 16.0,
        decoration: TextDecoration.none,
        fontFamily: 'Oxygen',
        fontWeight: FontWeight.w300);
    //TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
            movie.title == '' ? AppLocalizations.of(context).add() : movie
                .title),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: select,
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              })
        ],
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    onChanged: (value) => this.updateTitle(),
                    style: textStyle,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).titleLabel(),
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextField(
                        controller: descriptionController,
                        onChanged: (value) => this.updateDescription(),
                        style: textStyle,
                        decoration: InputDecoration(
                            labelText:
                            AppLocalizations.of(context).descriptionLabel(),
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  ListTile(
                      title: DropdownButton<String>(
                          items: _priorities.map((String data) {
                            return DropdownMenuItem<String>(
                              value: data,
                              child: Text(data),
                            );
                          }).toList(),
                          value: retrievePriority(movie.priority),
                          //style: textStyle,
                          onChanged: (data) => updatePriority(data))),
                ],
              ),
            ],
          )),
    );
  }

  void select(String value) async {
    int result;
    switch (value) {
      case menuSave:
        save();
        break;
      case menuDelete:
        Navigator.pop(context, true);
        if (movie.id == null) {
          return;
        }
        result = await dbHelper.deleteMovie(movie.id);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete"),
            content: Text("The item has been deleted"),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;

      case menuBack:
        Navigator.pop(context, true);
        break;
    }
  }

  void save() {
    movie.date = new DateFormat.yMd().format(DateTime.now());
    if (movie.id != null) {
      dbHelper.updateMovie(movie);
    } else {
      dbHelper.insertMovie(movie);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        movie.priority = 1;
        break;
      case "Medium":
        movie.priority = 2;
        break;
      case "Low":
        movie.priority = 3;
        break;
    }
    setState(() {});
  }

  String retrievePriority(int value) {
    return _priorities[value - 1];
  }

  void updateTitle() {
    movie.title = titleController.text;
  }

  void updateDescription() {
    movie.description = descriptionController.text;
  }
}
