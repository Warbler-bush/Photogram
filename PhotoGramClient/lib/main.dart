import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    //logError(e.code, e.description);
  }
  runApp(TabBarDemo());
}

/*SHAREDPREFENCES struttura generale
    * (1 frase)[0] = parola:analsi /n parola:analisi /n ecc.
    * ...
    * (5 frase)[4] = parola:analsi /n parola:analisi /n ecc.
*/

/*ricevuta una lista di massimo 5 frasi la aggiungo alla sharedPrefernces*/
Future<bool> setValue(List<String> s) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  for(int i = 0; i < s.length; i++){
    prefs.setString("history" + i.toString(), s[i]); //utilizzo come chiave per accedere alle varie frasi history0 history1 ecc.
  }
  return prefs.commit();
}

/*data una key ritorno il valore di riferimento nella sharedPrefernces */
Future<String> getValue(String key) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String value = prefs.getString(key);
  return value;
}

/**classe che contiene tutti i parametri statici utilizzati dalle varie classi*/
class Context{
  /*From tabBar*/
  static TabController tabController;

  /*From settings*/
  static TextEditingController ip =  new TextEditingController();
  static TextEditingController port =  new TextEditingController();
  static bool logica;
  static bool grammaticale = true;

  /*from ScrollableArea*/
  static TextEditingController mycontroller = new TextEditingController();

  static String getIpSettings(){
    return Context.ip.text;
  }

  static setIpSettings(String ip){
    if(ip != null)
      Context.ip.text= ip;
  }

  static int getPortSettings(){
    return int.parse(Context.port.text);
  }

  static setPortSettings(String port){
    if (port != null)
      Context.port.text = port;
  }

  static bool isGrammaticale(){
    return Context.grammaticale;
  }

  static setGrammaticale(bool value){
    if(value != null)
      Context.grammaticale = value;
  }

  static bool isLogica(){
    return Context.logica;
  }

  static setLogica(bool value){
    if(value != null)
      Context.logica = value;
  }

  static String getTextArea(){
    return Context.mycontroller.text;
  }

  static setTextArea(String text){
    if(text != null)
      Context.mycontroller.text = text;
  }


}



class History extends StatefulWidget{
  @override
  _History createState() => new _History();

}
class _History extends State<History>{
  List<String> history = new List<String>();

  @override
  void initState(){
    for(int i = 0; i<5; i++){
      getValue("history" + i.toString()).then(setHistory); //Ricavo tutte le ricerche dalla sharedpreferences e carico la lista history
    }

    super.initState();
  }

