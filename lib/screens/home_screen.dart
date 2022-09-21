import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_app/blocs/movie_bloc/movie_bloc.dart';
import 'package:hive_app/models/movie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showModalBottomSheet({
    required BuildContext context,
    Movie? movie,
  }) {
    TextEditingController nameController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();

    if (movie != null) {
      nameController.text = movie.title;
      imageUrlController.text = movie.imageUrl;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      elevation: 5,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: 20,
          right: 20,
          left: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(labelText: 'Movie'),
            ),
            TextField(
              controller: imageUrlController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            ElevatedButton(
              onPressed: () {
                if (movie == null) {
                  Movie movie = Movie(
                    id: DateTime.now().toString(),
                    title: nameController.text,
                    imageUrl: imageUrlController.text,
                  );

                  context.read<MovieBloc>().add(AddMovie(movie: movie));
                } else {
                  context.read<MovieBloc>().add(UpdateMovie(
                          movie: movie.copyWith(
                        title: nameController.text,
                        imageUrl: imageUrlController.text,
                      )));
                }

                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Best Movies - 2022'),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return CircularProgressIndicator();
          }
          if (state is MovieLoaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.teal.withOpacity(0.2),
                        ),
                        child: Center(
                          child: ListTile(
                            title: Text(state.movies[index].title),
                            leading: Image.network(
                              state.movies[index].imageUrl,
                              fit: BoxFit.cover,
                              width: 100,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.watch_later_sharp,
                                    color: state.movies[index].addedToWatchList
                                        ? Colors.teal
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    context.read<MovieBloc>().add(
                                          UpdateMovie(
                                            movie: state.movies[index].copyWith(
                                              addedToWatchList: !state
                                                  .movies[index]
                                                  .addedToWatchList,
                                            ),
                                          ),
                                        );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _showModalBottomSheet(
                                      context: context,
                                      movie: state.movies[index],
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    context.read<MovieBloc>().add(
                                          DeleteMovie(
                                            movie: state.movies[index],
                                          ),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: state.movies.length,
            );
          } else {
            return Text('Something went wrong');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.teal,
                Colors.greenAccent,
              ],
            ),
          ),
          child: Icon(
            Icons.add,
          ),
        ),
        onPressed: () {
          _showModalBottomSheet(
            context: context,
          );
        },
      ),
    );
  }
}
