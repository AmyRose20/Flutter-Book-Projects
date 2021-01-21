import 'dart:async';
import '../data/todo.dart';
import '../data/todo_db.dart';

/* This file will contain a class called 'TodoBloc', which will
serve as an interface between the UI and the data of the app. */
class TodoBloc {
  TodoDb db;
  List<Todo> todoList;

  /* Single-subscription Streams only allow a single listener during the whole
  lifetime of the Stream. Broadcast Streams allow multiple listeners that
  can be added at any time: each listener will receive data from the moment
  it begins listening to the Stream. */
  final _todosStreamController = StreamController<List<Todo>>.broadcast();
  // for updates
  final _todoInsertController = StreamController<Todo>();
  final _todoUpdateController = StreamController<Todo>();
  final _todoDeleteController = StreamController<Todo>();

  // 'sink' property to add data and the 'stream' property to get data
  Stream<List<Todo>> get todos => _todosStreamController.stream;
  StreamSink<List<Todo>> get todosSink => _todosStreamController.sink;
  StreamSink<Todo> get todoInsertSink => _todoInsertController.sink;
  StreamSink<Todo> get todoUpdateSink => _todoUpdateController.sink;
  StreamSink<Todo> get todoDeleteSink => _todoDeleteController.sink;

  TodoBloc() {
    db = TodoDb();
    getTodos();
    // listen to the changes for each of the methods that we have created
    _todosStreamController.stream.listen(returnTodos);
    _todoInsertController.stream.listen(_addTodo);
    _todoUpdateController.stream.listen(_updateTodo);
    _todoDeleteController.stream.listen(_deleteTodo);
  }

  Future getTodos() async {
    List<Todo> todos = await db.getTodos();
    todoList = todos;
    todosSink.add(todos);
  }

  List<Todo> returnTodos(todos) {
    return todos;
  }

  void _deleteTodo(Todo todo) {
    db.deleteTodo(todo).then((result) {
      getTodos();
    });
  }

  void _updateTodo(Todo todo) {
    db.updateTodo(todo).then((result) {
      getTodos();
    });
  }

  void _addTodo(Todo todo) {
    db.insertTodo(todo).then((result) {
      getTodos();
    });
  }

  // In the dispose method we need to close the stream controllers.
  void dispose() {
    _todosStreamController.close();
    _todoInsertController.close();
    _todoUpdateController.close();
    _todoDeleteController.close();
  }
}