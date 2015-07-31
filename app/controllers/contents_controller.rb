class ContentsController < ApplicationController

  # news update
  def update
    # puts params[:content][:image_url]




    @oldnews = Content.find_by("type_of_content = ? AND active = ?", "news", true)
    if @oldnews
      @oldnews.active = false
      @oldnews.save
    end

    my_file = params[:content][:image_url]
    uploader = LinkUrlUploader.new
    uploader.store!(my_file)

    @news = Content.new(news_params)
    link = news_params[:link_url]


    @news[:link_url] = link
    @news.active = true
    p "NEWS:"
    p link
    p @news

    if my_file
      @news.image_url = uploader.url
    else
      @news.image_url = @oldnews.image_url
    end
    if @news.save
      redirect_to home_path
    else
      redirect_to '/admin/content'
    end

  end

  # callout update (1-3 columns)
  def layout_edit
    @oldlayout = Content.find_by("type_of_content = ? AND active = ?", "layout", true)
    if @oldlayout
      @oldlayout.active = false
      if @oldlayout.save
      else
      end
    end

    @layout = Content.new(layout_params)
    @layout.active = true
    @layout.type_of_content = "layout"

    if @layout.save
      redirect_to home_path
    else
      redirect_to '/admin/content'
    end

  end


  private

  def news_params
    params.require(:content).permit(:headline, :body_copy, :link_copy, :link_url, :active, :image_url)
  end

  def layout_params
    params.require(:content).permit(:headline, :layout_option, :column_one_callout, :column_two_callout, :column_three_callout, :column_one_content, :column_two_content, :column_three_content, :link_copy, :link_url, :active)
  end


end

# "content"=>{"layout_option"=>"3", "headline"=>"Stuff", "column_one_callout"=>"", "column_one_content"=>"", "column_two_callout"=>"", "column_two_content"=>"", "column_three_callout"=>"Will", "column_three_content"=>"It work?", "link_copy"=>"", "link_url"=>""}, "controller"=>"contents", "action"=>"layout_edit"}

