class Request < ActiveRecord::Base
  def parse_linkedin
    full_link = self.linked_in
    a = full_link.slice! "https://www.linkedin.com/"
    return full_link.split('/')[1]
  end
end


https://www.linkedin.com/in/sidnyginsberg
