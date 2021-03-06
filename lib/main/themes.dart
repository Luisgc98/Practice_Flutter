import 'package:ejemplo1/main/tasks.dart';
import 'package:flutter/material.dart';
import 'package:ejemplo1/sqlite/models.dart';

class Themes extends StatefulWidget {
  @override
  _ThemesState createState() => _ThemesState();
}

class _ThemesState extends State<Themes> {
  Future<List<TaskTheme>> themes;
  var dbHelpTaskTheme;

  @override
  void initState(){
    super.initState();
    dbHelpTaskTheme = TaskTheme(null);
    refreshList();
  }

  Future<Null> refreshList() async{
    setState(() {
      themes = dbHelpTaskTheme.readAll();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: themes,
      builder: (context, data){
        if(data.data==null || data.data.length < 1){
          return RefreshIndicator(
            color: Colors.black,
            child: Container(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 250),
                    child: Center(
                      child: Text('Data not found')
                    ),
                  )
                ],
              ),
            ),
            onRefresh: refreshList,
          );
        }
        if(data.hasData){
          return RefreshIndicator(
            color: Colors.black,
            child: ListView.builder(
              itemCount: data.data.length,
              itemBuilder: (context, i){
                var current_theme = data.data[i];
                return Card(
                  margin: EdgeInsets.only(bottom: 10),
                  elevation: 10,
                  child: ListTile(
                    title: Text(current_theme.theme),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red[900],
                      ),
                      tooltip: 'Delete Task Theme',
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Theme '+current_theme.theme),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('This Theme will be delete.'),
                                Divider(),
                                Text('Are you sure continue?')
                              ],
                            ),
                            actions: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    child: FlatButton(
                                      color: Colors.red[700],
                                      child: Text('Cancel'),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  FlatButton(
                                    color: Colors.green[700],
                                    child: Text('Accept'),
                                    onPressed: (){
                                      dbHelpTaskTheme.delete(current_theme.theme);
                                      refreshList();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              )
                            ],
                          )
                        );
                      },
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Tasks(title: current_theme.theme, id: current_theme.id,)
                      ));
                    },
                  ),
                );
              },
            ),
            onRefresh: refreshList,
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}