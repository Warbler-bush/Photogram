from PGClient import *

fin = open("config.txt","r")

ip = str(fin.readline().splitlines()[0].split(":")[1])
port = int(fin.readline().splitlines()[0].split(":")[1])
print(ip)
print(port)

fin.close()

client = ClientGram(ip, port)
num_client = 1

while not num_client == 0:
	num_client = int(input("num_client:"))
	client.runThread(num_client)
