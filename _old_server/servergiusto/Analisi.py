import spacy
import json

class Analisi:
    def __init__(self, lingua):
        self.testo = None
        self.nlp = spacy.load(lingua)

    def setTesto(self, testo):
        self.testo = testo

    def getTesto(self):
        return self.testo

    def analisiGrammaticale(self, testo):
        self.testo = testo
        self.doc = self.nlp(self.testo)

        data = {}
        for token in self.doc:
            data[token.text] = token.tag_
            json_data = json.dumps(data)

        return json_data

    def analisiLogica(self, testo):
        self.testo = testo
        self.doc = self.nlp(self.testo)

        data = {}
        for token in self.doc:
            data[token.text] = token.dep_
            json_data = json.dumps(data)

        return json_data

    def analisiPoetica(self, testo):
        self.testo = testo
        self.doc = self.nlp(self.testo)
        # TODO
        return "TODO"
