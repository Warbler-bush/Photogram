from PhotoGramServer import ParserIn

x = '{ "lang":"ita", "type":"grammar", "text":"Un testo da inviare"}'

parser = ParserIn(x)
parser.parse()
print(parser.lang)
print(parser.type)
print(parser.text)
