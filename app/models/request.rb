class Request < ActiveRecord::Base
  def parse_linkedin
    full_link = self.linked_in
    a = full_link.slice! "https://www.linkedin.com/pub/"
    return full_link.split('/')[1]
  end
end
