class Tango::Anki

  def initialize(tango, yomi, yaku)
    @tango = tango
    @yomi = yomi
    @yaku = yaku
  end

  def format
    yaku = @yaku.map {|y| Tango::Anki.escape(y) }
      .join("<br><br>")

    # Last field unused for now. Note no semicolon after last column otherwise!
    fmt = "#{@tango};#{@yomi};#{yaku};"

    fmt
  end

  def self.output(cards)
    file = File.open("output.txt", "w")
    cards.each do |c|
      file.puts c.format
    end
  end

  private

  def self.escape(str)
    # Anki requirement that double quotes be replaced by two double quotes to
    # indicate they're not used for multiline fields.
    str = str.gsub("\"", "\"\"")

    # Using ; as delimiter, so replace them with commas in strings. Anki uses the
    # first recognized delimiter, which should be fine since a semicolon should
    # show up after the first word immediately.
    str = str.gsub(";", ",")
  end

end
