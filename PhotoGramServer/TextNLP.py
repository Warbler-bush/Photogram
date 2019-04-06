import spacy
import json


IT_LANG = "it"
EN_LANG = "en_core_web_sm"

GRAMMATICAL = "g"
LOGICAL = "l"
POETIC = "p"

#NLP -> natural language processing
class TextNLP:
    def __init__(self):
        pass

    def analysis(self, _type,text):
        if( _type == GRAMMATICAL ):
            output = self.analysisGram(text)
        elif ( _type == LOGICAL ):
            output = self.analysisLogic(text)
        elif ( _type == POETIC ):
            output = self.analysisPoe(text)
        else:
            output = "vaffanculo"

        return output

    def _GramProcessing(self, text):
        self.doc = self.nlp(text)

        data = {}
        for token in self.doc:
            data[token.text] = token.tag_
            json_data = json.dumps(data)

        return json_data

    def _LogicalProcessing(self, text):
        self.doc = self.nlp(text)

        data = {}
        for token in self.doc:
            data[token.text] = token.dep_
            json_data = json.dumps(data)

        return json_data

    def _PoeProcessing( self, text ):
        self.doc = self.nlp(text)
        # TODO Poetic Processing
        return "TODO"


class ItNLP(TextNLP):
    def __init__(self):
        self.nlp = spacy.load(IT_LANG)
        self.load_data()
    # da formattare

    def load_data(self):
        fin = open("data_it")
        line = 

    def analysisGram(self,text):
        row = self._GramProcessing(text)
        #
        #
        #
        #
        #
        #
        #
        #
        return formated

    # da formattare
    def analysisLogic(self,text):
        row = self._LogicalProcessing(text)
        formated = row
        return formated

    def analysisPoe(self,text):
        row = self._PoeProcessing(text)
        formated = row
        return formated

class EnNLP(TextNLP):
    def __init__(self):
        self.nlp = spacy.load(EN_LANG)

    def analysisGram(self,text):
        row = self._GramProcessing(text)
        formated = row
        return formated

    def analysisLogic(self,text):
        row = self._LogicalProcessing(text)
        return formated

    def analysisPoe(self,text):
        row = self._PoeProcessing(text)
        formated = row
        return formated