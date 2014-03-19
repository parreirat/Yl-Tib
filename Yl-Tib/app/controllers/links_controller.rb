class LinksController < ApplicationController

  def index

    @links = Link.all

  end

  def waiting
    #TODO - To be added.
  end

  def redirect

    #TODO - Redirecction waiting page plus a sleep on it.
    #TODO - Check if link exists.
    id = unshorten_link(params[:shortened_link])
    @link = Link.find(id)
    @link.click_count += 1
    @link.save
    redirect_to @link.original_link

  end

  def show

    @link = Link.find(params[:id])

  end

  def new

    # Prepare for form in view.
    @link = Link.new
    @author_links = author_links

  end

  def create

    # Creates new link with parameters passed through.
    #TODO - Parsing to check if link is valid?
    @link = Link.new(link_params)

    stored_link = Link.where(original_link: @link.original_link)

    # If link hasn't been stored in database, save it and show it.
    if (stored_link.count == 0)

      if @link.save

        # Generate shortened link based on internal ID of link.
        @link.shortened_link = shorten_link(@link.id)
        # All shortened links initially have 0 redirections.
        @link.click_count = 0
        # Save IP Address of user who submitted link.
        @link.author_ip = request.remote_ip

        # Save generated link.
        @link.save

        # Redirect to created link.
        redirect_to '/links/'+@link.id.to_s

      end

      # Incase the link has already been previously saved, return it.
    else

      # Redirect to the previously saved link.
      redirect_to '/links/'+stored_link.first.id.to_s

    end

  end

  # Grabs link which's id is supplied, and deletes it from the databases.
  def destroy

    @link = Link.find(params[:id])
    @link.destroy

    redirect_to links_url

  end

  # Defines what parameters can be passed along, in this case, only the link to be shortened.
  def link_params

    params.require(:link).permit(:original_link)

  end

  # The symbols used to encode the URLs.
  SYMBOLS =
      (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).join
=begin
      (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).shuffle.join
=end

# Shortening link based on radix64 (a-z, A-Z, 0-9).
  def shorten_link(link_id)

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
  def unshorten_link(shortened_link)

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

  private

  def author_links
    @author_links = Link.where(author_ip: request.remote_ip)
  end

  # Helpers mostly for debugging in the view to check if shortening/unshortening is correct.
=begin
  helper_method :shorten_link, :unshorten_link
=end

end
