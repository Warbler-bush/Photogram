import spacy

nlp = spacy.load('it_core_news_sm')
frase = input("inserisci la frase da analizzare: ")
doc = nlp(frase)

print("analisi grammaticale:")
for token in doc:
    #print(token.text, token.lemma_, token.pos_, token.tag_, token.dep_, token.shape_, token.is_alpha, token.is_stop)
    print(token.text, token.tag_)
print("analisi logica:")
for token in doc:
    print(token.text, spacy.explain(token.dep_))