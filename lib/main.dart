import 'package:flutter/material.dart';
import './util/dbhelper.dart';
import './models/shopping_list.dart';
import './ui/items_screen.dart';
import './ui/shopping_list_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  ShoppingListDialog dialog = ShoppingListDialog();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShList()
    );
  }
}

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  DbHelper helper = DbHelper();
  List<ShoppingList> shoppingList;
  ShoppingListDialog dialog;

  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    // will contain the number of items available in the 'shoppingList' property
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: ListView.builder(
          itemCount: (shoppingList != null) ? shoppingList.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                // key uniquely identifies widget
                key: Key(shoppingList[index].name),
                /* 'onDismissed' get called when you swipe in the specified
                direction. In this case, the direction doesn't matter. */
                onDismissed: (direction) {
                  String strName = shoppingList[index].name;
                  helper.deleteList(shoppingList[index]);
                  /* Next we call 'setState', removing the current item
                  from the list. */
                  setState(() {
                    shoppingList.removeAt(index);
                  });
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("$strName deleted")));
                },
                /* Return a 'ListTile' whose title will be the 'name' property
                of the 'shoppingList' list, at position 'index'. */
                child: ListTile(
                    title: Text(shoppingList[index].name),
                    leading: CircleAvatar(
                      child: Text(shoppingList[index].priority.toString()),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ItemsScreen(shoppingList[index])),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                dialog.buildDialog(
                                    context, shoppingList[index], false));
                      },
                    )));
          }),
      floatingActionButton: FloatingActionButton(
        /* For the function in the 'onPressed' parameter, we'll call the
        'showDialog()' method, passing the current context. In its builder,
        we'll call the 'dialog.buildDialog()' method, again passing the
        context, a new 'ShoppingList', whose 'id' will be 0, an empty name,
        and a 'priority' of 0 and 'true', to tell the function that this
        is a new 'ShoppingList'. */
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                dialog.buildDialog(context, ShoppingList(0, '', 0), true),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }

  Future showData() async {
    /* Using the 'await' command makes sure the database has been
    opened before we try to insert data into it. */
    await helper.openDb();
    shoppingList = await helper.getLists();

    /* ShoppingList list = ShoppingList(0, 'Bakery', 2);
    int listId = await helper.insertList(list);
    // here the list ID will be taken from the 'listId' variable
    ListItem item = ListItem(0, listId, 'Bread', 'note', '1 kg');
    int itemId = await helper.insertItem(item);
    print('List Id: ' + listId.toString());
    print('Item Id: ' + itemId.toString()); */

    /* Call the 'setState()' method to tell our app that the 'ShoppingList'
    has changed. */
    setState(() {
      shoppingList = shoppingList;
    });
  }
}

