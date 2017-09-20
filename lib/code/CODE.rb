
------------------------------------------------------------------------

module BibleGateway
  require 'open-uri'
  require 'nokogiri'

  class BibleGatewayError < StandardError; end

  class BibleGateway
    GATEWAY_URL = "http://www.biblegateway.com"

    VERSIONS = { 
      :new_international_version => "NIV",
      :new_american_standard_bible => "NASB",
      :the_message => "MSG",
      :amplified_bible => "AMP",
      :new_living_translation => "NLT",
      :king_james_version => "KJV",
      :english_standard_version => "ESV",
      :contemporary_english_version => "CEV",
      :new_king_james_version => "NKJV",
      :new_century_version => "NCV",
      :king_james_version_21st_century => "KJ21",
      :american_standard_version => "ASV",
      :youngs_literal_translation => "YLT",
      :darby_translation => "DARBY",
      :holman_christian_standard_bible => "HCSB",
      :new_international_readers_version => "NIRV",
      :wycliffe_new_testament => "WYC",
      :worldwide_english_new_testament => "WE",
      :new_international_version_uk => "NIVUK",
      :todays_new_international_version => "TNIV",
    }

    def self.versions
      VERSIONS.keys
    end

    attr_accessor :version

    def initialize(version = :king_james_version)
      self.version = version
    end

    def version=(version)
      raise BibleGatewayError, 'Unsupported version' unless VERSIONS.keys.include? version
      @version = version
    end

    def lookup(passage)
      doc = Nokogiri::HTML(open(passage_url(passage)))
      scrape_passage(doc)
    end  

    private
      def passage_url(passage)
        URI.escape "#{GATEWAY_URL}/passage/?search=#{passage}&version=#{VERSIONS[version]}"
      end

      def scrape_passage(doc)
        title = doc.css('h2')[0].content
        segment = doc.at('div.result-text-style-normal')
        segment.search('sup.xref').remove # remove cross reference links
        segment.search('sup.footnote').remove # remove footnote links
        segment.search("div.crossrefs").remove # remove cross references
        segment.search("div.footnotes").remove # remove footnotes
        segment.search('sup.versenum').each do |span|
          text = span.content
          span.swap "<sup>#{text}</sup>"
        end
        content = segment.inner_html.gsub('<p></p>', '').gsub(/<!--.*?-->/, '').strip
        {:title => title, :content => content }
      end
  end
  
end

------------------------------------------------------------------------

module ChristianCalendar
  #!/usr/bin/env ruby

  # file: christian_calendar.rb

  require 'easter'
  require 'chronic'

  WEEK = 7

  class ChristianCalendar

    def initialize(year=Time.now.year)
      @year = year    
    end

    def epiphany()
      christmas(@year - 1) + 12
    end

    def st_davids_day(year=@year)
      Date.new(year, 3, 1)
    end

    alias saint_davids_day st_davids_day

    def ash_wednesday()
      Easter.ash_wednesday(@year)
    end

    def mothering_sunday()
      Chronic.parse('sunday', now: ash_wednesday).to_date + WEEK * 3
    end

    def st_patricks_day(year=@year)
      Date.new(year, 3, 17)
    end

    alias saint_patricks_day st_patricks_day

    def palm_sunday()
      Easter.palm_sunday(@year)
    end

    def good_friday()
      Easter.good_friday(@year)
    end

    def easter_sunday()
      Easter.easter(@year)
    end

    alias easter easter_sunday

    def whit_sunday()
      Chronic.parse('sunday', \
          now: Chronic.parse('15 May', now: Time.local(@year,1,1))).to_date
    end

    def trinity_sunday()
      Chronic.parse('sunday', now: pentecost).to_date
    end

    def ascension_day()
      Easter.ascension_day(@year)
    end

    def pentecost()
      Easter.pentecost(@year)
    end

    alias pentecost_sunday pentecost

    def st_andrews_day(year=@year)
      Date.new(year, 11, 30)
    end

    alias saint_andrews_day st_andrews_day

    def advent_sunday()    
      Chronic.parse('sunday', now: christmas).to_date - WEEK * 4
    end

    def christmas(year=@year)
      Date.new(year, 12, 25)
    end

    def to_h
      a = %i(epiphany st_davids_day ash_wednesday mothering_sunday)\
      + %i(st_patricks_day palm_sunday good_friday easter_sunday)\
      + %i(whit_sunday trinity_sunday ascension_day pentecost st_andrews_day)\
      + %i(advent_sunday christmas)

      a.inject({}){|r,day| r.merge(day => method(day).call)}
    end
  end

  if __FILE__ == $0 then

    cc = ChristianCalendar.new
    cc.epiphany
    #cc.mothering_sunday
    #cc.whit_sunday
    #cc.trinity_sunday
    cc.advent_sunday

    cc.to_h
  end
  
