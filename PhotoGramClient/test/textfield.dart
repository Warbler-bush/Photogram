import 'package:flutter/material.dart';
import "dart:io";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
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

class _MyHomePageState extends State<MyHomePage> {

  /// Connessione al server con l'input non ancora formattato
  void _send(TextEditingController controller){
    String txt =controller.text;
    //TODO: fare formattazione json
    Client c = new Client();
    c.connetti("10.0.2.2", 1235,txt); //10.0.2.2 local ip of machine
  }

  /// creazione grafica
  @override
  Widget build(BuildContext context) {

    TextEditingController control = new TextEditingController();


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
        body: new Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.all(10.0),
                child : new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child:  new ScrollableArea( //Gurdare classe ScrollableArea
                        mycontroller:control,     //Control per l'input
                      )
                    ),
                    new FloatingActionButton(     //Bottone invia al server
                      onPressed: () => _send(control),  //"() =>" utilizzato per chiamare funzioni con parametri
                      tooltip: 'Increment',
                      child: Icon(Icons.send),
                    ),
                    //TODO: Creare visualizzazione risposta server
                  ],
                )
              )
            ]
          )
        ));
  }


}
class ScrollableArea extends StatelessWidget {  //classe che permetettte di creare widget personalizzzato TODO:guardare utilizzo di StateFullWidget
  TextEditingController mycontroller;
  ScrollableArea({Key key,this.mycontroller});

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      scrollDirection: Axis.vertical,
      reverse: true,
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: this.mycontroller,
        keyboardType: TextInputType.multiline,
        maxLines: 1,      //if null -> grow automatically
        decoration: new InputDecoration(
            border: new OutlineInputBorder(     //bordi
              borderRadius: const BorderRadius.all(
                const Radius.circular(100.0),
              ),
            ),
            filled: true,
            hintStyle: new TextStyle(color: Colors.grey[800]),
            hintText: "Inserisci un testo da analizzare",
            fillColor: Colors.white70),
      ),
    );
  }
/* Bisogna utilizzare una StatefulWidget ?
   String getText() {
    return this.mycontroller.text;
  }

  void setText(String txt) {
    this.mycontroller.text = txt;
  }*/
}



