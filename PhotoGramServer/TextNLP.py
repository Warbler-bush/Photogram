import spacy
import json


IT_LANG = "it_core_news_sm"
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
    p_artis = None
    def __init__(self):
        self.nlp = spacy.load(IT_LANG)
        #preposizioni articolate
        ItNLP.p_artis = self.load_data()
        # nmod  -> dopo il case
        # amod -> aggettivo


    # da formattare

    def load_data(self):
        fin = open("data_it")
        mydict = dict()
        for line in fin:
            line = fin.readline().splitlines()[0]
            if(line[0] == "#"):
                continue
            
            row = line.split(";")
            for element in row:
                pair = element.split("=")
                mydict[ pair[0] ] = pair[1]
        
        fin.close()
        return mydict

    def analysisGram(self,text):
        row = self._GramProcessing(text)
        formated = row
        return formated

    # in realtà le ripetizioni di una parola non viene considerata
    # dunque fare restituire l'analisi diretta sarebbe scorretto
    # bensì si deve scorrere la frase di nuovo per poi assegnare ad ogni
    # pezzo il suo ruolo nella frase
    def analysisLogic(self,text):
        text = self._preProcLogicalText(text)
        row = self._LogicalProcessing(text)
        formated = row
        return formated

    @staticmethod
    def _preProcLogicalText(text):
        #cerca preposizioni articolate
        for index, value in ItNLP.p_artis.items():
            text = text.replace(index, value)
        return text

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
