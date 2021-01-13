import 'package:flutter/material.dart';
import 'package:movies/http_helper.dart';
import 'movie_detail.dart';

  class MovieList extends StatefulWidget {
    @override
    _MovieListState createState() => _MovieListState();
  }

  class _MovieListState extends State<MovieList> {
    String result;
    HttpHelper helper;
    int moviesCount;
    List movies;
    final String iconBase = 'https://image.tmdb.org/t/p/w92/';
    final String defaultImage = 'https://images.freeimages.com/images/large-previews/5eb/movies-clapboard-1184339.jpg';
    Icon visibleIcon = Icon(Icons.search);
    Widget searchBar = Text('Movies');

    @override
    void initState() {
      helper = HttpHelper();
      initialize();
      super.initState();
    }

    @override
    /* In the 'build' method, we'll call the 'getUpcoming' asynchronous
    method, and when the results are returned (this is the 'then' method),
    we'll call the 'setState' method to update the result string with
    the value that was returned. */
    Widget build(BuildContext context) {
      NetworkImage image;
      return Scaffold(
          appBar: AppBar(
            title: searchBar,
            actions: <Widget>[
              IconButton(
                icon: visibleIcon,
                onPressed: () {
                    setState(() {
                      if (this.visibleIcon.icon == Icons.search) {
                        this.visibleIcon = Icon(Icons.cancel);
                        this.searchBar = TextField(
                          textInputAction: TextInputAction.search,
                            onSubmitted: (String text) {
                              search(text);
                            },
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,)
                        );}
                      else {
                        setState(() {
                          this.visibleIcon = Icon(Icons.search);
                          this.searchBar = Text('Movies');
                        });
                      }
                    });
                },
              )
            ],
          ),
          /* 'ListView' will show the 'Movie' objects returned by the
          'getUpcoming()' method.
          ListViews default scrolling direction is vertical.
          The 'ListView.builder' is very useful as it creates items as
          they're scrolled on the screen. */
          body: ListView.builder(
              itemCount: (this.moviesCount==null) ? 0 : this.moviesCount,
              // position refers to position in the list
              itemBuilder: (BuildContext context, int position) {
                if(movies[position].posterPath != null) {
                  image = NetworkImage(
                    iconBase + movies[position].posterPath
                  );
                }
                else {
                  image = NetworkImage(defaultImage);
                }
                return Card (
                  color: Colors.white,
                  elevation: 2.0,
                  /* 'ListTile' is a material widget that can contain one to
                  three lines of text with optional icons at the beginning
                  and end. */
                  child: ListTile (
                    onTap: () {
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (_) => MovieDetail(movies[position])
                      );
                    },
                    title: Text(movies[position].title),
                    subtitle: Text('Released: ' + movies[position].releaseDate +
                    ' - Vote: ' + movies[position].voteAverage.toString()),
                    /* Way to show the image inside the 'ListTile'.
                    'CircleAvatar' is a circle that can contain
                    an image or some text. */
                    leading: CircleAvatar(
                      backgroundImage: image,
                    ),
                  )
                );
              })
      );
    }

    Future initialize() async {
      movies = List();
      movies = await helper.getUpcoming();
      setState(() {
        moviesCount = movies.length;
        movies = movies;
      }
      );
    }

    /* The purpose of the 'search' method is to call the 'HttpHelper findMovies'
    method, wait for its result, and then call the 'setState' method to update
    the 'moviesCount' and 'movies' properties so that the UI will show the
    movies that were found. */
    Future search(text) async {
      movies = await helper.findMovies(text);
      setState(() {
        moviesCount = movies.length;
        movies = movies;
      });
    }
  }

