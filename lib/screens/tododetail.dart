import 'package:flutter/material.dart';
import 'package:flutter_app/locale/locales.dart';
import 'package:flutter_app/model/todo.dart';
import 'package:flutter_app/util/dbhelper.dart';
import 'package:intl/intl.dart';

class TodoDetail extends StatefulWidget {
  final Todo todo;

  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State {
  Todo todo;

  TodoDetailState(this.todo);

  final _priorities = ['High', 'Medium', 'Low'];
  //String _priority = 'Low';

  DbHelper dbHelper = DbHelper();

  final List<String> choices = const <String>[
    'Save Todo & Back',
    'Delete Todo',
    'Back to List'
  ];

  static const menuSave = 'Save Todo & Back';
  static const menuDelete = 'Delete Todo';
  static const menuBack = 'Back to List';

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(todo.title == '' ? AppLocalizations.of(context).title() : todo.title),
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
                        labelText: "Title",
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
                            labelText: "Description",
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
                          value: retrievePriority(todo.priority),
                          style: textStyle,
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
        if (todo.id == null) {
          return;
        }
        result = await dbHelper.deleteTodo(todo.id);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Todo"),
            content: Text("The todo has been"),
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
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if (todo.id != null) {
      dbHelper.updateTodo(todo);
    } else {
      dbHelper.insertTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;
    }
    setState(() {
      //_priority = value;
    });
  }

  String retrievePriority(int value) {
    return _priorities[value - 1];
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  void updateDescription() {
    todo.description = descriptionController.text;
  }
}
