import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'countdown.dart';

enum MusicalKeyEvent { addMusicalKey }

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MusicCubit>(
      create: (context) => MusicCubit(),
      child: MaterialApp(
        title: 'Key Practice',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: HomeView(),
      ),
    );
  }
}

class KeyButtons extends StatelessWidget {
  List<String> majorKeys = [
    'A',
    'A#',
    'B',
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#'
  ];

  List<String> minorKeys = [
    'Am',
    'A#m',
    'Bm',
    'Cm',
    'C#m',
    'Dm',
    'D#m',
    'Em',
    'Fm',
    'F#m',
    'Gm',
    'G#m'
  ];

  Widget buildKeyColumn(musicCubit, title, List<String> availableKeys, keys) {
    List<Widget> header = [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            textScaleFactor: 2.0,
          ),
        ),
      )
    ];

    var keyButtons = availableKeys.map((e) {
      var active = keys.contains(e);
      return MaterialButton(
        height: 50,
        color: keys.contains(e) ? Colors.amber : Colors.white,
        child: Text(e),
        onPressed: () {
          if (active) {
            musicCubit.removeKey(e);
          } else {
            musicCubit.addKey(e);
          }
        },
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: header..addAll(keyButtons),
    );
  }

  Widget build(BuildContext context) {
    return BlocBuilder<MusicCubit, List<String>>(
        builder: (context, selectedKeys) {
      return SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
                child: buildKeyColumn(context.read<MusicCubit>(), 'Major',
                    majorKeys, selectedKeys)),
            Expanded(
                child: buildKeyColumn(context.read<MusicCubit>(), 'Minor',
                    minorKeys, selectedKeys))
          ],
        ),
      );
    });
  }
}

class HomeView extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Key Practice'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Countdown()));
        },
        child: const Icon(Icons.play_arrow),
      ),
      body: KeyButtons(),
    );
  }
}

class MusicCubit extends Cubit<List<String>> {
  MusicCubit() : super([]);

  void addKey(key) {
    List<String> newList = []..addAll(state..add(key));
    emit(newList);
  }

  void removeKey(key) {
    List<String> newList = []..addAll(state..remove(key));
    emit(newList);
  }
}
