require_relative 'lib/tango'

if ARGV.length < 1
  puts "Usage: ruby #{$0} wordlist_file"
  exit 1
end

file = File.open(ARGV[0])
tango = file.readlines.map(&:chomp).map(&:strip)
file.close

cards = []
tango.each do |t|
  jisho = Tango::Jisho.new(t)
  anki = Tango::Anki.new(t, jisho.yomi, jisho.yaku)

  puts anki.format
  cards.append(anki)
end

Tango::Anki::output(cards)
