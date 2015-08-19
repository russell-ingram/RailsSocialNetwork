class Search < ActiveRecord::Base

  belongs_to :user, foreign_key: 'user_id'
  serialize :results, JSON

  def search_users
    users = User.all

    users = User.where(["industry LIKE ?", "%#{industry}%"]) if industry.present?

    return users

  end

  def format_string
    str = ''
    if !job_title.blank?
      str += job_title + ', '
    end
    if !industry.blank?
      str += industry + ', '
    end
    if !enterprise.blank?
      str += enterprise + ', '
    end
    if !region.blank?
      str += region + ', '
    end
    if !country.blank?
      str += country + ', '
    end
    if !organization_type.blank?
      str += organization_type + ', '
    end

    if str == '' && results == ''
      str = '<i>No filters selected.</i>'
    elsif str == ''
      str = '<i>Intention filters used.</i>'
    else
      str[str.length - 2] = ''
      str += '</br><i> Intention filters used.</i>'
    end
    return str
  end

end