end

------------------------------------------------------------------------

module BibleReferenceParser
  # This class handles the parsing of chapters in a passage or string.
  # 
  # Each ChapterReference object contains the chapter number and a ReferenceCollection of
  # verses.
  # 
  # The main method of interest is ChapterReference.parse_chapters. This will parse a passage
  # or string and return a ReferenceCollection of ChapterReference objects. One object for 
  # each chapter identified. Example:
  # 
  #     chapters = ChapterReference.parse_chapters("1:1-10, 5:6")
  #     chapters[0].number # => 1
  #     chapters[1].number # => 5
  #
  # Although less useful, parse_chapters can even parse just the chapters in a complete passage:
  # 
  #     chapters = ChapterReference.parse_chapters("Genesis 1:1-10, Mark 5:6")
  #     chapters[0].number # => 1
  #     chapters[1].number # => 5 
  #
  # You can see if there were any errors in parsing by checking the "has_errors?" method on the
  # returned ReferenceCollection. Without specify metadata to validate against, only simple 
  # validation is possible. If you do provide metadata, (ex. BibleMetadata["Genesis"]),
  # The ChapterReference will add an error message if the chapter doesn't exist for the book.
  # 
  # If you want to parse chapters for a particular book, its better to use the 
  # parse_chapters_in_reference method. This method takes an existing book reference. 
  # Example:
  # 
  #     book = BookReference.new("Genesis", "1:1000, 51:10")
  #     chapters = ChapterReference.parse_chapters_in_reference(book)
  #     chapters.has_errors? # => true
  #     chapters.no_errors? # => false
  #     chapters.errors # => ["The verse '1000' does not exist for Genesis 1",
  #                           "Chapter '51' does not exist for the book Genesis"]
  #
  # You can check if an individiual ChapterReference has errors as well:
  # 
  #     book = BookReference.new("Genesis", "1:1000, 51:10")
  #     chapters = ChapterReference.parse_chapters_in_reference(book)
  #     chapters.first.has_errors? # => true
  #     chapters.first.no_errors # => false
  #     chapters.first.errors # => ["The verse '1000' does not exist for Genesis 1"]
  
  class ChapterReference 
    include TracksErrors
    
    attr_reader :number, :raw_content, :verse_references, :metadata 
    
    alias :children :verse_references
    
    # Instance Initialization
    #----------------------------------------------------------------------------
    
    # Initializes a new ChapterReference object.
    #
    # Parameters:
    # number        - The chapter number. Can either be an string or integer
    # raw_content   - A string representing the verses referenced, ex. "1-10"
    # metadata      - (optional) An array of metadata information for a particular
    #                 book, ex. BibleMetadata["Genesis"]. This is used to check if
    #                 the chapter number is valid for a book.
    def initialize(number, raw_content = nil, metadata = nil)
      super
                   
      number = number.to_i # allows passing the number parameter as string
      
      # if number is less than 1 add a parsing error and stop processing
      if number < 1
        add_error "The chapter number '#{number}' is not valid" and return
      end
      
      # metadata info for a particular book in the bible
      @metadata = metadata
      
      # if the metadata is given, we can verify if the chapter exists for the book
      unless @metadata.nil?        
        total_chapters_in_book = @metadata["chapter_info"].length
        
        if number > total_chapters_in_book
          add_error "Chapter '#{number}' does not exist for the book #{@metadata['name']}" and return
        end
      end        
      
      # The chapter number
      @number = number
      
      # The string representing the verses referenced in this chapter    
      @raw_content = raw_content
      
      parse_contents      
    end
    
    # Class Methods
    #----------------------------------------------------------------------------        
                                                          
    # Works similar to parse_chapters, however this should be used instead if you want
    # to associate the chapter references with a book. This will decide what chapters 
    # are referenced based on the raw_content of the book reference. If the raw_content
    # is nil, it will assume only the first chapter is desired.
    def self.parse_chapters_in_reference(book_reference)
      if book_reference.raw_content.nil?                          
        # if the raw_content is nil, assume we want just the first chapter. This is what
        # Bible Gateway does if you just give a book name.
        return self.parse_chapters(1, book_reference.metadata)        
      else
        return self.parse_chapters(book_reference.raw_content, book_reference.metadata)        
      end
    end
    
    # Parse the chapters in a passage or string. Returns a ReferenceCollection
    # of ChapterReference objects.
    # 
    # Parameters:
    # passage         - The passage to parse, ex. "1:1-10, 2:5-7"
    # metadata        - An array of metadata information for a particular book, ex. BibleMetadata["Genesis"].
    #                   NOTE: if you are passing this in, you probably should
    #                   be calling parse_chapters_in_reference instead of this one. 
    # 
    # Example:
    # 
    #     chapters = ChapterReference.parse_chapters("1:1-10, 2:5-7")
    #     chapters.first.number # => 1
    # 
    # This can also parse just the chapters in a whole passage. It will ignore the book names:
    # 
    #     chapters = ChapterReference.parse_chapters("Genesis 1:1-10; mark 1:5-7")
    #     chapters.first.number # => 1
    #
    # More Examples:
    # 
    #     ChapterReference.parse_chapters("1:1")
    #     ChapterReference.parse_chapters("1:1-10")
    #     ChapterReference.parse_chapters("1:1-10; 5-10")
    #     ChapterReference.parse_chapters("1:5,8,11; 2:10, 5-20")
    #     ChapterReference.parse_chapters(10)
    # 
    # XXX allow option to remove duplicate chapters
    def self.parse_chapters(passage, metadata = nil)
      passage = passage.to_s # allows for integer passage
      
      chapters = ReferenceCollection.new
      
      # ~ Do some massaging of the data before we scan it...
      
      # Replace letters with a semi-colon. We would just remove all letters, but in cases
      # where books are separated by just a space, it will cause errors. For example
      # "Genesis 1 Exodus 1" would end up as "11".
      passage = passage.gsub(/[a-zA-Z]+/, ";") 
      
      # Next remove everything except for numbers and these punctuation marks -> -,;:
      # We don't care about spaces or any other characters.   
      passage = passage.gsub(/[^0-9:;,\-]/, "")
      
      # Finally insert a semi-colon before digits that precede a colon. This is for chapters
      # that reference specific verses, like "15:1". Semi-colons are used to indicate
      # the following sequence is separate from the preceding sequence. This is important
      # for back-to-back chapters with verses, ex. "1:5,10,5:10". Here we want chapter 1
      # verses 5 and 10, then chapter 5 verse 10. The way we know it's not chapter 1 verse
      # 5, 10, and 5 is if there is a semi-colon there: "1:5,10,;5:10".
      passage = passage.gsub(/[0-9]+:/, ';\0')
      
      # This will look for digits followed by a semi-colon. If we match that,
      # we know what's before the colon is the chapter, and we know every digit or dash
      # directly after it are the verses.       
      match_chapter_with_verses = /([0-9]+:)([0-9,\-]+)/
      
      # This will match a chapter range, like "1-10"
      match_chapter_range = /([0-9]+\-[0-9]+)/
      
      # This will match a single chapter selection that doesn't specify any verses.
      # Something like "Genesis 1, 2" tells us we want chapters 1 and chapter 2. 
      # It looks for any digits directly followed by an optional comma or semi-colon. 
      # It's optional because it won't be there if it's the last or only chapter.
      match_single_chapter = /([0-9]+[,;]?)/
      
      # First try to match the chapter with verses, then the chapter range, then finally the single chapter
      pattern = Regexp.union(match_chapter_with_verses, match_chapter_range, match_single_chapter)
      
      # Let's find the chapters already!
      passage.scan pattern do |with_verses, verses, chapter_range, without_verses|
       
        if chapter_range
          # get the beginning and end of the range
          range = chapter_range.split "-"
          first = range.first.to_i
          last = range.last.to_i
          
          # add each chapter in the range
          (first..last).each do |number|
            chapters << ChapterReference.new(number, nil, metadata)
          end
        else
          number = with_verses ? with_verses.to_i : without_verses.to_i
          
          # remove all characters from the end util we get to a number.
          # This basically removes any extraneous punctation at the end.        
          verses = verses.gsub(/[^0-9]+$/, "") unless verses.nil?
          
          chapters << ChapterReference.new(number, verses, metadata)      
        end
      end
      
      chapters      
    end                                  
    
    # Instance Methods
    #----------------------------------------------------------------------------
    
    # Whether this reference itself is valid. Please note this does not consider the verses inside
    # the chapter, just the chapter itself.
    def valid_reference?
      !number.nil?
    end
    
    # Parse the raw_content in order to find the verses referenced for this chapter. 
    def parse_contents
      @verse_references = VerseReference.parse_verses_in_reference self
    end
    
    # Cleans invalid verse references. After calling this, the verse_references method will only return good
    # verse references. You can access the invalid references through verse_references.invalid_references. 
    # See ReferenceCollection.clean for more information.
    # 
    # If the chain parameter is true (which it is by default) it will also tell valid verses to do a clean. 
    # Since verses are leaf-nodes so to speak, they don't contain any references to clean so it won't do anything.
    def clean(chain = true)
      verse_references.clean(chain)
    end
    
    # TODO write specs
    # Get an array of ints containing the verse numbers referenced
    def verse_numbers  
      verses = []
      @verse_references.each do |ref|
        verses << ref.number
      end
      verses
    end

  end  
