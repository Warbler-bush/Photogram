import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:io';
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

// di per se resta sempre immutabile
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
                ScrollableArea(),
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



class ScrollableArea extends StatelessWidget {  //classe che permetettte di creare widget personalizzzato TODO:guardare utilizzo di StateFullWidget
  static TextEditingController mycontroller = new TextEditingController();

  ScrollableArea({Key key,});

  @override
  Widget build(BuildContext context) {
    return new Container(
        //height: MediaQuery.of(context).size.height/2,
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          reverse: true,
      //padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: ScrollableArea.mycontroller,
        keyboardType: TextInputType.multiline,
        maxLines: 26,      //if null -> grow automatically
        decoration: new InputDecoration(
            border: new OutlineInputBorder(     //bordi
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            filled: true,
            hintStyle: new TextStyle(color: Colors.grey[800]),
            hintText: "Inserisci un testo da analizzare",
            fillColor: Colors.white70),
      ),
    )
    );
  }

}

/// classe Client @param: ip, port, text, socket */
class Client{
  String ip;
  int port;
  String text;
  Socket socket;

  Client();
  /// si connette al server, invia e riceve

  void connetti(ip,port,text){
    this.ip = ip;
    this.port = port;
    this.text = text;
    //connessione
    Socket.connect(this.ip, this.port).then((socket) {
      print('Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}');

      //invio
      print("ok");
      socket.write(this.text); //'{"lang":"it","type":"g","text":"A Wang piacciono i cani"}'

      //ricevo
      socket.listen((data){
        print(new String.fromCharCodes(data).trim());

      },
          onDone: () {
            print("Done");
            socket.destroy();//chiudi socket se avvenuta ricezione
          });
    });
  }
}






