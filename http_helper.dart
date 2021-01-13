import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'movie.dart';

class HttpHelper {
  // creating the address url to connect ot the service
  // API Key
  final String urlKey = 'api_key=cbb33e9e66f88c6455708e53cdf8466a';
  // the beginning of every address we'll be using
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  // part of the URL that's specific for the upcoming movies
  final String urlUpcoming = '/upcoming?';
  // option parameter; specify which language
  final String urlLanguage = '&language=en-US';
  final String urlSearchBase = 'https://api.themoviedb.org/3/search/movie?api_key=cbb33e9e66f88c6455708e53cdf8466a&query=';

  /* A 'Future' is used to represent a potential value, or error that
  will be available at some point in the future. When a function returns
  a 'Future', it means it takes a while for its result to be ready. The
  'Future' itself is returned immediately and its underlying object is returned
   at some point in the future.
   Writing Future<String> means that the function will immediately return a
   'Future' without interrupting the code, and then, when it completes
   retrieving all of the data, it will return a 'String'.
   In Dart and Flutter, you must add 'async' when you use an 'await'
   keyword in the body of the function. Any method returning a 'Future' is
   asynchronous anyway, whether or not you mark it with 'async'. */
  Future<List> getUpcoming() async {
    final String upcoming = urlBase + urlUpcoming + urlKey + urlLanguage;
    /* The 'http.Response' class contains the data
    that has been received from a successful HTTP call.
    The 'get' method of the 'http' class returns a 'Future' that
    contains 'Response'.
    'async' waits for a 'Future' to complete. */
    http.Response result = await http.get(upcoming);
    if(result.statusCode == HttpStatus.ok) {
      /* The 'body' property of a 'Response' object is a string. To make
      it easy to parse the result of our request, we want to transform
      this string into an object. */
      final jsonResponse = json.decode(result.body);
      /* If you look at the JSON text retrieved from the web service,
      it contains a header with information about the response and a
      'results' node that contains an array with all of the movies that
      were returned. We just need to parse the 'results' array.*/
      final moviesMap = jsonResponse['results'];
      /* You can call the 'map()' method over an 'Iterable' (which
      basically means a set of objects). This will iterate each element
      of the set ('i') and for each object inside 'moviesMap' it will
      return a 'Movie', as returned by the 'fromJson' constructor
      of the movie class. */
      List movies = moviesMap.map((i) =>
          Movie.fromJson(i)).toList();
      return movies;
    }
    else {
      return null;
    }
  }

  Future<List> findMovies(String title) async {
    final String query = urlSearchBase + title;
    http.Response result = await http.get(query);
    if(result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((i) =>
      Movie.fromJson(i)).toList();
      return movies;
    }
    else {
      return null;
    }
  }
}