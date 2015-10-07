class RequestsController < ApplicationController
  def create
    @newRequest = Request.new
    @homeContent = Content.find_by("type_of_content = ? AND active = ?", "home", true)
    if @homeContent == nil
      @homeContent = Content.new
      @homeContent.active = true
      @homeContent.type_of_content = "home"
      @homeContent.body_copy = "THE NEXT-GEN PLATFORM FOR CIO LEVEL NETWORKING AND PEER BENCHMARKING RESEARCH"
      @homeContent.save
    end

    @r = Request.new(request_params)
    @r.accepted = false
    @r.invite_sent = false
    if @r.save
      @res = 'Request successfully sent'
      render "home/index"
    else
      @res = 'Request failed. Please try again at a later time'
      render "home/index"
    end
  end



  def request_params
    params.require(:request).permit(:first_name, :last_name, :linked_in, :job_title, :company, :email)
  end

end