  void setHistory(String s) {
    setState(() {
      if(s!=null) {
        history.add(s);
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    List<String> result = List<String>();

    /*Struttura generale
    * (1 frase)[0] = parola:analsi /n parola:analisi /n ecc.
    * ...
    * (1 frase)[4] = parola:analsi /n parola:analisi /n ecc.
    *
    * */

    /*Per ogni frase splitto per /n */
    for(int i = 0; i < history.length; i++) {
      List<String> line  = history[i].split('\n');
      String temp="";
      /*Per ogni riga splitto per : ottenendo cosi le parole e l'analisi separate */
      for(int j=0; j<line.length;j++){
        List<String> word = line[j].split(':');

        /*nella cronologia visualizzerò solo parole*/
        for(int k = 0 ; k < word.length; k+=2){
          temp += word[k] + " ";
        }
      }
      result.add(temp);

    }

    /*TODO: aggiungere ONTAP sui elementi per caricare il testo nella textarea */

    result = result.reversed.toList(); //dalla piu recente alla piu vecchia
    if(result.isNotEmpty) {
      return new ListView.builder(
          shrinkWrap: true,
          itemCount: result.length,
          itemBuilder:(BuildContext ctxt, int index) {
            return new ListTile(
              title: new Text(result[index],style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                subtitle:new Divider(),
            );
          }
      );

    }else{
      return new Text("Cronologia vuota");
    }
  }

}

class TabBarDemo extends StatefulWidget {
  const TabBarDemo({Key key}) : super(key: key);
  @override
  _TabBarDemo createState() => new _TabBarDemo();
}

class _TabBarDemo extends State<TabBarDemo> with SingleTickerProviderStateMixin {

  final List<Tab> myTabs = <Tab>[
    Tab(icon: Icon(Icons.text_fields)),
    Tab(icon: Icon(Icons.photo_camera)),
    Tab(icon: Icon(Icons.format_list_bulleted)),
    Tab(icon: Icon(Icons.history)),
    Tab(icon: Icon(Icons.settings)),
  ];


  @override
  void initState() {
    super.initState();
    Context.tabController = new TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    Context.tabController .dispose();
    super.dispose();
  }

  void send(String type,String ip, int port){
    Message m = new Message(Context.getTextArea(), "it_core_news_sm", type);
    Client c = new Client();
    print(ip);
    c.connetti(ip, port, m.toJson().toString()); //10.0.2.2 local ip of machine
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                //aggiungi le icone qua sotto con i tab
                tabs: [
                  Tab(icon: Icon(Icons.text_fields)),
                  Tab(icon: Icon(Icons.photo_camera)),
                  Tab(icon: Icon(Icons.format_list_bulleted)),
                  Tab(icon: Icon(Icons.history)),
                  Tab(icon: Icon(Icons.settings)),

                ],
                controller: Context.tabController ,
              ),
              title: Text('PhotoGram'),

            ),
            body: TabBarView(
              children: [
                // aggiungi le interfaccie associate qua sotto, corrispondo alle tab
                ScrollableArea(),
                Photo(),
                Result(),
                History(),
                Settings(),
              ],
              controller: Context.tabController ,
            ),
            floatingActionButton: new FloatingActionButton(
                elevation: 0.0,
                child: new Icon(Icons.send),
                onPressed:() {
                  if(Context.isGrammaticale()== true) {
                    send('g',Context.getIpSettings(),Context.getPortSettings());
                  }else{
                    send('l',Context.getIpSettings(),Context.getPortSettings());//() => _send() per parametri
                  }
                } )
        ),

      ),
    );
  }
}

class Settings extends StatefulWidget {
  @override
  _Settings createState() {
    return new _Settings();
  }
}

class _Settings extends State<Settings>{

  int _curValue;


  void _handle (int value){

    setState(() {
      _curValue = value;

      switch (_curValue) {
        case 0:
          Context.setGrammaticale(true);
          Context.setLogica(false);
          print("grammaticale");
          break;

        case 1:
          Context.setLogica(true);
          Context.setGrammaticale(false);
          print("logica");
          break;

      }
    });

  }
  @override
  void initState() {
    setState(() {
      _curValue = 0;

      Context.setIpSettings("185.51.138.58") ;
      Context.setPortSettings("6888");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              'Seleziona il tipo di analisi',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
          ),


            new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                new Radio(
                  value: 0,
                  groupValue: _curValue,
                  onChanged: _handle ,
                ),
                new Text(
                  'Grammaticale',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 1,
                  groupValue: _curValue,
                  onChanged: _handle ,
                ),
                new Text(
                  'Logica',
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),

            new Divider(),
            new Text(
              "IP",
              style: new TextStyle(fontSize: 16.0),
            ),
            new TextField(
            controller: Context.ip,
              decoration: InputDecoration(
                  labelText: 'Inserisci ip'
              ),
            ),

            new Divider(),
            new Text(
              "PORT",
              style: new TextStyle(fontSize: 16.0),
            ),
            new TextField(
              controller: Context.port,
              decoration: InputDecoration(
                  labelText: 'Inserisci la porta'
              ),
            )

          ]));
  }

}

///Risultati delle analisi
class Result extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    String text = Client.textFromServer;

    var parole = List<String>();
    var analisi = List<String>();

    /*divido il risultato in maniera tale da avere parole e analisi separate per mostrare i risultati*/

    if(text.compareTo("")==0){
      parole.add("analisi non ancora effettuata");
    }else{
      List<String> lines = text.split('\n');
      List<String> texts= List<String>();

      for(int i = 0; i<lines.length-1;i++){
        texts.add(lines[i].split(':')[0]);
        texts.add(lines[i].split(':')[1]);
      }

      for(int i=0; i< texts.length-1 ; i+=2){
        parole.add(texts[i]);
        analisi.add(texts[i+1]);
      }
    }

    if(text.compareTo("")==0){
      return Text(parole[0], textAlign: TextAlign.center,);
    }else {
      return new ListView.builder(
          shrinkWrap: true,
          itemCount: parole.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new ListTile(
                title: new Text(parole[index].toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                subtitle: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(analisi[index]),
                      new Divider(),
                    ]),
            );
          }
      );
    }
  }


}

