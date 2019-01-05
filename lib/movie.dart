import 'package:http/http.dart';

class Movie {
  String _title;

  String get title => _title;

  set title(String title) {
    _title = title;
  }

  String _imageUrl;

  String get imageUrl => _imageUrl;

  set imageUrl(String imageUrl) {
    _imageUrl = imageUrl;
  }

  double _rating;

  double get rating => _rating;

  set rating(double rating) {
    _rating = rating;
  }

  String _overView;

  String get overView => _overView;

  set overView(String overView) {
    _overView = overView;
  }

  List<String> _genres;

  List<String> get genres => _genres;

  set genres(List<String> genres) {
    _genres = genres;
  }

  String _tagline;

  String get tagline => _tagline;

  set tagline(String tagline) {
    _tagline = tagline;
  }

  String _runTime;

  String get runTime => _runTime;

  set runTime(String runTime) {
    _runTime = runTime;
  }

  String _id;

  String get id => _id;

  set id(String id) {
    _id = id;
  }
}