end

------------------------------------------------------------------------

module RcvBible
  
  require "httparty"
  #require "pry"

  class RcvBible
    VERSION = "0.0.5"
  end

  require 'rcv_bible/chapter_range_maker'
  require 'rcv_bible/reference'
  require 'rcv_bible/one_chapter_book_converter'

  class RcvBible::Reference

    def initialize(reference)
      @reference = reference
      @parsed_request = RcvBible::OneChapterBookConverter.adjust_reference(reference)
      initial_request
      verse_requests
    end

    def initial_request
      @response = HTTParty.get("https://api.lsm.org/recver.php?String=#{@parsed_request}").to_h
    end

    def error
      @error
    end

    def copyright
      [{copyright: @response["request"]["copyright"] }]
    end

    def verses
      @verses + copyright
    end

    def message
      @message ||= @response["request"]["message"]
    end

    def short_chapter_verses_array
      @short_chapter_verses_array ||= @response["request"]["verses"]["verse"]
    end

    def completed_response?
      message == "\t" || message == nil
    end

    def invalid_reference?
      message["Bad Reference"]
    end

    def chapter_verse_count
      message.sub(/.*?requested /, '').split.first.to_i
    end

    def verse_requests
      if completed_response?
        @verses = short_chapter_verses_array
      elsif invalid_reference?
        @verses = []
        @error = "Bad Reference"
      else
        long_chapter_verses_array = []
        RcvBible::ChapterRangeMaker.new(chapter_verse_count).verse_ranges.each do |vr|
          verses_chunk = HTTParty.get(
                                    "https://api.lsm.org/recver.php?
                                    String=#{@reference}: #{vr.first}-#{vr.last}").
                                    to_h["request"]["verses"]["verse"]
          long_chapter_verses_array << verses_chunk
        end
        @verses = long_chapter_verses_array.flatten
      end
    end
  end

  class RcvBible::OneChapterBookConverter
    OCB_REFERENCES = { "obadiah" => "Oba 1-21",
                "obadiah 1" => "Oba 1-21",
                "obadiah 1:1-21" => "Oba 1-21",
                "philemon" => "Philem 1-25",
                "philemon 1" => "Philem 1-25",
                "philemon 1:1-25" => "Philem 1-25",
                "2 john" => '2 John 1-13',
                "2 john 1" => '2 John 1-13',
                "2 john 1:1-13" => '2 John 1-13',
                "3 john" => '3 John 1-13',
                "3 john 1" => '3 John 1-13',
                "3 john 1:1-13" => '3 John 1-13',
                "jude" => "Jude 1-24",
                "jude 1" => "Jude 1-24",
                "jude 1:1-24" => "Jude 1-24"
              }

    def self.adjust_reference(reference)
      self.new(reference).adjust_reference
    end

    def initialize(reference)
      @reference = reference
    end

    def adjust_reference
      if OCB_REFERENCES[@reference.downcase]
        OCB_REFERENCES[@reference.downcase]
      else
        @reference
      end
    end
  end
  
end

------------------------------------------------------------------------

module EsvBible
  
  require 'net/http'

  class EsvBibleError < StandardError; end

  class EsvBible
    VERSION = '0.0.1'
    BASE_URL = 'http://www.esvapi.org/v2/rest'
    VALID_FORMATS = [:plain_text, :html, :xml]
    VALID_HTML_OPTIONS = [:include_passage_references, :include_first_verse_numbers, 
        :include_verse_numbers, :include_headings, :include_subheadings, :include_footnotes, :include_footnote_links,
        :include_surrounding_chapters, :include_word_ids, :include_audio_link, :audio_format, :audio_version, 
        :include_copyright, :include_short_copyright]
    VALID_TEXT_OPTIONS = [:include_passage_references, :include_first_verse_numbers, 
        :include_verse_numbers, :include_headings, :include_subheadings, :include_selahs, 
        :include_passage_horizontal_lines, :include_heading_horizontal_lines, :include_footnotes, 
        :include_copyright, :include_short_copyright, :include_content_type, :line_length]
    VALID_XML_OPTIONS  = []

    attr_accessor :key
  
    class << self
      def formats
        VALID_FORMATS
      end
    
      def html_options
        VALID_HTML_OPTIONS
      end
    
      def text_options
        VALID_TEXT_OPTIONS
      end

      def xml_options
        VALID_XML_OPTIONS
      end    
    end
  
    def initialize(key = 'IP')
      @key = key
    end
  
    def passage(passage, options = {})
      cleanse! options
      url = build_url("passageQuery", options.merge(:passage => passage))
      open_bible(url)
    end
  
    def verse(verse, options = {})
      cleanse! options
      url = build_url("verse", options.merge(:passage => verse))
      open_bible(url)
    end
  
    def search(query, options = {})
      cleanse! options
      url = build_url("query", options.merge(:q => query))
      open_bible(url)
    end
  
    def build_url(action, options = {})
      url = "#{BASE_URL}/#{action}?"
      options.each_pair do |key, value|
        param = convert_to_param(key)
        url << "#{param}=#{value}&"
      end
      url << "key=#{self.key}"
    end

    def open_bible(url, limit = 10)
      raise EsvBibleError, 'HTTP redirect too deep' if limit == 0

      url = URI.escape(url)
    
      response = Net::HTTP.get_response(URI.parse(url))
      case response
        when Net::HTTPSuccess
          response.body
        when Net::HTTPRedirection
          open_passage(response['location'], limit - 1)
        else
          raise "#{rsp.code} #{rsp.message}"
      end
    end
  
    def cleanse! options
      format = options[:output_format] || :html
      raise EsvBibleError unless VALID_FORMATS.include?(format)
    
      valid_format_attributes = case format
      when :html        then VALID_HTML_OPTIONS
      when :plain_text  then VALID_TEXT_OPTIONS
      when :xml         then VALID_XML_OPTIONS
      end
      options.reject! { |key, value| !valid_format_attributes.include?(key) }
    end
  
    def convert_to_param(symbol)
      symbol.to_s.gsub('_', '-')
    end
  
  end

end

------------------------------------------------------------------------

module DigitalBible

  require "digital_bible_platform/version"
  require "digital_bible_platform/dam_id"
  require "typhoeus"
  require "hashie"
  require "oj"

  module DigitalBiblePlatform
    class Client
      attr_reader :api_key   #'fd82d19821647fa4829c7ca160b82e6f'

      def initialize(api_key, defaults={})
        @api_key = api_key
        @defaults = {
          # API Defaults
          protocol:       'http', 
          audio_encoding: 'mp3',
          callback:       false,

          # Media Defaults
          language:   "English",
          version:    :esv,
          collection: :complete,
          drama:      :drama,
          media:      :audio,
        }.merge(defaults)
      end

    
      def url_for(book_short_name, chapter=1, overrides={})      
        response = connect!('/audio/path', {
          dam_id: DamId.full( @defaults.merge(overrides.merge({book:book_short_name}) )),
          book_id:    book_short_name,
          chapter_id: chapter,
        })
        file = response.find {|book| book.book_id==book_short_name}.path
        "#{base_url}/#{file}"
      end
    
      def books(overrides={})
        options = @defaults.merge(overrides)
        connect!('/library/book', { dam_id: DamId.partial(options) })
      end
    
    private
  
      def connect!(path, options={})
        request_body = {key:@api_key, v:'2'}.merge(options)
        request_body.merge!({reply:'jsonp',callback:@defaults[:callback]}) if @defaults[:callback]
        response = Typhoeus.get("http://dbt.io#{path}", params:request_body, followlocation: true)
        reply = Oj.load( response.body )
      
        case reply
          when Hash  then Hashie::Mash.new(reply)
          when Array then reply.map {|hash| Hashie::Mash.new(hash)}
        end
      end
    
      def base_url
        @cdns ||= connect!('/audio/location')
        cdn = @cdns.sort_by(&:priority).first {|_cdn| _cdn.protocal==@defaults[:protocal]}
        "#{cdn.protocol}://#{cdn.server}#{cdn.root_path}"
      end
    end
  end


  # DEV
  @client = DigitalBiblePlatform::Client.new('fd82d19821647fa4829c7ca160b82e6f')

  require 'iso-639'
  module DigitalBiblePlatform
  
    class DamId
      class << self
    
        # Example ENGESV
        def partial(options={})
          [ (Codes.language    options[:language]    ),
            (Codes.version     options[:version]     ),
          ].join('').upcase
        end
    
        # Example ENGESVN2DA
        def full(options={})
          collection = if options[:book]
            Codes.collection_from_book options[:book]
          else
            Codes.collection  options[:collection]
          end
        
          [ (Codes.language    options[:language]    ),
            (Codes.version     options[:version]     ),
            (collection                              ),
            (Codes.drama       options[:drama]       ),
            (Codes.media       options[:media]       ),
          ].join('').upcase
        end
      end

      # http://www.digitalbibleplatform.com/docs/core-concepts/ 
      class Codes
        class << self
          def language(name)
            lang   = ISO_639.find(name.to_s.downcase)
            lang ||= ISO_639.find_by_english_name(name.to_s.capitalize)
            raise ArgumentError.new("#{name} Not recognized as a language") unless lang
            lang.alpha3_bibliographic.upcase
          end
    
          def version(type)
            type.upcase.to_s
          end

          def collection(type)
            COLLECTIONS[type.to_sym]
          end
        
          def collection_from_book(book_short_name)
            return COLLECTIONS[:old_testament] if OLD_TESTAMENT_SHORT_NAMES.include? book_short_name
            return COLLECTIONS[:new_testament] if NEW_TESTAMENT_SHORT_NAMES.include? book_short_name
          end
    
          def drama(type)
            DRAMA_TYPES[type.to_sym]
          end
    
          def media(type)
            MEDIA_TYPES[type.to_sym]
          end
        end
  
        COLLECTIONS = {
          old_testament: "O", # Contains one or more books of the Old Testament.
          new_testament: "N", # Contains one or more books of the New Testament.
               complete: "C", # Contains books from both the Old and New Testament. (These volumes are used primarily for content downloads, and are not generally used by the actual reader applications).
                  story: "S", # Contains content that is not organized by books and chapters.
                partial: "P", # Contains only partial content, such as a few chapters from one book of the Bible.
        }
  
        DRAMA_TYPES = {
              drama: 2, # Audio includes spoken text, music, and sound effects.
          non_drama: 1, # Audio includes only spoken text.
        }
  
        MEDIA_TYPES = {
           text: "ET", # Electronic Text
          audio: "DA", # Digital Audio
          video: "DV", # Digital Video
        }
      
        OLD_TESTAMENT = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes", "Song of Solomon", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi"] 
        NEW_TESTAMENT = ["Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"]
      
        OLD_TESTAMENT_SHORT_NAMES = ["Gen", "Exod", "Lev", "Num", "Deut", "Josh", "Judg", "Ruth", "1Sam", "2Sam", "1Kgs", "2Kgs", "1Chr", "2Chr", "Ezra", "Neh", "Esth", "Job", "Ps", "Prov", "Eccl", "Song", "Isa", "Jer", "Lam", "Ezek", "Dan", "Hos", "Joel", "Amos", "Obad", "Jonah", "Mic", "Nah", "Hab", "Zeph", "Hag", "Zech", "Mal"] 
        NEW_TESTAMENT_SHORT_NAMES = ["Matt", "Mark", "Luke", "John", "Acts", "Rom", "1Cor", "2Cor", "Gal", "Eph", "Phil", "Col", "1Thess", "2Thess", "1Tim", "2Tim", "Titus", "Phlm", "Heb", "Jas", "1Pet", "2Pet", "1John", "2John", "3John", "Jude", "Rev"]
      
      end
    end
  end
  
