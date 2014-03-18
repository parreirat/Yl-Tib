class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  # GET /links
  # GET /links.json
  def index
    @links = Link.all
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create
    # Creates new link with parameters passed through.
    @link = Link.new(link_params)
    # All shortened links initially have 0 redirections.
    @link.click_count = 0

    respond_to do |format|
      if @link.save
        # Generate shortened link based on internal ID of link.
        @link.shortened_link = shorten_link(@link.id)
        @link.save
        # Redirect para o show do link criado
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
=begin
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end
=end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url }
      format.json { head :no_content }
    end
  end

  private
  # É chamado sempre no show, edit, update, destroy
  def set_link
    @link = Link.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:original_link)
  end

  ALPHABET =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split(//)
=begin
  ALPHABET =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split(//)
=end

  # Shortening link based on radix64 (a-z, A-Z, 0-9).
  def shorten_link(link_id)

    # If link_id is 0, return the first index of our alphabet (in our case, an 'a').
    if link_id == 0
      return ALPHABET[0]
    end

    # Declare variable for outputting shortened link.
    shortened_link = ''

    # Conversion to base radix 64, grab alphabet's length.
    base = ALPHABET.length

    # While link_id is bigger than 0, encode string into radix 64.
    while link_id > 0
      shortened_link << ALPHABET[link_id.modulo(base)]
      link_id /= base
    end

    # Reverse string into correct ordering.
    shortened_link.reverse

  end

  # Returns original link based on it's shortened version.
  def unshorten_link(shortened_link)

    i = 0

    # Conversion to base radix 64, grab alphabet's length.
    base = ALPHABET.length

    # For every char in the shortened link, multiply by base, sum char's index and add to i.
    shortened_link.each_char {
        |c|
      i = i * base + ALPHABET.index(c)
    }

    return i

  end

end
