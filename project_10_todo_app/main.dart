import 'package:flutter/material.dart';
import 'data/todo_db.dart';
import 'data/todo.dart';
import 'todo_screen.dart';
import 'bloc/todo_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos BLoC',
      debugShowCheckedModeBanner: false,
      theme:  ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoBloc todoBloc;
  List<Todo> todos;

  @override
  void initState() {
    todoBloc = TodoBloc();
    super.initState();
  }

  @override
  void dispose() {
    todoBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Todo todo = Todo('', '', '', 0);
    /* The 'todoList' property of the BLoC contains the objects
    retrieved from the database. */
    todos = todoBloc.todoList;

    testData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoScreen(todo, true)),
          );
        },
      ),
      body: Container(
        /* 'StreamBuilder' will listen to events from the 'Stream' and
        will rebuild all its descendants, using the latest data in the
        Stream. */
        child: StreamBuilder<List<Todo>> (
          /* You connect 'StreamBuilder' to the Streams through the
          'sink' property and a 'builder' that contains the UI that
          needs to be updated. We also set the 'initialData' property
          to make sure we control what is shown at the beginning before
          we receive any events. */
          stream: todoBloc.todos,
          initialData: todos,
          // 'snapshot' contains the data received from the Stream
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView.builder(
              itemCount: (snapshot.hasData) ? snapshot.data.length : 0,
              itemBuilder: (context, index) {
                /* Return a 'Dissmissable' so that the user can swipe
                on the item and delete the to do from the sembast
                database. This will happen by calling the 'todoDeleteSink'
                and adding the to do at the 'index' position. */
                return Dismissible(
                  key: Key(snapshot.data[index].id.toString()),
                  onDismissed: (_) =>
                  todoBloc.todoDeleteSink.add(snapshot.data[index]),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).highlightColor,
                      child: Text("${snapshot.data[index].priority}"),
                    ),
                    title: Text("${snapshot.data[index].name}"),
                    subtitle: Text("${snapshot.data[index].description}"),
                    /* When the user presses the icon, the app will bring
                    them to the second screen of the app, which shows
                    the to do detail and allows the user to edit and
                    save the to do that they selected.
                    We''=ll pass to the to-be-created screen the to do
                    that was selected and a Boolean(false) that tells the
                    screen that this is not a new to do, but an existing
                    one. */
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TodoScreen(
                                      snapshot.data[index], false)),
                        );
                      })
                  )
                );},
            );},
        ),
      ));
  }

  Future testData() async {
    TodoDb db = TodoDb();
    await db.database;
    List<Todo> todos = await db.getTodos();
    await db.deleteAll();
    todos = await db.getTodos();
    // Testing the 'insertTodo()' method
    await db.insertTodo(Todo('Call Donald', 'And tell him about Daisy',
        '02/02/2020', 1));
    await db.insertTodo(Todo('Buy Sugar', '1 Kg, brown',
        '02/02/2020', 2));
    await db.insertTodo(Todo('Go Running', '@12.00 with neighbours',
        '02/02/2020', 3));
    todos = await db.getTodos();

    debugPrint('First Insert');
    todos.forEach((Todo todo) {
      debugPrint(todo.name);
    });

    // Testing the 'updateTodo()' method
    Todo todoToUpdate = todos[0];
    todoToUpdate.name = 'Call Tim';
    await db.updateTodo(todoToUpdate);

    // Testing the 'deleteTodo()' method
    Todo todoToDelete = todos[1];
    await db.deleteTodo(todoToDelete);

    debugPrint('After Updates');
    todos = await db.getTodos();
    todos.forEach((Todo todo) {
      debugPrint(todo.name);
    });
  }
}

