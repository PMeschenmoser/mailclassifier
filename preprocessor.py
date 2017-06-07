# run nltk.download() from cmd!
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.stem import WordNetLemmatizer
from nltk.corpus import stopwords
import re
from collections import Counter

def run(path):
    lemmatizer = WordNetLemmatizer()
    stops = set(stopwords.words('english'))
    with open(path, 'r+') as f:
        sentences = sent_tokenize(f.read().lower())  # lower casing and sentence tokenization
        tokens = []
        for s in sentences:
            tokens = tokens + [re.sub('[^A-Za-z0-9]+', '', lemmatizer.lemmatize(t)) for t in word_tokenize(s) if t not in stops]
        tokens = [t for t in tokens if len(t) > 0] #  to-do: optimize regex above, so that we dont need this iteration
        return Counter(tokens)

if __name__ == "__main__":
    #  change the path to your file!
    preprocessed = run("C:/Users/Phil/Documents/GitHub/mailclassifier/set/enron1/enron1/ham/0013.1999-12-14.farmer.ham.txt")
    print(preprocessed)