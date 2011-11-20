#Vivek Bhagwat vsb2110 hw2 NLP

module Homework2
  
  class Question1
    attr_accessor :english_words, :german_words, :t, :english_file, :german_file, 
      :english_sentences, :german_sentences
    
    #no idea what input/output is
    def em_algorithm
      puts "blah"
      
      
      
    end

    def initialize(english, german)
      @english_file = english
      @german_file = german
      #provides number of each word
      @english_words = Hash.new(0)
      @german_words = Hash.new(0)
      @t = {}
      
      @english_sentences = []
      @german_sentences = []
      # raise "wtf" if @english_words.nil?
      # @english_words = Hash.new(0)
      
      #get counts of english words
      File.open(@english_file, 'r') do |file|
        while line=file.gets
          words = line.to_s.split(' ')
          @english_sentences << words
          words.each do |word|
            @english_words[word.to_s] += 1
          end
        end
      end
      puts 'finished english file parsing'
  
      #get counts of german words
      File.open(@german_file, 'r') do |file|
        while line=file.gets
          words = line.to_s.split(' ')
          @german_sentences << words
          words.each do |word|
            @german_words[word.to_s] += 1
          end
        end
      end
      puts 'finished german file parsing'
  
      #should NULL be included? is this even right?
      num = @english_words.size
      
      puts 'starting initial filling in of t at ' + Time.new.inspect
      @english_words.keys.each do |e|
        @t[e.to_s] = Hash.new(0.0)
        @german_words.keys.each do |f|
          @t[e.to_s][f.to_s] = 1./num.to_f
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
      File.open(dev_file, 'r') do |file|
        while(word = file.gets)
          dev_words << word.to_s
        end
      end
    
      #for each word, print list of k highest
      dev_words.each do |word|
        word.chomp!
        k_highest = Array.new
      
        #go through each german word
        @german_words.keys.each do |f|
          @t[word] = Hash.new(0.0) if @t[word].nil?
          prob = @t[word][f.to_s]
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
          if @t[e.to_s][f.to_s] >= max_prob
            max_prob = @t[e.to_s][f.to_s]
            max_alignment = j
          end          
        end

        alignments << max_alignment
      end
      
      return alignments
    end
    
    def bullet3(n=20)      
      n.times do |i|
        f_sentence = @german_sentences[i]
        e_sentence = @english_sentences[i]
        
        alignments = sentence_alignments(f_sentence, e_sentence)
        
        p alignments
      end
    end
    
  end

  module Question2
  
  end
end

# Homework2::Question1.init('corpus.en', 'corpus.de')
en = 'corpus_small.en'
de = 'corpus_small.de'

q1 = Homework2::Question1.new(en,de)
q1.bullet2('devwords.txt')
q1.bullet3