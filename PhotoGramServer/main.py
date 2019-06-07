from ServerGram import ServerGram
import _thread

port = 6888

server = ServerGram(port,True)
server.accetta()

while not server.isDisconnect:
    conn, addr = server.accetta()  # Establish connection with client.
    print("connessione stabilita")
    _thread.start_new_thread( server.rispondi, (conn,)  )
