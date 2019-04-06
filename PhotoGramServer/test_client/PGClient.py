import socket
import _thread


class ClientGram:

    def __init__(self, ip, port):
        self.ip = ip
        self.port = int(port)

    def runThread(self, n,msg):
        for x in range(1, n):
            print("Ok")
            _thread.start_new_thread(self.request, (str(x),msg,))

    def request(self, id, msg):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        HOST = self.ip
        print("host:" + HOST + "\n")
        PORT = self.port  # The port used by the server
        sock.connect((HOST, PORT))
        print("trying connecting the server\n" + id)
        sock.send((msg).encode('utf-8'))
        print("sto ricevendo...")
        data = sock.recv(1024)
        print(data.decode('utf-8') + "\n")
        sock.close()
        print("connessione chiusa")


class ParserOut:
    @staticmethod
    def parse(lang, _type, text ):
        return "{ \"lang\":\"%s\",\"type\":\"%s\",\"text\":\"%s\" }" % (lang, _type, text)
