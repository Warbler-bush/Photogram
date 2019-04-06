from PGClient import *
import time

fin = open("config.txt","r")

ip = str(fin.readline().splitlines()[0].split(":")[1])
port = int(fin.readline().splitlines()[0].split(":")[1])
print(ip)
print(port)

fin.close()

client = ClientGram(ip, port)
num_client = 1
_type = "q"
#test str : "{ \"lang\":\"it\",\"type\":\"g\",\"text\":\"a wang piacciono i cani\" }"
while True:
	#num_client = int( input("num_client:") )
	print("type{g,l,p,e}:",end="")
	_type = input()
	if ( _type == "e"): 
		client.close()
		break
	
	
	print("msg:",end="")
	msg = input()
	
	#client.reconnect(ip,port)
	client.send(ParserOut.parse("ita", _type ,msg))
	#DoS
	#ClientGram.runThread(num_client, ParserOut.parse("ita",_type ,msg) )
	resp = client.receive()
	print(resp)
	#client.close()
	print("----------------------")
	client.reconnect(ip,port)
	

client.close()