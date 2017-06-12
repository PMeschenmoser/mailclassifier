# run nltk.download() from cmd!
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.stem import WordNetLemmatizer
from nltk.corpus import stopwords
import re
from collections import Counter


def run(paths):
    lemmatizer = WordNetLemmatizer()
    stops = set(stopwords.words('english'))
    result = [];
    for file in paths:
        with open(file, 'r') as f:
            init = re.sub(r'\d+', '',f.read().lower())
            sentences = sent_tokenize(init)  # lower casing and sentence tokenization
            tokens = []
            for s in sentences:
                tokens = tokens + [re.sub('[^A-Za-z0-9]+', '', lemmatizer.lemmatize(t)) for t in word_tokenize(s) if t not in stops]
                tokens = [t for t in tokens if len(t) > 0] #  to-do: optimize regex above, so that we dont need this iteration
            result.append(dict(Counter(tokens)))
    return result