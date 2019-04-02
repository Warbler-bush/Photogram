import socket
import _thread
import json

from TextNLP import *



class ServerGram:
    # var socket
    # var port
    # var isDisconnect
    LO_IP   = "127.0.0.1"
    HOST_IP = "0.0.0.0"
    DEFAULT_NUM_LIST = 7

    def __init__(self, port, lo):
        # init the english NLP and the italian NLP
        self.itNLP = ItNLP()
        self.enNLP = EnNLP()

        # init the socket
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.port = port
        self.isDisconnect = False
        
        if(not lo):
            host = ServerGram.HOST_IP
        else:
            host = ServerGram.LO_IP

        self.sock.bind((host, port))  # Bind to the port
        self.sock.listen( ServerGram.DEFAULT_NUM_LIST )
        print("Server online e pronto ad accettare client")        

    """ accetta() 
		accetta più connessioni dai client 
		e avvia dei thread che rispondono 
	"""

    def accetta(self):
        while not self.isDisconnect:
            conn, addr = self.sock.accept()  # Establish connection with client.
            print("connessione stabilita")
            _thread.start_new_thread(self.rispondi, (conn,))

    """ 
		rispondi(conn)
		risponde a un client che si è appena connesso 
		e poi chiude la connessione
	"""

    def rispondi(self, conn):
        # formato che ricevo in stringa
        # { "lang":"it","type":"g","text":"a wang piacciono i cani" }
        print("Sto ricevendo...")
        msg = conn.recv(1024)
        print("messaggio ricevuto: \n"+ msg.decode('utf-8') + "\n")

        #ParseIn.parse(msg) -> return a CPGPacket
        #client packet
        cPacket = ParserIn.parse(msg)

        lan = cPacket.getLang()
        atype = cPacket.getType()
        text = cPacket.getText()

        curNLP = self.enNLP if lan == EN_LANG else self.itNLP
        
        output = curNLP.analysis(atype , text )
        print("Sto rispondendo...")
        
        conn.send(str(output).encode('utf-8'))
        
        print("ok\n")
        
        conn.shutdown(socket.SHUT_RDWR)
        print("closing...")

# the date that sends the client to server
# CPG = client photogram 
class CPGPacket:
    # lang : string { "en" | it }
    # type : char   { "g" | "l" | "p" } 
    # text : string { regex }
    
    # TODO: controlli sulle variabili. lang 
    def __init__(self, lang, text_type, text):
        self.lang = lang
        self.type = text_type
        self.text = text

    def getLang(self):
        return self.lang

    def getType(self):
        return self.type

    def getText(self):
        return self.text

"""ParseIn

parsifica il json inviato dal client 
composto da : lang type text

"""

class ParserIn:
    @staticmethod
    def parse(jsonMsg):
        dictJson = json.loads(jsonMsg)
        return CPGPacket(str(dictJson["lang"]) ,str( dictJson["type"]), str(dictJson["text"]) )
