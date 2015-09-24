module SearchsHelper


   def criteria_str(search)

      criteria = []

      if !search.industry.blank? 
         criteria << search.industry 
      end 
      if !search.enterprise.blank? 
         criteria << search.enterprise 
      end 
      if !search.organization_type.blank? 
         criteria << search.organization_type 
      end 
      if !search.region.blank? 
         criteria << search.region 
      end 
      if !search.country.blank? 
         criteria << search.country
      end 
      if !search.clevel.blank? 
         criteria << 'C-Level'
      end 
      if !search.executive.blank? 
         criteria << 'Executive'
      end 
      if !search.president.blank? 
         criteria << 'President'
      end 
      if !search.director.blank? 
         criteria << 'Director'
      end 
      if !search.principal.blank? 
         criteria << 'Principal'
      end 
      if !search.head.blank? 
         criteria << 'Head'
      end 
      if !search.senior.blank? 
         criteria << 'Senior'
      end 
      if !search.lead.blank? 
         criteria << 'Lead'
      end 
      if !search.manager.blank? 
         criteria << 'Manager'
      end 
      if !search.architect.blank? 
         criteria << 'Architect'
      end 
      if !search.infrastructure.blank? 
         criteria << 'Infrastructure'
      end 
      if !search.engineer.blank? 
         criteria << 'Engineer'
      end 
      if !search.consultant.blank? 
         criteria << 'Consultant'
      end 
      if !search.security.blank? 
         criteria << 'Security'
      end 
      if !search.analyst.blank? 
         criteria << 'Analyst'
      end 
      if !search.administrator.blank? 
         criteria << 'Administrator'
      end 
      if !search.risk.blank? 
         criteria << 'Risk'
      end   

      if(criteria.length == 0)
         criteria << 'All'
      end

      return criteria.join(', ') 
   end
   
end