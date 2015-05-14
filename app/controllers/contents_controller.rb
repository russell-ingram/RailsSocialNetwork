class ContentsController < ApplicationController
  def create
    puts "PARAMS: "
    puts params[:content][:headline]


    @oldnews = Content.find_by("type_of_content = ? AND active = ?", "news", true)
    if @oldnews
      @oldnews.active = false
      @oldnews.save
    end


    @news = Content.new(news_params)
    @news.active = true

    if @news.save
      redirect_to home_path
    else
      redirect_to '/admin/content'
    end

  end

  def layout_edit
    @oldlayout = Content.find_by("type_of_content = ? AND active = ?", "layout", true)
    if @oldlayout
      @oldlayout.active = false
      if @oldlayout.save
        puts "OLDLAYOUT EDITED"
      else
        puts "OLDLAYOUT DIDNT SAVE"
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
    params.require(:content).permit(:headline, :body_copy, :link_copy, :link_url, :active)
  end

  def layout_params
    params.require(:content).permit(:headline, :layout_option, :column_one_callout, :column_two_callout, :column_three_callout, :column_one_content, :column_two_content, :column_three_content, :link_copy, :link_url, :active)
  end


end

# "content"=>{"layout_option"=>"3", "headline"=>"Stuff", "column_one_callout"=>"", "column_one_content"=>"", "column_two_callout"=>"", "column_two_content"=>"", "column_three_callout"=>"Will", "column_three_content"=>"It work?", "link_copy"=>"", "link_url"=>""}, "controller"=>"contents", "action"=>"layout_edit"}

