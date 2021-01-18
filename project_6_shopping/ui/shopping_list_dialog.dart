import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import '../models/shopping_list.dart';

class ShoppingListDialog {
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  /* Boolean value will tell whether the 'list' is a new 'list'
  or if wee need to update and existing 'list'. */
  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew) {
    DbHelper helper = DbHelper();
    // Check whether the instance of 'ShoppingList' passed is an existing 'list'
    if(!isNew) {
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }
    /* Use the 'title' to inform whether this dialog is used to insert
    a new list or to update an existing one. */
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0)
      ),
      title: Text((isNew)?'New shopping list':'Edit shopping list'),
      // 'content' will contain all the UI for this dialog window
      content: SingleChildScrollView(
        child: Column(children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: 'Shopping List Name'
              ),
            ),
            TextField(
              controller: txtPriority,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Shopping List Priority (1-3)'
              ),
            ),
            RaisedButton(
              child: Text('Save Shopping List'),
              /* In the 'onPressed' method, first, we will update the list
              object with the new data coming from the two 'TextFields',
              and then, we'll call the 'insertList()' method of our 'helper'
              object, passing the 'list'. */
              onPressed: () {
                list.name = txtName.text;
                list.priority = int.parse(txtPriority.text);
                helper.insertList(list);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}