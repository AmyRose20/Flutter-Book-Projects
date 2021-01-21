import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'todo.dart';

/* The 'TodoDb' class needs to be a singleton, as it wouldn't make sense to
open the database more than once. So, after creating the 'TodoDb' class, add
a named constructor called '_internal', then create a static private 'TodoDb'
object called '_singleton' that we will return whenever a new 'TodoDb'
instance is called. */
class TodoDb {
  // this needs to be a singleton
  static final TodoDb _singleton = TodoDb._internal();
  // private internal constructor
  TodoDb._internal();

  /* A normal constructor returns a NEW INSTANCE of the current class.
  A factory constructor can only return a SINGLE instance of the
  current class. */
  factory TodoDb() {
    return _singleton;
  }

  DatabaseFactory dbFactory = databaseFactoryIo;

  /* After opening the database, you need to specify the location in
  which you want to save files. 'Stores' are 'folders' inside the database:
  the are persistent maps, and their value are the to do objects. */
  final store = intMapStoreFactory.store('todos');

  Database _database;

  Future<Database> get database async {
    if(_database == null) {
      await _openDb().then((db) {
        _database = db;
      });
    }
    return _database;
  }

  Future _openDb() async {
    /* In this method, we'll get the specific directory where data
    will be stored: this is platform specific, but as we are using
    the 'path' library, there's no need to worry about the way the
    operating system is storing data. */
    final docsPath = await getApplicationDocumentsDirectory();
    // join the 'docsPath' and the name of the database
    final dbPath = join(docsPath.path, 'todo.db');
    // open and return database
    final db = await dbFactory.openDatabase(dbPath);
      return db;
  }

  /* To insert a new item in a sembast database, you just need to call
  the 'add()' method over the 'Store', passing the database and the
  'Map' of the object you want to insert. */
  Future insertTodo(Todo todo) async {
    await store.add(_database, todo.toMap());
  }

  /* A 'Finder' is a helper that you can use to search inside a store. With
  the 'update()' method, you need to RETRIEVE a to do before updating it,
  so you need the 'Finder' BEFORE you UPDATE the document.*/
  Future updateTodo(Todo todo) async {
    /* A 'Finder' takes a parameter named 'filter', which you can
    use to specify how to filter the documents. In this case, we'll
    search for the to do using its ID, so we'll use the 'byKey()'
    method of the filter. */
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.update(_database, todo.toMap(), finder: finder);
  }

  Future deleteTodo(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.delete(_database, finder: finder);
  }

  Future deleteAll() async {
    // Clear all records from the score
    await store.delete(_database);
  }

  // Instead of filtering the data, we can specify a sort order for the list
  Future<List<Todo>> getTodos() async {
    await database;
    final finder = Finder(sortOrders: [
      SortOrder('priority'),
      SortOrder('id'),
    ]);
    // 'find()' returns a 'Future<List<recordSnapshot>>' and not a 'List<to do>'
    final todosSnapshot = await store.find(_database, finder: finder);
    // 'map()' method to convert the snapshot into a to do
    return todosSnapshot.map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);
      todo.id = snapshot.key;
      return todo;
    }).toList();
  }
}