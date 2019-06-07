#importing libraries
#from TextNLP import *
#install phantom js first
import matplotlib.pyplot as plt
import seaborn; seaborn.set_style('whitegrid')
import numpy

from pomegranate import *

class HMM:
    DEFAULT_INPUT_WORDS = "words_test.txt"

    hidden_states = [   "soggetto (esplicito)",
        "predicato verbale",
        "attributo",
        "complem. di qualità",
        "complem. avverbiale di tempo",
        "complem. oggetto",
        "complem. di fine",
        "complem. di vantaggio",
        "complem. di termine",
        "complem. di moto a luogo",
        "complem. di specificazione",
        "complem. di tempo",
        "complem. di mezzo",
        "complem. di modo",
        "complem. di causa",
        "complem. di compagnia",
        "complem. di agente",
        "complem. indiretto"]


    # for hidden state
    def HS_strToInt(self, text):
        return self.hidden_states.index(text)

    # for hidden state
    def HS_intToStr(self, index):
        return self.hidden_states[index]

    def OB_strToInt(self, text):
        return self.words.index(text)

    # for hidden state
    def OB_intToStr(self, index):
        return self.words[index]
    

    def __init__(self):
        self.words = self._read_observations(HMM.DEFAULT_INPUT_WORDS)

        self.model = HiddenMarkovModel()
        emission_prob = DiscreteDistribution(  
                            self._assign_default_prop( 
                                self.words ) )

        states = self._create_default_state( emission_prob ,HMM.hidden_states)
        self.model.add_states(states)
        self._set_default_transition(self.model,states)
        self.model.bake()

    def predict(self,text):
        seq = numpy.array( self._tokenize(text) )
        res = list()
            
        
        hmm_predictions = self.model.predict(seq)
        for x in hmm_predictions:
            res.append( HMM.hidden_states[x] )

        print ("sequence: {}".format(' '.join(seq) ))
        print ("hmm pred: {}".format(' '.join(res) ))
       

        return res


    def _read_observations(self, fname):
        words = list()
        fin = open(fname,"r")
        #line equals to a word
        for line in fin:
            words.append(line.splitlines()[0])

        fin.close()
        return words

    #emission probabilities
    def _assign_default_prop(self, list_hidden_values):
        ret = dict()
        default_prob = 100/len(list_hidden_values)

        for hid_state in list_hidden_values:
            ret[hid_state] = default_prob

        return ret

    def _create_default_state(self, distribution ,hidden_states):
        states = list()
        for hid_state in hidden_states:
            states.append(State(distribution, name = hid_state) )
        return states

    #transition probabilities
    def _set_default_transition(self,model,states):
        #il soggetto e il predicato verbale compaiono solo una volta
        model.add_transition(states[0],states[0],0)
        model.add_transition(states[1],states[1],0)

        default_prior_prob = 100/len(states)
        #la frase può iniziare con qualsiasi elemento dell'analisi logica
        for state in states:
            model.add_transition(model.start,state, default_prior_prob)
        
        #-1 perchè la probabilita che sia lo stesso è 0
        default_transition_prob = 100/len(states)-1
        for state_o in states:
            for state_i in states:
                #dopo un elemento dell'analisi logica non compare mai lo stesso.
                if(state_o.name == state_i.name):
                    model.add_transition(state_o,state_i, 0)
                else:
                    model.add_transition(state_o, state_i,default_prior_prob )

    def _tokenize(self,text):
        return text.split(" ")

    #input: list of observations and labels in words, first the method converts them into a 
    #integer sequence and after the model uses them for training
    def train(self,obs,lbl):
        
        print("fitting obs:",end="")
        print(obs)
        print("fitting lbl:",end="")
        print(lbl)
        dummy_obs = list()
        dummy_lbl = list()
        
        dummy_obs.append(obs)
        dummy_lbl.append(lbl)
        self.model.fit([obs],labels = [lbl],algorithm="viterbi" )

    def save(self, fname):
        fout = open(fname,"w")
        fout.write(self.model.to_json() )
        fout.close()

    
    def load(self,fname):
        fin = open(fname,"r")
        self.model.from_json( fin.read() )
        fin.close()

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time
import random
import sys


def write_on_file(fname,text):
    f = open(fname, "a")
    f.write(text)
    f.close()



class LogicalNotBot:

    def __init__(self):
        pass

    def closeBrowser(self):
        self.driver.close()

    #INPUT/OUTPUT
    #dato in input una frase da analizzare, restituisce
    #i lemmi e la loro rispettiva analisi
    def submit_text(self, text):
        #inizializzazione del driver
        self.driver = webdriver.Chrome()
        driver = self.driver
        driver.get("https://www.analisi-logica.it/Analisi_Logica.php")
        
        input_field =  driver.find_element_by_xpath("//textarea[@name='qwerty']")
        #pulisce la textfield
        input_field.clear()
        #inserisce i dati nella textfield
        input_field.send_keys(text)

        btnSubmit = driver.find_element_by_xpath("//input[@id='cliccami_ALG']")
        btnSubmit.click()

        #aspetta finchè il sito non ha finito di analizzare
        tbnTable = None
        while(not tbnTable):
            try:
                tbnTable = driver.find_element_by_xpath("//table[@id='INVALSI']")
            except:
                tbnTable = None

        #estrazione dell'analisi
        print("-------------------------\n\n")
        print(tbnTable)
        print("-------------------------\n\n")
        tRows = tbnTable.find_elements_by_xpath(".//tr")

        observed = list()
        states = list()
        counter = 0
        for row in tRows:
            tCols = row.find_elements_by_xpath(".//td[text()]")
            for col in tCols:
                if(counter == 0):
                    observed.append(col.text.replace("\n"," "))
                    print(col.text)
                if(counter == 1):
                    states.append(col.text.replace("\n"," "))
                    print(col.text)
                counter += 1
                counter %= 3


        return observed,states

    

