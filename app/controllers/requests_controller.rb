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
      Thread.new do
        EtrMailer.request_received_email(@r).deliver_now
        admins = User.where(admin: true)
        admins.each do |a|
          EtrMailer.admin_request_received_email(@r, a).deliver_now
        end
        ActiveRecord::Base.connection.close
      end

      render "home/index"
    else
      @res = 'Request failed. Please try again at a later time'
      render "home/index"
    end
  end

  def send_invite
    @new_user
    @message = params[:message]
    if User.exists?(['id = ?', params[:id]])
      @new_user = User.find(params[:id])
    else
      @new_user = User.find_by("uid = ?", params[:id])
    end
    @new_user.invite_message = @message
    @new_user.save
    Thread.new do
      EtrMailer.send_invite_email(@new_user, @message).deliver_now
      ActiveRecord::Base.connection.close
    end
    redirect_to :back
    # render json: "User invitation sent"
  end

  def user_send_invite
    @user = User.find(params[:id])
    @email = params[:email]

    Thread.new do
      EtrMailer.user_send_invite_email(@user, @email).deliver_now
      ActiveRecord::Base.connection.close
    end

    redirect_to :back

  end

  def delete
    @req = Request.find(params[:id])

    if @req.destroy
      redirect_to '/admin'
    end
  end


  def request_params
    params.require(:request).permit(:first_name, :last_name, :linked_in, :job_title, :company, :email)
  end

end
