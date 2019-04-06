import socket
import _thread


class ClientGram:


    def __init__(self, ip, port):
        self.ip = ip
        self.port = int(port)
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        
        
        self.sock.connect((self.ip, self.port))
        print("trying to connecting the server\n")

    def send(self,request):
        print("sending")
        self.sock.send((request).encode('utf-8'))
        
    def receive(self):
        print("receving...")
        data = self.sock.recv(1024)
        return data 
    def close(self):
        self.sock.close()

    def reconnect(self,ip,port):
        self.close()
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.connect((self.ip, self.port))
        

    @staticmethod
    def runThread( n,msg):
        for x in range(1, n):
            print("ok")
            _thread.start_new_thread(ClientGram.request, (str(x),msg,))

    @staticmethod
    def request(ip,port ,id, msg):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        HOST = ip
        PORT = port  # The port used by the server
        print("host:" + HOST + "\n")
        print("port:" + PORT + "\n")
        sock.connect((HOST, PORT))
        print("trying to connecting the server\n" + id)
        sock.send((msg).encode('utf-8'))
        print("receving...")
        data = sock.recv(1024)
        print(data.decode('utf-8') + "\n")
        sock.close()
        print("connection closed")
    
class ParserOut:
    @staticmethod
    def parse(lang, _type, text ):
        return "{ \"lang\":\"%s\",\"type\":\"%s\",\"text\":\"%s\" }" % (lang, _type, text)
