# run nltk.download() from cmd!
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.stem import WordNetLemmatizer
from nltk.corpus import stopwords
import re
from collections import Counter
import glob, os

def run(directory, maxcount):
    lemmatizer = WordNetLemmatizer()
    stops = set(stopwords.words('english'))
    os.chdir(directory)
    result = [];
    count = 0;
    for file in glob.glob('*.txt'):
        if maxcount is not None and maxcount < count:
            return result;
        with open(file, 'r+') as f:
            sentences = sent_tokenize(f.read().lower())  # lower casing and sentence tokenization
            tokens = []
            for s in sentences:
                tokens = tokens + [re.sub('[^A-Za-z0-9]+', '', lemmatizer.lemmatize(t)) for t in word_tokenize(s) if t not in stops]
                tokens = [t for t in tokens if len(t) > 0] #  to-do: optimize regex above, so that we dont need this iteration
            result.append(Counter(tokens))
            count+=1;
    return result

if __name__ == "__main__":
    #  change the path to your file!
    preprocessed = run("D:/enron/pre2006/enron1/ham/",100)
    print(preprocessed)