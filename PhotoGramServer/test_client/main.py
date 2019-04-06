from PGClient import *

fin = open("config.txt","r")

ip = str(fin.readline().splitlines()[0].split(":")[1])
port = int(fin.readline().splitlines()[0].split(":")[1])
print(ip)
print(port)

fin.close()

client = ClientGram(ip, port)
num_client = 1
#test str : "{ \"lang\":\"it\",\"type\":\"g\",\"text\":\"a wang piacciono i cani\" }"
while not num_client == 0:
	num_client = int( input("num_client:") )
	print("msg:",end="")
	msg = input()
	print("")
	client.runThread(num_client, ParserOut.parse("ita","g",msg) )
	print("----------------------")
