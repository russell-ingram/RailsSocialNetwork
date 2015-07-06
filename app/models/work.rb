class Work < ActiveRecord::Base
  belongs_to :user

  def work_params
    params.require(:work).permit(:company, :industry, :enterprise_size,:region, :country, :start_date, :end_date,:summary, :current,:public)
  end
end
