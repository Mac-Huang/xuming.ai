import string
import sys
import math


def get_parameter_vectors():
    '''
    This function parses e.txt and s.txt to get the  26-dimensional multinomial
    parameter vector (characters probabilities of English and Spanish) as
    described in section 1.2 of the writeup

    Returns: tuple of vectors e and s
    '''
    #Implementing vectors e,s as lists (arrays) of length 26
    #with p[0] being the probability of 'A' and so on
    e=[0]*26
    s=[0]*26

    with open('e.txt',encoding='utf-8') as f:
        for line in f:
            #strip: removes the newline character
            #split: split the string on space character
            char,prob=line.strip().split(" ")
            #ord('E') gives the ASCII (integer) value of character 'E'
            #we then subtract it from 'A' to give array index
            #This way 'A' gets index 0 and 'Z' gets index 25.
            e[ord(char)-ord('A')]=float(prob)
    f.close()

    with open('s.txt',encoding='utf-8') as f:
        for line in f:
            char,prob=line.strip().split(" ")
            s[ord(char)-ord('A')]=float(prob)
    f.close()

    return (e,s)
    
def shred(filename):
    '''
    This function parses a .txt file into a dict of character counts, where
    the input file may contain any printable ASCII characters and can be short 
    (e.g. a single word) or long (e.g. an article). Ignores case, i.e. merges 
    'A' and 'a' counts together, and so on (this is known as case-folding). 
    Only counts characters A to Z (after case-folding), ignoring all other 
    characters such as space, punctuations, etc.

    Sample Input/Output functionality:
    Input: "Hi! I'll go :-)"
    Output: {'A': 0, 'B': 0, 'C': 0, 'D': 0, 'E': 0, 'F': 0,
             'G': 1, 'H': 1, 'I': 2, 'J': 0, 'K': 0, 'L': 2,
             'M': 0, 'N': 0, 'O': 1, 'P': 0, 'Q': 0, 'R': 0,
             'S': 0, 'T': 0, 'U': 0, 'V': 0, 'W': 0, 'X': 0,
             'Y': 0, 'Z': 0}

    Returns: dict of character counts
    '''

    boc=dict()
    with open (filename,encoding='utf-8') as f:
        corpus=f.read()
    f.close()
    #convert all lowercase alphabets to uppercase
    corpus=corpus.upper()
    #initialize X
    for a in string.ascii_uppercase:
        boc[a]=0
    for c in corpus:
        if c in string.ascii_uppercase:
            boc[c]+=1
    return boc


def main():
    # Get the letter file, english and spanish prior
    letter_file = sys.argv[1]
    english_prior = float(sys.argv[2])
    spanish_prior = float(sys.argv[3])

    counts = shred(letter_file)
    e, s = get_parameter_vectors()

    #Q1
    print("Q1")
    print(f"{counts['A'] * math.log(e[0]):.4f}")
    print(f"{counts['A'] * math.log(s[0]):.4f}")

    #Q2
    english_score = math.log(english_prior)
    spanish_score = math.log(spanish_prior)

    for i, letter in enumerate(string.ascii_uppercase):
        english_score += counts[letter] * math.log(e[i])
        spanish_score += counts[letter] * math.log(s[i])

    print("Q2")
    print(f"{english_score:.4f}")
    print(f"{spanish_score:.4f}")

    #Q3
    difference =  spanish_score - english_score
    if difference >= 100:
        score = 0
    elif difference <= -100:
        score = 1
    else:
        score = 1 / (1 + math.exp(difference))

    print("Q3")
    print(f"{score:.4f}")


if __name__ == "__main__":
    main()  
