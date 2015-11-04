class Request < ActiveRecord::Base
  def parse_linkedin
    full_link = self.linked_in
    a = full_link.slice! "https://www.linkedin.com/"
    if !full_link.split('/')[1].nil?
      return full_link.split('/')[1]
    else
      return ""
    end
  end
end


# https://www.linkedin.com/in/sidnyginsberg
