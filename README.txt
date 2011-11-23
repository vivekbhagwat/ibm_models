To run IBM Model 1:
ruby hw2.rb corpus.en corpus.de 1

To run IBM Model 2:
ruby hw2.rb corpus.en corpus.de 2

Expected output for devwords.txt in IBM Model 1:
dev_word: [[prob_1, german_1] ... [prob_10, german_10]]

Expected output for alignments for both IBM Model 1 and 2:
[1, 2, 1]
[["wiederaufnahme", "resumption"], ["der", "of"], ["sitzungsperiode", "resumption"]]
["wiederaufnahme", "der", "sitzungsperiode"]
["resumption", "of", "the", "session"]