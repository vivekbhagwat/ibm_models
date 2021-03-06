#Vivek Bhagwat vsb2110 hw2 NLP

module Homework2
  
  class Question1
    attr_accessor :possible_pairs, :english_words, :german_words, :t, :english_file, :german_file, 
      :english_sentences, :german_sentences, :counts
    
    #no idea what input/output is
    def em_algorithm
      n = @english_sentences.size
      @counts = Hash.new(0)
      
      raise "ASDFAKSJDFA" unless @english_sentences.size == @german_sentences.size
      
      # delta = {}
      n.times do |k|        
        eng = @english_sentences[k]
        ger = @german_sentences[k]
        
        #lines for figuring out time
        
        ger.each_with_index do |f, i|
          eng.each_with_index do |e, j|
            
            sum = 0.0
            eng.each do |e_word|
              sum += @t[e_word][f]
            end
            # raise "#{sum}, #{f}, #{eng}"
            
            raise "#{e}, #{f} #{@t[e][f]}, #{counts[e]}" if sum == 0.0
            
            

            # key_kij = k.to_s + ' ' + i.to_s + ' ' + j.to_s
            # delta[ key_kij ]
            delta = @t[e][f].to_f / sum
            
            key_ef = e + ' ' + f
            @counts[ key_ef ] += delta#[ key_kij ]
            @counts[ e ] += delta#[ key_kij ]
              # @counts[key_jilm] += delta
              # @counts["#{i} #{l} #{m}"] += delta
            
            # @t[e][f] = @counts[key_ef] / @counts[e]
            
            raise "#{sum}" if @t[e][f].nan?
          end
        end
        
      end
      
      @t.keys.each do |e|
        @t[e].keys.each do |f|
          @t[e][f] = @counts[e+' '+f] / @counts[e]
        end
      end
    end

    def initialize(english, german)
      @english_file = english
      @german_file = german
      #provides number of each word
      # @english_words = Hash.new(0)
      # @german_words = Hash.new(0)
      @possible_pairs = Hash.new
      
      
      @t = {}
      
      @english_sentences = []
      @german_sentences = []
      # raise "wtf" if @english_words.nil?
      # @english_words = Hash.new(0)
      
      File.open(@english_file, 'r') do |file_e|
        File.open(@german_file, 'r') do |file_g|
          while line_e=file_e.gets
            line_g = file_g.gets
            
            @english_sentences << line_e.to_s.split(' ')
            @german_sentences << line_g.to_s.split(' ')
            
            @english_sentences.last.each do |word_e|
              @possible_pairs[word_e] = Hash.new if @possible_pairs[word_e].nil?
              @german_sentences.last.each do |word_g|
                  @possible_pairs[word_e][word_g] = true
              end
            end
          end
        end
      end
  
      #should NULL be included? is this even right?
      
      # puts 'starting initial filling in of t at ' + Time.new.inspect
      @possible_pairs.keys.each do |e|
        @t[e.to_s] = Hash.new(0.0)
        num = @possible_pairs[e].size
        @possible_pairs[e].keys.each do |f|
          @t[e.to_s][f.to_s] = 1. / num.to_f
          # raise num.to_s if @t[e.to_s][f.to_s].to_f.nan?
          # raise "e: #{e}, f: #{f}, num: #{num}" if f == 'wir' && e == 'mediator'
        end
      end
      # puts 'finished initial filling in of t at ' + Time.new.inspect      
      # p @t
    end
    
    def bullet2(dev_file)
      1.upto(5) do |i|
        # p Time.now
        # p i
        # puts ''
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
        k_highest_words = Array.new
        
        @possible_pairs[word] = {} unless @possible_pairs[word]
        
        #go through each german word
        @possible_pairs[word].keys.each do |f|
          @t[word] = Hash.new(0.0) if @t[word].nil?
          prob = @t[word][f.to_s].to_f
          
          min_index = min_index(k_highest)
          
          if k_highest.size < k
            k_highest << prob
            k_highest_words << f.to_s
          else
            if prob > k_highest[min_index]
              k_highest[min_index] = prob
              k_highest_words[min_index] = f.to_s
            end
          end
          # k_highest.sort!
        end
        
        #english: french_1, french_2, ... french_k
        highest = []
        k_highest.size.times do |i| highest << [k_highest[i], k_highest_words[i]] end        
        
        highest.sort! {|arr1, arr2| arr1[0] <=> arr2[0]}
        
        puts word + ": #{highest.inspect}" #prints list
      end
    end
    
    def min_index(arr=[])
      min_index = 0
      arr.each_index do |i| 
        min_index = i if arr[i] < arr[min_index]
      end
      min_index
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
        
        p alignments.map {|a| a+1}
        
        output = []
        alignments.each_with_index do |a,i|
          output << [ f_sentence[i], e_sentence[a] ]
        end
        p output
        p f_sentence
        p e_sentence
        
        puts ''
        
      end
    end
    
  end

  class Question2
    attr_accessor :possible_pairs, :t, :q, :english_file, :german_file, 
      :english_sentences, :german_sentences, :counts
    
    def em_algorithm
      n = @english_sentences.size
      @counts = Hash.new(0)

      raise unless @english_sentences.size == @german_sentences.size

      # delta = {}
      n.times do |k|        
        eng = @english_sentences[k]
        ger = @german_sentences[k]

        m = ger.size
        l = eng.size
        #lines for figuring out time

        ger.each_with_index do |f, i|
          key_ilm = "#{i} #{l} #{m}"          
          eng.each_with_index do |e, j|
            sum = 0.0
            eng.each_with_index do |e_word, j_index|
              sum += @q[j_index][key_ilm]*@t[e_word][f]
            end
            # raise "#{sum}, #{f}, #{eng}"
            
            # raise "#{e}, #{f}, #{key_ilm}, #{@t[e][f]}, #{@q[j][key_ilm]},
            # #{eng}
            # #{ger}" if sum == 0.0



            # key_kij = k.to_s + ' ' + i.to_s + ' ' + j.to_s
            # delta[ key_kij ]
            # delta = @t[e][f].to_f / sum
            delta = (@t[e][f].to_f * @q[j][key_ilm].to_f) / sum

            key_ef = e + ' ' + f
            key_jilm = "#{j} " + key_ilm
            @counts[ key_ef ] += delta#[ key_kij ]
            @counts[ e ] += delta#[ key_kij ]
            @counts[key_jilm] += delta
            @counts[key_ilm] += delta

            # @t[e][f] = @counts[key_ef] / @counts[e]

            raise "#{sum}" if @t[e][f].nan?
          end
          raise if key_ilm == "0 17 3"
        end

      end

      @t.keys.each do |e|
        @t[e].keys.each do |f|
          @t[e][f] = @counts[e+' '+f] / @counts[e]
        end
      end
      
      @q.keys.each do |j|
        @q[j].keys.each do |ilm|
          @q[j][ilm] = @counts[j.to_s + ' ' + ilm.to_s] / @counts[ilm] if @counts[ilm] != 0
        end
      end
    end

    def initialize(english, german)
      q1 = Homework2::Question1.new(english,german)
      10.times do
        q1.em_algorithm
      end
      
      @t = q1.t
      @english_sentences = q1.english_sentences
      @german_sentences = q1.german_sentences
      @possible_pairs = q1.possible_pairs
      
      #initialize q
      @q = {}      
      @german_sentences.each_with_index do |ger, g_index|
        m = ger.size
        @english_sentences.each_with_index do |eng, e_index|
          l = eng.size
          ger.each_index do |i|
            eng.each_index do |j|
              @q[j] = Hash.new(0.0) if @q[j].nil?
              key_ilm = "#{i} #{l} #{m}"
              @q[j][key_ilm] = 1.0/(l+1).to_f
            end
          end
        end
      end
    end
    
    def bullet2
      5.times do
        em_algorithm
      end
    end
    
    def sentence_alignments(f_sentence=[], e_sentence=[])
      alignments = []
      m = f_sentence.size
      l = e_sentence.size
      
      f_sentence.each_with_index do |f,i|
        max_alignment = 0
        max_prob = 0

        e_sentence.each_with_index do |e,j|
          if (@q[j]["#{i} #{l} #{m}"] * @t[e.to_s][f.to_s]) >= max_prob
            max_prob = @q[j]["#{i} #{l} #{m}"] * @t[e.to_s][f.to_s]
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
        
        p alignments.map {|a| a+1}
        
        output = []
        alignments.each_with_index do |a,i|
          output << [ f_sentence[i], e_sentence[a] ]
        end
        p output
        p f_sentence
        p e_sentence
        
        puts ''
        
      end
    end
    
  end
end

# Homework2::Question1.init('corpus.en', 'corpus.de')
# en = 'corpus_small.en'
# de = 'corpus_small.de'
# en = 'corpus_500.en'
# de = 'corpus_500.de'
en = 'corpus.en'
de = 'corpus.de'
question_num = 1

raise "Invalid number of arguments #{ARGV.size}" unless ARGV.size == 1 || ARGV.size == 3 

if ARGV.size == 3
  en = ARGV[0]
  de = ARGV[1]
  question_num = ARGV[2]
else
  question_num = ARGV[0]
end

if question_num.to_s == '1'
  q1 = Homework2::Question1.new(en,de)
  q1.bullet2('devwords.txt')
  q1.bullet3
else
  q2 = Homework2::Question2.new(en,de)
  q2.bullet2
  q2.bullet3
end