class HomeController < ApplicationController
  def index

    if current_user
      redirect_to '/home'
    end

    @newRequest = Request.new
    @homeContent = Content.find_by("type_of_content = ? AND active = ?", "home", true)
    if @homeContent == nil
      @homeContent = Content.new
      @homeContent.active = true
      @homeContent.type_of_content = "home"
      @homeContent.body_copy = "THE NEXT-GEN PLATFORM FOR CIO LEVEL NETWORKING AND PEER BENCHMARKING RESEARCH"
      @homeContent.save
    end
  end
end
