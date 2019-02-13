import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(TabBarDemo());

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/
          // restituisce il numero di parole
          final index = i ~/ 2; /*3*/
          // controlla se il numero di parole visualizzabili
          // sono maggiori di quelle visualizzate
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /* al posto di visualizzarli direttamente */
    /*
        final wordPair = WordPair.random();
        return Text(wordPair.asPascalCase);
      */
    return _buildSuggestions();
  }
}

// di per se presta sempre immutabile
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

//--------------------------------------------------------

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                //aggiungi le icone qua sotto con i tab
                tabs: [
                  Tab(icon: Icon(Icons.directions_car)),
                  Tab(icon: Icon(Icons.directions_transit)),
                  Tab(icon: Icon(Icons.directions_bike)),
                ],
              ),
              title: Text('Tabs Demo'),
            ),
            body: TabBarView(
              children: [
                // aggiungi le interfaccie associate qua sotto, corrispondo alle tab
                RandomWords(),
                Icon(Icons.directions_transit),
                Icon(Icons.directions_bike),
              ],
            ),
            floatingActionButton: new FloatingActionButton(
                elevation: 0.0,
                child: new Icon(Icons.check),
                onPressed: () {})),
      ),
    );
  }
}
