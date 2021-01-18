import 'package:flutter/material.dart';

// runApp() method inflates a widget and attaches it to the screen
void main() => runApp(MyApp());

/* Note: A widget is a description of the user interface. This
description gets "inflated" into an actual view when the objects
are built. */
// StatelessWidget as widget does not need to be changed after its creation
/* Extending a stateless widget class requires
overriding a build() method. */
class MyApp extends StatelessWidget
{
  @override
  /* In the build method you describe the
  widget returned by the method */
  Widget build(BuildContext context)
  {
    // A TextDirection must be specified. ltr - left to right
    //  OLD CODE: return Center(child: Text('Wicklow SPCA', textDirection: TextDirection.ltr,),);

    /* Content is wrapped in a MaterialApp widget. This allows
    you to give a title to your app. */
    return MaterialApp(
        title: "Sharpeshill Sanctuary",
        // home is what the user will see on the screen of the app
        /* Scaffold widget represents a screen in a MaterialApp widget
        as it may contain several layouts including a bottom navigation bar,
        floating action buttons etc. */
        home: Scaffold(
          /* In the appbar property, an AppBar widget is placed which will
          contain the text that I want to display in the application bar. */
            appBar: AppBar(
              title: Text('Wicklow SPCA App'),
              backgroundColor: Colors.deepPurple,
            ),
            // body contains the main content of the screen
            // Center is a positional widget that centers its content on the screen
            body: Builder(builder: (context)=> SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                    // child is a property that allows you to nest widgets inside other widgets
                    // Column container widget allows an array of widgets i.e., more than one child
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                            'Wicklow SPCA',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800]),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child:Text(
                            'Adopt a pet!',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.deepPurpleAccent),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Image.network(
                            'https://images.freeimages.com/images/large-previews/c04/puppy-1367856.jpg',
                            height: 350,
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: RaisedButton(
                          child: Text('Contact Us'),
                          // calling contactUs() method
                          onPressed: () => contactUs(context),
                      ),
                    ),
                    ])
                )
            )
          )
          )
        )
    );
  }

  void contactUs(BuildContext context)
  {
    // showDialog required in order to show message to the user
    showDialog(
      // context refers to where dialog is shown
      context: context,
      // function accepts single argument of BuildContext type
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Us'),
          content: Text('Mail us at amymcnabb12@gmail.com'),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              // pop() closes AlertDialog widget
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
        },
     );
  } // contactUs
} // MyApp
