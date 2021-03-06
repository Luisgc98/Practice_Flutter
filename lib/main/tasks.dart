import 'package:ejemplo1/sqlite/models.dart';
import 'package:flutter/material.dart';

class Tasks extends StatefulWidget {
  Tasks({this.title, this.id});
  String title;
  int id;

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  Future<List<Task>> tasks;
  var dbHelpTask;

  @override
  void initState(){
    super.initState();
    dbHelpTask = Task(null, null, null);
    refreshList();
  }

  Future<Null> refreshList() async{
    setState(() {
      tasks = dbHelpTask.readAll(widget.id);
    });
    return null;
  }

  MyTasks(){
    return FutureBuilder(
      future: tasks,
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
                var current_task = data.data[i];
                return Card(
                  elevation: 10,
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(
                        current_task.status == 'F' ?
                        Icons.check_box_outline_blank
                        : Icons.check_box_outlined
                      ),
                      onPressed: (){
                        if(current_task.status == 'F'){
                          current_task.status = 'V';  
                          dbHelpTask.update(current_task);
                          refreshList();
                        } else{
                          current_task.status = 'F';
                          dbHelpTask.update(current_task);
                          refreshList();
                        }
                      },
                    ),
                    title: Text(current_task.description),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red[900],
                      ),
                      tooltip: 'Delete Task',
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Task '),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('This Task will be delete.'),
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
                                      dbHelpTask.delete(current_task.id);
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: MyTasks(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'btn2',
        backgroundColor: Colors.black,
        child: Icon(
          Icons.note_add_outlined
        ),
        onPressed: () async{
          showDialog(
            context: context,
            builder: (context) => ModalAddTask(id: widget.id, title: widget.title)
          );
        },
      ),
    );
  }
}

class ModalAddTask extends StatefulWidget {
  ModalAddTask({this.id, this.title});
  int id;
  String title;
  @override
  _ModalAddTaskState createState() => _ModalAddTaskState();
}

class _ModalAddTaskState extends State<ModalAddTask> {
  TextEditingController task;
  Future<List<Task>> tasks;
  var dbHelpTask;
  @override
  void initState(){
    super.initState();
    task = TextEditingController();
    dbHelpTask = Task(null, null, null);
    refreshList();
  }

  Future<Null> refreshList() async{
    setState(() {
      tasks = dbHelpTask.readAll(widget.id);
    }); 
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add a Task to '+widget.title),
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
                    maxLines: 7,
                    controller: task,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Task',
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
                      Task _task = Task(task.text, widget.id, 'F');
                      dbHelpTask.create(_task);
                      refreshList();
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