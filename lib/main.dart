import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_app/blocs/movie_bloc/movie_bloc.dart';
import 'package:hive_app/models/movie.dart';
import 'package:hive_app/screens/home_screen.dart';
import 'package:hive_app/utilities/hive_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());

  final hiveDatabase = HiveDatabase();
  await hiveDatabase.openBox();

  runApp(MyApp(hiveDatabase: hiveDatabase));
}

class MyApp extends StatelessWidget {
  final HiveDatabase _hiveDatabase;
  const MyApp({super.key, required HiveDatabase hiveDatabase})
      : _hiveDatabase = hiveDatabase;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MovieBloc(hiveDatabase: _hiveDatabase)..add(LoadMovies()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hive App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