end

------------------------------------------------------------------------



------------------------------------------------------------------------

module Biblekjv
  
  # encoding: UTF-8

  require 'cskit'
  require 'pathname'

  module CSKit
    module Bible
      module Kjv
        autoload :Splitter, 'cskit/bible/kjv/splitter'
        autoload :Volume,   'cskit/bible/kjv/volume'

        class << self
          def resource_dir
            @resource_dir ||= resource_pathname.to_s
          end

          def resource_root
            @resource_root ||= resource_pathname.join('bible', 'kjv').to_s
          end

          private

          def resource_pathname
            @resource_dir ||= Pathname(__FILE__)
              .dirname.dirname.dirname.dirname
              .join('resources')
          end
        end
      end
    end
  end

  CSKit.register_volume({
    type: :bible,
    id: :bible_kjv,
    name: 'The Holy Bible, King James Version',
    author: '',
    language: 'English',
    resource_path: CSKit::Bible::Kjv.resource_root,
    volume: CSKit::Bible::Kjv::Volume,
    parser: CSKit::Parsers::Bible::BibleParser,
    reader: CSKit::Readers::BibleReader
  })
  
  

  module CSKit
    require 'json'
    
    module Bible
      module Kjv
        class Volume < CSKit::Volume

          def get_book(book_name)
            if File.directory?(book_resource_path(book_name))
              glob_path = File.join(book_resource_path, '**')

              chapters = Dir.glob(glob_path).map.with_index do |resource_file, index|
                get_chapter(index + 1, book_name)
              end

              CSKit::Volumes::Bible::Book.new(book_name, chapters)
            end
          end

          def get_chapter(chapter_number, book_name)
            resource_file = File.join(book_resource_path(book_name), "#{chapter_number}.json")
            chapter_cache[resource_file] ||= CSKit::Volumes::Bible::Chapter.from_hash(
              JSON.parse(File.read(resource_file))
            )
          end

          def unabbreviate_book_name(orig_book_name)
            book_name = orig_book_name.strip.chomp('.')  # remove trailing period
            regex = /^#{book_name}\w*/i

            found_book = books.find do |book|
              book['name'] =~ regex
            end

            found_book ? found_book['name'] : orig_book_name
          end

          def books
            @books ||= JSON.parse(File.read(File.join(resource_path, 'books.json')))
          end

          private

          def book_resource_path(book_name)
            File.join(resource_path, book_name)
          end

          def chapter_cache
            @chapter_cache ||= {}
          end

        end
      end
    end
  end

  module CSKit
    require 'json'
    
    module Bible
      module Kjv

        # Splits the kjv bible text (from Project Gutenberg) in the vendor directory.
        # Mainly designed to be used by the 'update' rake task.
        class Splitter

          VERSE_REGEX = /\d{1,3}:\d{1,3}/
          BOOK_TRIGGERS = [
            'Jonah',
            'The Epistle of Paul the Apostle to the Hebrews',
            'The Third Epistle General of John',
            'The General Epistle of Jude',
            'The Revelation of Saint John the Devine'
          ]

          include Enumerable
          attr_reader :input_file

          def initialize(input_file)
            @input_file = input_file
          end

          def each
            verse_buffer = ''
            chapter = CSKit::Volumes::Bible::Chapter.new(1, [])
            book = CSKit::Volumes::Bible::Book.new(book_data.first['name'], [chapter])
            book_count = 1

            File.open(input_file).each_line do |line|
              if line.strip.empty?
                if verse_buffer =~ /\A#{VERSE_REGEX}/
                  split_verses(verse_buffer).each do |verse_data|
                    chapter_num, verse_num, text = verse_data

                    if chapter_num != chapter.number
                      yield chapter, book
                      new_chapter = CSKit::Volumes::Bible::Chapter.new(chapter_num, [])
                    end

                    if chapter_num > chapter.number
                      book.chapters << new_chapter
                      chapter = new_chapter
                    elsif chapter_num != chapter.number
                      book = CSKit::Volumes::Bible::Book.new(book_data[book_count]['name'], [new_chapter])
                      book_count += 1
                      chapter = new_chapter
                    end

                    chapter.verses << CSKit::Volumes::Bible::Verse.new(text.strip)
                  end
                end

                verse_buffer.clear
              elsif
                # Jonah (and Hebrews) is special because Obadiah (the book before Jonah)
                # only has one chapter and therefore breaks the assumption that all
                # books have more than one chapter, which this script uses to avoid
                # having to identify book headers. Yes, it's ugly.
                if BOOK_TRIGGERS.include?(line.strip)
                  yield chapter, book
                  chapter = CSKit::Volumes::Bible::Chapter.new(1, [])
                  book = CSKit::Volumes::Bible::Book.new(book_data[book_count]['name'], [chapter])
                  book_count += 1
                end
              else
                verse_buffer << "#{line.strip} "
              end
            end

            yield chapter, book
          end

          alias_method :each_chapter, :each

          private

          def book_data
            @book_data ||= JSON.parse(
              File.read(
                File.join(CSKit::Bible::Kjv.resource_root, 'books.json')
              )
            )
          end

          def split_verses(text)
            verses = text.split(/(#{VERSE_REGEX})/)
            verses[1..-1].each_slice(2).map do |verse_parts|
              verse_parts.first.split(":").map(&:to_i) + [verse_parts.last]
            end
          end

        end
      end
    end
  end

end

------------------------------------------------------------------------



------------------------------------------------------------------------



------------------------------------------------------------------------



------------------------------------------------------------------------



------------------------------------------------------------------------



------------------------------------------------------------------------



------------------------------------------------------------------------



------------------------------------------------------------------------



------------------------------------------------------------------------



------------------------------------------------------------------------



------------------------------------------------------------------------



------------------------------------------------------------------------



------------------------------------------------------------------------



------------------------------------------------------------------------