class ScrollableArea extends StatelessWidget {  //classe che permetettte di creare widget personalizzzato TODO:guardare utilizzo di StateFullWidget

  ScrollableArea({Key key,});

  @override
  Widget build(BuildContext context) {
    return new SizedBox.expand(
        child: new Container(
          padding: const EdgeInsets.all(8.0),

          child: TextField(
            controller: Context.mycontroller,
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

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController controller;
  String imagePath;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
            ),
          ),
          _captureControlRowWidget(),
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
       );
    }
  }

  /// Display the control bar with buttons to take pictures.
  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        ClipRRect(
        borderRadius: BorderRadius.circular(40.0),
          child:Container(
            color: Colors.blueGrey,
            child:IconButton(
              icon: const Icon(Icons.camera_alt),
              color: Colors.blue,
              onPressed: controller != null &&
                  controller.value.isInitialized
                  ? onTakePictureButtonPressed
                  : null,
            )
          )
        )
      ],
    );
  }

  String timestamp() =>
      DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onTakePictureButtonPressed() async {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
      }
    });

  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_vision';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    FirebaseVisionImage image = FirebaseVisionImage.fromFilePath(filePath);
    TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizer.processImage(image);
    var testo = "";

    for(TextBlock block in readText.blocks)
      for(TextLine line in block.lines)
        for(TextElement element in line.elements)
          testo += element.text;

    testo.replaceAll(new RegExp(r'\n'), '  ');
    print(testo);
    Context.setTextArea(testo);
    Context.tabController.animateTo((Context.tabController .index + 3) % 4);
    return filePath;
  }

  void _showCameraException(CameraException e) {
    //logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

List<CameraDescription> cameras;

class Photo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CameraScreen(),
    );
  }
}


/// classe Client @param: ip, port, text, socket */
class Client{
  String ip;
  int port;
  String textToClient;
  static String textFromServer="";
  Socket socket;

  Client();
  /// si connette al server, invia e riceve

  void connetti(ip,port,textToClient) async{
    this.ip = ip;
    this.port = port;
    this.textToClient = textToClient;
    //connessione
    Socket.connect(this.ip, this.port).then((socket) {
      print('Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}');

      //invio
      print("ok");
      socket.write(textToClient); //'{"lang":"it","type":"g","text":"A Wang piacciono i cani"}'

      //ricevo
      socket.listen((data){
        Map valueMap = json.decode(new String.fromCharCodes(data).trim());
        textFromServer = "";
        valueMap.forEach((parola,analisi) {
          textFromServer += '${parola}: ${analisi}\n';
        });
        //setto la sharedPreferences
        setHistory(textFromServer);

        if(Context.tabController .index == 0) {
          Context.tabController .animateTo(2);
        }

      },
          onDone: () {
            print("Done");
            socket.destroy();//chiudi socket se avvenuta ricezione
          });
    });
  }
  void setHistory(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> s = List<String>();
    for(int i = 0; i<5; i++){
      if(prefs.getString("history" + i.toString())!= null) {
        s.add(prefs.getString("history" + i.toString())); //carico in una lista tutta le ricerche gia salvare nelle shareredPrefences
      }
    }
    s.add(value); //aggiungo la nuova frase da salvare

    if(s.length>=5) { //mostro massimo 5 risultati
      s.removeAt(0);
    }
    setValue(s);
  }

}

class Message {
  final String text;
  final String lang;
  final String type;

  Message(this.text, this.lang, this.type);

  Message.fromJson(Map<String, String> json)
      : text = json[ 'text'],
        lang = json['lang'],
        type = json['type'];

  Map<String, String> toJson() =>
      {
        '"text"': '"'+text+'"',
        '"lang"': '"'+lang+'"',
        '"type"': '"'+type+'"',
      };
}
