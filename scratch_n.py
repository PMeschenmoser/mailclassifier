import string
import nltk
from nltk import PorterStemmer
lemma = nltk.wordnet.WordNetLemmatizer()
text= "permissions"
#print(lemma.lemmatize(text))
stemmer = PorterStemmer()

special_char_list = [':', ';', '?', '}', ')', '{', '(']

f= open("/home/matte/mailclassifier/set/enron1/enron1/ham/0027.1999-12-17.farmer.ham.txt", "r+")
t=f.read()
lower = []
token = []
lower = t.lower()

token = nltk.word_tokenize(lower)

special_char_list = [':', ';', '?', '}', ')', '{', '(','%','$','.',',']
for special_char in special_char_list:
    no_symbol = lower.replace(special_char, '')
#print no_symbol
stem = stemmer.stem(no_symbol)
print stem
words = []
new = []
words = no_symbol.split()
print words
new = map(lemma.lemmatize, words)
print new
#print '\n'.join(new)