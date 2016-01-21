require 'set'

class Spellchecker

  ALPHABET = 'abcdefghijklmnopqrstuvwxyz'

  #constructor.
  #text_file_name is the path to a local file with text to train the model (find actual words and their #frequency)
  #verbose is a flag to show traces of what's going on (useful for large files)
  def initialize(text_file_name)
    #read file text_file_name
    #extract words from string (file contents) using method 'words' below.
    #put in dictionary with their frequency (calling train! method)
    @frequency = Hash.new(0)
    File.open(text_file_name) do |f|
      f.each_line do |line|
        words = line.split(' ')
        train!(words)
      end
    end
    puts lookup('ruby')
  end

  def dictionary
    #getter for instance attribute
    return @frequency
  end
  
  #returns an array of words in the text.
  def words (text)
    return text.downcase.scan(/[a-z]+/) #find all matches of this simple regular expression
  end

  #train model (create dictionary)
  def train!(word_list)
    #create @dictionary, an attribute of type Hash mapping words to their count in the text {word => count}. Default count should be 0 (argument of Hash constructor).
    word_list.each { |word| @frequency[word.downcase] += 1 }
  end

  #lookup frequency of a word, a simple lookup in the @dictionary Hash
  def lookup(word)
    return @frequency[word]
  end
  
  #generate all correction candidates at an edit distance of 1 from the input word.
  def edits1(word)
    
    #all strings obtained by deleting a letter (each letter)
    deletes    = []
    i = 0
    while i < word.length
      deletes_word = word
      deletes << deletes_word.slice(0,i) + deletes_word.slice(i+1, word.length)
      i+=1
    end
    #all strings obtained by switching two consecutive letters
    transposes = []
    while i < word.length-1
      transposes_word = word
      transposes << transposes_word.tr(transposes_word[i], transposes_word[i+1])
    end
    # all strings obtained by inserting letters (all possible letters in all possible positions)
    
    inserts = []
    while i < word.length
      inserts_word = word
      ALPHABET.split(//).each do |character|
        inserts_word.insert(i,character)
        inserts << inserts_word
      end 
    end

    #all strings obtained by replacing letters (all possible letters in all possible positions)
    replaces = []
    while i < word.length
      replaces_word = word
      ALPHABET.split(//).each do |character|
        replaces_word[i] = character
        replaces << replaces_word
      end
    end
    

    return (deletes + transposes + replaces + inserts).to_set.to_a #eliminate duplicates, then convert back to array
  end
  

  # find known (in dictionary) distance-2 edits of target word.
  def known_edits2 (word)
    # get every possible distance - 2 edit of the input word. Return those that are in the dictionary.

  end

  #return subset of the input words (argument is an array) that are known by this dictionary
  def known(words)
    return words.find_all {true } #find all words for which condition is true,
                                    #you need to figure out this condition
    
  end


  # if word is known, then
  # returns [word], 
  # else if there are valid distance-1 replacements, 
  # returns distance-1 replacements sorted by descending frequency in the model
  # else if there are valid distance-2 replacements,
  # returns distance-2 replacements sorted by descending frequency in the model
  # else returns nil
  def correct(word)
    if known(word) [then]
      return word
  end  
end