import socket
import _thread


class ClientGram:

    def __init__(self, ip, port):
        self.ip = ip
        self.port = port

    def runThread(self, n):
        for x in range(1, n):
            print("Ok")
            _thread.start_new_thread(self.rispondi, (str(x),))

    def rispondi(self, id):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        HOST = self.ip
        print("host:" + HOST + "\n")
        PORT = self.port  # The port used by the server
        sock.connect((HOST, PORT))
        print("trying connecting the server\n" + id)
        sock.send(("ciao sono simoclient " + id + "\n").encode('utf-8'))
        print("sto ricevendo...")
        data = sock.recv(1024)
        print(data.decode('utf-8') + "\n")
        sock.close()
        print("connessione chiusa")
