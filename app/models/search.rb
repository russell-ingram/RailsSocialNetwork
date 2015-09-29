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
    if !clevel.blank?
      str += 'C-Level' + ', '
    end
    if !executive.blank?
      str += 'Executive' + ', '
    end
    if !president.blank?
      str += 'President' + ', '
    end
    if !director.blank?
      str += 'Director' + ', '
    end
    if !principal.blank?
      str += 'Principal' + ', '
    end
    if !head.blank?
      str += 'Head' + ', '
    end
    if !senior.blank?
      str += 'Senior' + ', '
    end
    if !lead.blank?
      str += 'Lead' + ', '
    end
    if !manager.blank?
      str += 'Manager' + ', '
    end
    if !architect.blank?
      str += 'Architect' + ', '
    end
    if !infrastructure.blank?
      str += 'Infrastructure' + ', '
    end
    if !engineer.blank?
      str += 'Engineer' + ', '
    end
    if !consultant.blank?
      str += 'Consultant' + ', '
    end
    if !security.blank?
      str += 'Security' + ', '
    end
    if !analyst.blank?
      str += 'Analyst' + ', '
    end
    if !administrator.blank?
      str += 'Administrator' + ', '
    end
    if !risk.blank?
      str += 'Risk' + ', '
    end


    if str == '' && results == ''
      str = '<i>No filters selected.</i>'
    elsif str == ''
      str = '<i>Intention filters used.</i>'
    else
      str[str.length - 2] = ''
      if results != ''
        str += '</br><i> Intention filters used.</i>'
      end
    end
    return str
  end

end
