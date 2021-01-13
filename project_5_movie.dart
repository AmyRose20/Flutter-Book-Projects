class Movie {
  int id;
  String title;
  double voteAverage;
  String releaseDate;
  String overview;
  String posterPath;

  Movie(this.id, this.title, this.voteAverage, this.releaseDate,
      this.overview, this.posterPath);

  /* When we get the dat from the web API, we want to transform it into
  a 'Movie'. So, we need a method to get data in JSON format and output a
  'Movie' object.
  This named constructor will return a 'Movie' object. As a parameter, it
  will take a 'Map' which is a key-value pair. The key will be a string
  (for example, 'title'), and the value needs to be 'dynamic', as it can
  be text or a number. */
  Movie.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'];
    this.title = parsedJson['title'];
    this.voteAverage = parsedJson['vote_average']*1.0;
    this.releaseDate = parsedJson['release_date'];
    this.overview = parsedJson['overview'];
    this.posterPath = parsedJson['poster_path'];
  }
}
