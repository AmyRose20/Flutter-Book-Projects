/* path.dart is a library that allows you to manipulate
file paths. This is useful here, as each platform (iOS
or Android) saves the file in different paths. By using
the path.dart library, we don't need to know how files
are saved in the current operating system, and we can
still access the database using the same code. */
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/list_items.dart';
import '../models/shopping_list.dart';

class DbHelper {
  final int version = 1;
  Database db;

  /* In Dart anf Flutter, there is a feature called "factory constructors"
  that overrides the default behaviour when you call the constructor
  of a class: instead of creating a new instance, the factory constructor
  only returns an instance of the class.
  After 'DbHelper' has already been instantiated, the constructor will
  not build another instance, but just return the existing one. */
  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper() {
    return _dbHelper;
  }

  /* As database operations may take some time to execute,
  especially when they involve dealing with a large quantity
  of data, they are asynchronous. Therefore, the 'openDb'
  function will be asynchronous and return a 'Future' of
  type 'Database'.*/
  Future<Database> openDb() async {
    if(db == null) {
      db = await openDatabase(join(await getDatabasesPath(),
      'shopping.db'),
        onCreate: (database, version) {
          database.execute(
            'CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT,'
                'priority INTEGER)');
          database.execute(
            /* 'quantity' is TEXT and not a number because we want
            the user to allow the measure as well, such as "5 lbs" or "2 kg". */
            'CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER,'
                'name TEXT, quantity TEXT, note TEXT, ' + 'FOREIGN KEY(idLIst)'
                'REFERENCES lists(id))');
        }, version: version);
    }
    return db;
  }

  /* All database methods are asynchronous, so 'testDb()' returns a 'Future'
  and is marked 'async'. */
  Future testDb() async {
    db = await openDb();
    await db.execute('INSERT INTO lists VALUES (0, "Fruit", 2)');
    await db.execute('INSERT INTO items VALUES (0, 0, "Apples", "2 Kg", '
        '"Better if they are green")');
    List lists = await db.rawQuery('select * from lists');
    List items = await db.rawQuery('select * from items');
    // print the first element of the two lists
    print(lists[0].toString());
    print(lists[0].toString());
  }

  // 'insertList' will return the ID of the record that was inserted
  Future<int> insertList(ShoppingList list) async {
    /* 'insert' is an asynchronous method, so we'll call it with the
    'await' command; the 'id' will contain the ID of the new record
    that was inserted.
    The 'insert()' method allows you to specify the following parameters: */
    int id = await this.db.insert(
      // 1. The name of the table we want to insert
      'lists',
      // 2. A 'Map' of the data that we want to insert
      list.toMap(),
      /* 3. Specifies behaviour that should be followed when you try to
      insert a record with the same ID twice. In this case, if the same
      list is inserted multiple times, it will replace the previous data
      with the new list that was passed to the function. */
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> insertItem(ListItem item) async {
    int id = await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  // 'getLists()' will return a 'Future' of a 'List', containing a 'ShoppingList'.
  Future<List<ShoppingList>> getLists() async {
    /* 'query()' returns a 'List' of 'Map' items. To use them easily, we need
    to convert the List<Map<String, dynamic> into a List<ShoppingList>. We
    can to this by calling 'List.generate()', which you can use to generate a
    list of values. */
    final List<Map<String, dynamic>> maps = await db.query('lists');
    return List.generate(maps.length, (i) {
      return ShoppingList(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['priority'],
      );
    });
  }

  Future<List<ListItem>> getItems(int idList) async {
    final List<Map<String, dynamic>> maps =
      /* The name of the table, 'Items', is the first argument.
      We'll also set a second argument called 'where', that will
      filter the results based on a specific field - in this case,
      'idList'. The 'idList' variable will be equal to the value that
      we'll set into the 'whereArgs' named parameter. In this case,
      the 'idList' will have to be equal to the value that was passed
      to the 'getItems()' function. */
      await db.query(
          'items',
          where: 'idList = ?',
          whereArgs: [idList]);
      return List.generate(maps.length, (i) {
        return ListItem(
          maps[i]['id'],
          maps[i]['idList'],
          maps[i]['name'],
          maps[i]['quantity'],
          maps[i]['note'],
        );
      });
  }

  // Method returns the 'id' of the deleted record
  Future<int> deleteList(ShoppingList list) async {
    int result = await db.delete(
      "items",
      where: "idList = ?",
      whereArgs: [list.id]
    );
    result = await db.delete(
      "lists",
      where: "id = ?",
      whereArgs: [list.id],
    );
    return result;
  }

 Future<int> deleteItem(ListItem item) async {
    int result = await db.delete(
        "items",
        where: "id = ?",
        whereArgs: [item.id]
    );
    return result;
 }
}