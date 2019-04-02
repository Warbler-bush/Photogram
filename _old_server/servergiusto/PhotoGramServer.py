import socket
import _thread
import json
from Analisi import Analisi


class ServerGram:
    # var socket
    # var port
    # var isDisconnect
    def __init__(self, port):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.port = port
        self.isDisconnect = False
        host = "0.0.0.0"
        self.sock.bind((host, port))  # Bind to the port
        self.sock.listen(7)
        print("Server online e pronto ad accettare client")

    """ accetta() 
		accetta più connessioni dai client 
		e avvia dei thread che rispondono 
	"""

    def accetta(self):
        while not self.isDisconnect:
            conn, addr = self.sock.accept()  # Establish connection with client.
            print("connessione stabilita\n")
            _thread.start_new_thread(self.rispondi, (conn,))

    """ 
		rispondi(conn)
		risponde a un client che si è appena connesso 
		e poi chiude la connessione
	"""

    def rispondi(self, conn):

        print("Sto ricevendo...")
        msg = conn.recv(1024)
        print(msg.decode('utf-8') + "\n")
        json_in = json.loads(msg)
        analisi = Analisi(json_in["lang"])

        if (json_in["type"] == "g"):
            output = analisi.analisiGrammaticale(json_in["text"])
        elif (json_in["type"] == "l"):
            output = analisi.analisiLogica(json_in["text"])
        elif (json_in["type"] == "p"):
            output = analisi.analisiPoetica(json_in["text"])
        else:
            output = "vaffanculo"

        print("Sto rispondendo...")

        conn.send(str(output).encode('utf-8'))
        print("ok\n")
        conn.shutdown(socket.SHUT_RDWR)
        print("closing...")


"""ParseIn

parsifica il json inviato dal client 
composto da : lang type text

"""


class ParserIn:
    # lang
    # type of analysis (p,l,g)
    # text
    # json
    def __init__(self, jsonIn):
        self.lang = None
        self.type = None
        self.text = None
        self.jsonIn = jsonIn

    def setJson(self, jsonIn):
        self.jsonIn = jsonIn

    def parse(self):
        j = json.loads(self.jsonIn)
        self.lang = j["lang"]
        self.type = j["type"]
        self.text = j["text"]
