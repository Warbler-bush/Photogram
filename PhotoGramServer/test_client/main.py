from PGClient import *
import time

IT_LANG = "it_core_news_sm"
EN_LANG = "en_core_web_sm"

fin = open("config.txt","r")

ip = str(fin.readline().splitlines()[0].split(":")[1])
port = int(fin.readline().splitlines()[0].split(":")[1])
print(ip)
print(port)

fin.close()

client = ClientGram(ip, port)
num_client = 1
_type = "q"
#test str : "{ \"lang\":\"it\",\"type\":\"g\",\"text\":\"a luca piacciono i cani\" }"
while True:
	client.reconnect(ip,port)
	#num_client = int( input("num_client:") )
	print("type{g,l,p,e}:",end="")
	_type = input()
	
	
	
	print("msg:",end="")
	if( not _type == "e"):
		msg = input()
	else:
		msg = "Chiudi Server"
	#client.reconnect(ip,port)
	client.send(ParserOut.parse(IT_LANG, _type ,msg))
	#DoS
	#ClientGram.runThread(num_client, ParserOut.parse("ita",_type ,msg) )
	resp = client.receive()
	print(resp)
	#client.close()
	print("----------------------")
	if ( _type == "e"): 
		client.close()
		break
