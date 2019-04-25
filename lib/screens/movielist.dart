import 'package:flutter/material.dart';
import 'package:flutter_app/model/movie.dart';
import 'package:flutter_app/util/dbhelper.dart';
import 'package:flutter_app/screens/moviedetail.dart';

class MovieList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MovieListState();
}

class MovieListState extends State {
  DbHelper helper = DbHelper();
  List<Movie> movies;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (movies == null) {
      movies = List<Movie>();
      getData();
    }

    return Scaffold(
      body: movieListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Movie('', 3, ''));
        },
        tooltip: "Add new",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView movieListItems() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getColor(this.movies[position].priority),
                child: Text(this.movies[position].id.toString()),
              ),
              title: Text(this.movies[position].title),
              subtitle: Text(this.movies[position].date),
              onTap: () {
                navigateToDetail(this.movies[position]);
              },
            ),
          );
        });
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final moviesFuture = helper.getMovies();
      moviesFuture.then((result) {
        List<Movie> movieList = List<Movie>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          movieList.add(Movie.fromObject(result[i]));
        }
        setState(() {
          movies = movieList;
          count = count;
        });
      });
    });
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.green;
        break;
      default:
        return Colors.green;
    }
  }

  void navigateToDetail(Movie movie) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => MovieDetail(movie)));

    if (result) {
      getData();
    }
  }
}
