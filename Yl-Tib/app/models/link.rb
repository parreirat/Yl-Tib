class Link < ActiveRecord::Base

  validates :original_link, length: { minimum: 5 }

  # The symbols used to encode the URLs.
  SYMBOLS =
      (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).join
=begin
      (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).shuffle.join
=end

# Shortening link based on radix64 (a-z, A-Z, 0-9).
  def self.shorten_link(link_id)

    # Declare variable for outputting shortened link.
    shortened_link = ''

    # Conversion to base radix 64, grab alphabet's length.
    base = SYMBOLS.length

    # While link_id is bigger than 0, encode string into radix 64.
    while link_id > 0
      shortened_link << SYMBOLS[(link_id) % base]
      link_id /= base
    end

    # Reverse string into correct ordering.
    shortened_link.reverse

  end

# Returns stored link's id based on it's shortened version.
  def self.unshorten_link(shortened_link)

    link_id = 0

    # Conversion to base radix 64, grab alphabet's length.
    base = SYMBOLS.length

    # For every char in the shortened link, multiply by base, sum char's index and add to i.
    shortened_link.each_char {
        |char|
      link_id = link_id * base + SYMBOLS.index(char)
    }

    # Returns original link's id.
    return link_id

  end

end
