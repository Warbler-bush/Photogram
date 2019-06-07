#inizializzazione del Bot dello scraping
scraping = LogicalNotBot()
#inizializzazione dell'AI
model = HMM()
#caircamento dello stato vecchio dell'AI
model.load("model.txt")
text = ""

while( 1 ):
    text= input("inserisci il testo:")
    
    #possibile futura implementazione di una shell per il testing
    if(text == ".exit"):
        break

    #scraping dell'analisi su internet
    #il risultato viene mostrato quando l'AI fallisce
    #e utilizzato per addestrare quest'ultimo
    observed, states = scraping.submit_text(text)
    
    # l'AI prova a ottenere un risultato e si addestra
    # solo e solo se non è presente una parola nel dizionario 
    # l'AI aggiunge le parole sconosciute nel dizionario
    # e al prossimo riavvio del programma le incorporerà

    try:
        model.train(observed,states)
        model.predict(text)
    except:
        seq = model._tokenize(text)
        unknown_observs = ""
        for x in seq:
            if(x not in model.words):
                unknown_observs = unknown_observs +  x + "\r\n"
                print("not present: "+ x)
        unknown_observs = unknown_observs[0:len(unknown_observs) - 1 ]
        write_on_file(HMM.DEFAULT_INPUT_WORDS,unknown_observs )
        print("presente parola sconosciuta:"+unknown_observs)
    
   #scraping.closeBrowser()

model.save("model.txt")