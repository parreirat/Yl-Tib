class LinksController < ApplicationController

  def index

    @links = Link.all

  end

  # Supplies author's links to /ownLinks
  def own

    @links = author_links

  end

  def show

    @link = Link.find(params[:id])

  end

  # Redirects the user to the intended page and increases hit counter by 1
  def redirect

    #TODO - Redirecction waiting page plus a sleep on it.
    #TODO - Check if link exists.
    id = Link.unshorten_link(params[:shortened_link])
    @link = Link.find(id)
    @link.click_count += 1
    @link.save
    redirect_to @link.original_link

  end

  def waiting(link)

  end


  def new

    # Prepare for form in view.
    @link = Link.new
    @links = author_links

  end

  def create

    # Creates new link with parameters passed through.
    @link = Link.new(link_params)

    stored_link = Link.where(original_link: @link.original_link)

    # If link hasn't been stored in database, save it and show it.
    if (stored_link.count == 0)

      if @link.save

        # Generate shortened link based on internal ID of link.
        @link.shortened_link = Link.shorten_link(@link.id)
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

  private

  def author_links
    @author_links = Link.where(author_ip: request.remote_ip)
  end

  # Helpers mostly for debugging in the view to check if shortening/unshortening is correct.
=begin
  helper_method :shorten_link, :unshorten_link
=end

end
