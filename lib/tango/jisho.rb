class Tango::Jisho

  def initialize(tango)
    html = URI.open("https://jisho.org/search/#{ERB::Util.url_encode(tango)}")

    @doc = Nokogiri::HTML(html)
    @tango = tango
  end

  def yomi
    furigana = []
    @doc.css('.exact_block .concept_light:nth(2) span.furigana .kanji').each do |kanji|
      furigana.append(kanji.text)
    end

    # Hacky approach to get stuff between the span elements. The way jisho.org is set up,
    # it puts kana inside span elements, and kanji not inside any other element at all.
    # This makes CSS selectors a challenge, so we're doing something a bit more barebones.
    # yomi = doc.css('.exact_block:first span.text').inner_html.strip.split(Regexp.union(["<span>", "</span>"]))
    yomi = @doc.css('.exact_block .concept_light:nth(2) span.text')
      .inner_html
      .gsub(Regexp.union(["<span>", "</span>", " ", "\n"]), "")
      .chars

    # Add separators between kanji readings for clarity.
    yomi = yomi.map do |part|
      # Hiragana Unicode block: 0x3040 - 0x309f
      # Katakana Unicode block: 0x30a0 - 0x30ff
      if !(part.ord >= 0x3040 && part.ord <= 0x309f) && !(part.ord >= 0x30a0 && part.ord <= 0x30ff)
        if furigana.length == 0
          # Occurs in cases likes 今朝 where there's two kanji but only shows as one
          # reading けさ. In this case just return nothing (NOTE: this may backfire
          # in rare cases if a reading like this occurs in the middle of a word)
          ""
        else
          "・" + furigana.shift
        end
      else
        part
      end
    end

    yomi.join("").sub(/^・/, '')
  end

  def yaku
    yaku = []
    @doc.css('.exact_block .concept_light:nth(2) .meaning-definition').each do |y|
      yaku.append([
        y.css('.meaning-meaning').text,
        y.css('.supplemental_info').text
      ])
    end

    yaku = yaku.map do |m|
      if m[1].empty?
        m[0]
      else
        m[0] + " [" + m[1] + "]"
      end
    end

    yaku
  end
end
