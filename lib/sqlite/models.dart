import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

const String DB_NAME = 'task.db';

class BaseMixin{
  var creation_date;
  var updated_date;
  BaseMixin({this.creation_date, this.updated_date});

  String _creation_date = 'creation_date TEXT,';
  String _updated_date = 'updated_date TEXT,';
}

class DBHelper extends BaseMixin{
  static Database _db;

  initDB() async{
    io.Directory route_app = await getApplicationDocumentsDirectory();
    String path = join(route_app.path, DB_NAME);
    var db = await openDatabase(
      path, 
      version: 1, 
      onCreate: (Database db, int version) async{
        List consults = [
          'CREATE TABLE task_theme ($_creation_date $_updated_date id INTEGER PRIMARY KEY, theme TEXT );',
          'CREATE TABLE task ($_creation_date $_updated_date id INTEGER PRIMARY KEY,description TEXT,status TEXT,task_theme_id INTEGER);',
          'CREATE TABLE task_theme_id_sequence ($_creation_date $_updated_date id INTEGER PRIMARY KEY);',
          'CREATE TABLE task_id_sequence ($_creation_date $_updated_date id INTEGER PRIMARY KEY);'
        ];
        for(String sql in consults){
          await db.execute(sql);
        }
      }
    );

    return db;
  }

  Future<Database> get db async{
    if (_db != null){
      return _db;
    } else{
      _db = await initDB();
      return _db;
    }
  }

  deleteTaskDB() async{
    io.Directory route_app = await getApplicationDocumentsDirectory();
    String path = join(route_app.path, DB_NAME);
    deleteDatabase(path);
  }
}

List task_theme_id_sequence = [];
List task_id_sequence = [];

class TaskTheme extends DBHelper{
  String __tablename__ = 'task_theme';
  TaskTheme(this.theme);
  int id;
  String theme;

  Future<TaskTheme> create (TaskTheme task_theme) async{
    var database = await db;
    List<Map> themes_id = await database.query('task_theme_id_sequence');
    task_theme.creation_date = new DateTime.now().toString().split(' ')[0];
    task_theme.id = themes_id.length+1;
    await database.insert(__tablename__, task_theme.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await database.insert('task_theme_id_sequence', {"id":task_theme.id}, conflictAlgorithm: ConflictAlgorithm.replace);
    return task_theme;
  }

  Future<List<TaskTheme>> readAll () async{
    var database = await db;
    List<Map> maps = await database.query(__tablename__, orderBy: 'theme');
    List<TaskTheme> task_themes = List.generate(maps.length, (i){
      return TaskTheme(
        maps[i]['theme']
      );
    });
    for(int i=0; i < task_themes.length; i++){
      task_themes[i].id = maps[i]['id'];
      task_themes[i].creation_date = maps[i]['creation_date'];
      task_themes[i].updated_date = maps[i]['updated_date'];
    }

    return task_themes;
  }

  /*Future<TaskTheme> read (int id) async{
    var database = await db;
    List<Map> maps = await database.query(__tablename__, where: 'ID = ?', whereArgs: [id]);

    return null;
  }*/

  Future<int> update(TaskTheme task_theme) async{
    var database = await db;
    task_theme.updated_date = new DateTime.now().toString().split(' ')[0];
    return await database.update(__tablename__, task_theme.toMap(), where: 'ID = ?', whereArgs: [task_theme.id]);
  }

  Future<int> delete(String task_theme_id) async{
    var database = await db;
    await database.delete('task', where: 'task_theme_id = ?', whereArgs: [task_theme_id]);
    return await database.delete(__tablename__, where: 'theme = ?', whereArgs: [task_theme_id]);
  }

  Future close() async{
    var database = await db;
    database.close();
  }

  Map<String, dynamic> toMap() {
    return {
      'creation_date': creation_date,
      'updated_date': updated_date,
      'id': id,
      'theme': theme,
    };
  }

  factory TaskTheme.fromJson(Map<String, dynamic> dates){
    return TaskTheme(
      dates['theme']
    );
  }

  @override
  String toString(){
    return 'TaskTheme{id: $id, theme: $theme, creation_date: $creation_date}';
  }

  @override
  List toList(){
    return [
      {
        'id': id,
        'theme': theme
      }
    ];
  }
}

class Task extends BaseMixin{
  static Database _db;
  String __tablename__ = 'task';
  String _id = 'id INTEGER PRIMARY KEY,';
  String _description = 'description TEXT,';
  String _status = 'status TEXT,';
  String _task_theme_id = 'task_theme_id INTEGER';
  Task(this.description, this.task_theme_id, this.status);
  int id;
  String description;
  int task_theme_id;
  String status;

