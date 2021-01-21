class Todo {
  int id;
  String name;
  String description;
  String completeBy;
  int priority;

  /* In sembast, the ID is automatically generated from the database and is
  unique for each store/document, similar to what happens with SQLite. */
  Todo(this.name, this.description, this.completeBy, this.priority);

  /* As data is stored as JSON in sembast, we need a method to convert a
  to do object into a 'Map'; the sembast engine will then automatically
  convert the 'Map' to JSON. */
  Map<String, dynamic> toMap () {
    return {
      'name': name,
      'description': description,
      'completeBy': completeBy,
      'priority': priority,
    };
  }

  /* This method will do the exact opposite of 'toMap': when a 'Map' is
  passed, the function will return a new to do. This method is static,
  as it does not require an object to return a to do. */
  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(map['name'], map['description'], map['completeBy'],
        map['priority']);
  }
}