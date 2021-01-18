class ShoppingList {
  int id;
  String name;
  int priority;

  ShoppingList(this.id, this.name, this.priority);

  /* 'toMap()' will return a 'Map' of type 'String, dynamic'. A map is a
  collection of key/value pairs: the first ype we specify is for the key,
  which in this case will always be a string. The second type is for the
  value: as we have different types in the table, this will be dynamic.
  In a 'Map', you can retrieve a value using its key. */
  Map<String, dynamic> toMap() {
    return {
      /* When you provide a 'null' value when you insert a new record, the
      database will automatically assign a new value, with an auto-increment
      logic. That's why for the 'id', we are using a ternary operator: when
      the 'id' is equal to 0, we change it to 'null', so that SQLite will
      be able to set the 'id' for us. */
      'id': (id==0)?null:id,
      'name': name,
      'priority': priority,
    };
  }
}