  initDB() async{
    io.Directory route_app = await getApplicationDocumentsDirectory();
    String path = join(route_app.path, DB_NAME);
    var db = await openDatabase(
      path, 
      version: 1, 
      onCreate: (Database db, int version) async{
        await db.execute('CREATE TABLE $__tablename__ ($_creation_date $_updated_date $_id $_description $status $_task_theme_id');
      },
    );

    return db;
  }

  Future<Database> get db async{
    if (_db != null){
      return _db;
    } else{
      _db = await initDB();
      return _db;
    }
  }

  Future<Task> create (Task task) async{
    var database = await db;
    List<Map> tasks_id = await database.query('task_id_sequence');
    task.creation_date = new DateTime.now().toString().split(' ')[0];
    task.id = tasks_id.length+1;
    await database.insert(__tablename__, task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await database.insert('task_id_sequence', {"id":task.id}, conflictAlgorithm: ConflictAlgorithm.replace);
    return task;
  }

  Future<List<Task>> readAll (int theme_id) async{
    var database = await db;
    List<Map> maps = await database.query(__tablename__, orderBy: 'status = "V"', where: 'task_theme_id = ?', whereArgs: [theme_id]);
    List<Task> tasks = List.generate(maps.length, (i){
      return Task(
        maps[i]['description'],
        maps[i]['task_theme_id'],
        maps[i]['status']
      );
    });
    for(int i=0; i<tasks.length; i++){
      tasks[i].id = maps[i]['id'];
      tasks[i].creation_date = maps[i]['creation_date'];
      tasks[i].updated_date = maps[i]['updated_date'];
    }

    return tasks;
  }

  Future<Task> read (int id) async{
    var database = await db;
    List<Map> maps = await database.query(__tablename__, where: 'ID = ?', whereArgs: [id]);
    var task = Task(
      maps[0]['description'],
      maps[0]['task_theme_id'],
      maps[0]['status']
    );
    task.updated_date = maps[0]['updated_date'];
    task.creation_date = maps[0]['creation_date'];
    task.id = maps[0]['id'];
    task.status = maps[0]['status'];

    return task;
  }

  Future<int> update(Task task) async{
    var database = await db;
    task.updated_date = new DateTime.now().toString().split(' ')[0];
    var update = await database.update(__tablename__, task.toMap(), where: 'id = ?', whereArgs: [task.id]);
    return update;
  }

  Future<int> delete(int task_id) async{
    var database = await db;
    return await database.delete(__tablename__, where: 'ID = ?', whereArgs: [task_id]);
  }

  Future close() async{
    var database = await db;
    database.close();
  }

  Map<String, dynamic> toMap() {
    return {
      'creation_date': creation_date,
      'updated_date': updated_date,
      'id': id,
      'description': description,
      'task_theme_id': task_theme_id,
      'status': status
    };
  }

  factory Task.fromJson(Map<String, dynamic> dates){
    return Task(
      dates['description'],
      dates['task_theme_id'],
      dates['status']
    );
  }

  @override
  String toString(){
    return 'Task{id: $id, description: $description, status: $status, creation_date: $creation_date}';
  }

  @override
  List toList(){
    return [
      {
        'id': id,
        'description': description
      }
    ];
  }
}