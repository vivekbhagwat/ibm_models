#Vivek Bhagwat vsb2110 hw2 NLP

module Homework2
  
  class Question1
    attr_accessor :english_words, :german_words, :t
    
    #no idea what input/output is
    def em_algorithm
      puts "blah"
    end

    def init(english_file, german_file)
      #provides number of each word
      @english_words = Hash.new(0)
      @german_words = Hash.new(0)
      @t = Hash.new(0.0)
      # raise "wtf" if @english_words.nil?
      # @english_words = Hash.new(0)
      
      #get counts of english words
      File.open(english_file, 'r') do |file|
        while line=file.gets
          words = line.to_s.split(' ')
          words.each do |word|
            @english_words[word.to_s] += 1
          end
        end
      end
      puts 'finished english file parsing'
  
      #get counts of german words
      File.open(german_file, 'r') do |file|
        while line=file.gets
          words = line.to_s.split(' ')
          words.each do |word|
            @german_words[word.to_s] += 1
          end
        end
      end
      puts 'finished german file parsing'
  
      #should NULL be included? is this even right?
      num = @english_words.size
      
      puts 'starting initial filling in of t at ' + Time.new.inspect
      @english_words.each do |e|
        @german_words.each do |f|
          @t[f.to_s + '|' + e.to_s] = 1 / num
        end
      end
      puts 'finished initial filling in of t at ' + Time.new.inspect
      
    end
    
    def bullet2(dev_file)
      1.upto(5) do
        em_algorithm
      end
      
      k_best_foreign(dev_file)
    end

    #bullet 2 part 2
    def k_best_foreign(dev_file, k=10)
      dev_words = []
      File.open(dev_file, 'r') do |word|
        dev_words << word.to_s
      end
    
      #for each word, print list of k highest
      dev_words.each do |word|
        k_highest = Array.new(k)
      
        #go through each german word
        @german_words.each do |f|
          prob = @t[f.to_s + '|' + word]
          if k_highest.size < k
            k_highest << prob
          else
            if prob > k_highest[0]
              k_highest[0] = prob
            end
          end
          k_highest.sort!
        end
        
        #english: french_1, french_2, ... french_k
        puts word + ": " + k_highest.inspect #prints list
      end
    end
    
    def sentence_alignments(f_sentence=[], e_sentence=[])
      alignments = []
      
      f_sentence.each_with_index do |f,i|
        max_alignment = 0
        max_prob = 0

        e_sentence.each_with_index do |e,j|
          if @t[f.to_s+'|'+e.to_s] > max_prob
            max_prob = @t[f.to_s+'|'+e.to_s]
            max_alignment = j
          end          
        end

        alignments << max_alignment
      end
      
      return alignments
    end
    
    def bullet3(english_file, german_file, n=20)
      english_sentences = []
      german_sentences = []
      
      i = 0
      File.open(english_file, 'r') do |line|
        english_sentences << line.to_s.split(' ') if i < n        
        i+=1
      end
      
      i = 0
      File.open(german_file, 'r') do |line|
        german_sentences << line.to_s.split(' ') if i < n
        i+=1
      end
      
      1.upto(n) do |i|
        f_sentence = german_sentences[i]
        e_sentence = english_sentences[i]
        
        alignments = sentence_alignments(f_sentence, e_sentence)
        
        p alignments
      end
    end
    
  end

  module Question2
  
  end
end

# Homework2::Question1.init('corpus.en', 'corpus.de')

q1 = Homework2::Question1.new
q1.init('corpus.en', 'corpus.de')
p q1.english_words