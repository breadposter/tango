# tango

Reads list of words and spits out readings and definitions from jisho.org to import directly into Anki.

# Description

Adding new vocabulary to Anki is a bit of a pain and takes a lot of time, since many things aren't straightforwardly copypastable if you want it to look halfway decent. This script aims to grab a list of words from a text file, query jisho.org for each word, then save their readings and meaning as cards that can be imported directly into Anki.

The main benefit is that thanks to this script I don't have to think too much about unknown words and the like while I'm reading everything from physical books to dialogue in games; as long as I can add the words to a simple list, I can have this script import them later and turn everything into cards.

# Requirements

* A working Ruby installation (tested on version 2.7.0).
* `gem install nokogiri`

# Usage

*Because of the way jisho.org functions, this script has to make a separate HTTP request for each word on the wordlist. When using this, please be considerate and don't use wordlists the size of entire dictionaries.*

`ruby tango.rb wordlist_file`

Use `ruby tango.rb examples.txt` to test with the example words provided.

Simple as that. It will output to a file named `output.txt` that can be imported directly into Anki. The format used assumes the following:

| Format                               |
|--------------------------------------|
| Original word                        |
| Reading                              |
| Translation/explanation              |
| Example sentences (currently unused) |

Importing into Anki should in principle allow assigning columns to different fields if they're different from the above.

# Limitations

Often, these are specifically limitations I don't intend to fix/change even after the script is fully functional at this point. After all, the main purpose of this script is to save me time.

* The script outputs a specific card field format that may not mesh with how other people's decks are layed out: four fields, the first for the word, second for reading, third for meaning, and fourth for example sentences/further explanation.
* The script assumes that the first result on jisho.org is the 'correct' answer. This requires some knowledge of what the site is likely to know about when adding words to the list.
