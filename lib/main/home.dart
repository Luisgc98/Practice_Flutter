import 'package:ejemplo1/main/themes.dart';
import 'package:flutter/material.dart';
import 'package:ejemplo1/sqlite/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var dbHelpTaskTheme;
  var dbHelpTask;
  var dbHelp;
  TextEditingController task;
  String opc = '--Selection a Theme--';
  @override
  void initState(){
    super.initState();
    dbHelpTaskTheme = TaskTheme(null);
    dbHelpTask = Task(null, null, null);
    dbHelp = DBHelper();
    task = TextEditingController();
  }

  listThemes() async{
    setState(() {
      List themes = dbHelpTaskTheme.readAll();
      return themes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
      ),
      body: Themes(),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 15),
            child: FloatingActionButton(
              heroTag: 'btn1',
              backgroundColor: Colors.black,
              child: Icon(
                Icons.post_add
              ),
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (context) => ModalAddTaskTheme()
                );
              },
              
            ),
          ),
          FloatingActionButton(
            heroTag: 'btn1.1',
            backgroundColor: Colors.black,
            child: Icon(
              Icons.note_add_outlined
            ),
            onPressed: () async{
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Add Task to Task Theme'),
                  content: Material(
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          child: TextFormField(
                            controller: task,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: 'Theme',
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: DropdownButtonFormField<String>(
                            value: opc,
                            icon: Icon(
                              Icons.arrow_drop_down_circle_outlined
                            ),
                            onChanged: (String select){
                              setState(() {
                                opc = select;
                              });
                            },
                            
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          width: 500,
                          child: RaisedButton(
                            color: Colors.black,
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async{
                              
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                )
              );
            },
          ),
        ],
      ),
    );
  }
}

class ModalAddTaskTheme extends StatefulWidget {
  @override
  _ModalAddTaskThemeState createState() => _ModalAddTaskThemeState();
}

class _ModalAddTaskThemeState extends State<ModalAddTaskTheme> {
  TextEditingController theme;
  Future<List<TaskTheme>> themes;
  var dbHelpTaskTheme;
  @override
  void initState(){
    super.initState();
    theme = TextEditingController();
    dbHelpTaskTheme = TaskTheme(null);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add a Task Theme'),
      content: Container(
        child: Material(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: theme,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Theme',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  width: 500,
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async{
                      TaskTheme _theme = TaskTheme(theme.text);
                      dbHelpTaskTheme.create(_theme);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}