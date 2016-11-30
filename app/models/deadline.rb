class Deadline
  @@pre_registration             = Date.parse(Rails.configuration.deadlines[:pre_registration])
  @@minisymposium_proposal_start = Date.parse(Rails.configuration.deadlines[:minisymposium_proposal][0])
  @@minisymposium_proposal_end   = Date.parse(Rails.configuration.deadlines[:minisymposium_proposal][1])
  @@minisymposium_abstract_start = Date.parse(Rails.configuration.deadlines[:minisymposium_abstract][0])
  @@minisymposium_abstract_end   = Date.parse(Rails.configuration.deadlines[:minisymposium_abstract][1])
  @@presentation_proposal_start  = Date.parse(Rails.configuration.deadlines[:presentation_proposal][0])
  @@presentation_proposal_end    = Date.parse(Rails.configuration.deadlines[:presentation_proposal][1])

  class << self
    def pre_registration
      @@pre_registration 
    end

    def minisymposium_proposal_start
      @@minisymposium_proposal_start 
    end

    def minisymposium_proposal_end
      @@minisymposium_proposal_end 
    end

    def minisymposium_abstract_start
      @@minisymposium_abstract_start 
    end

    def minisymposium_abstract_end
      @@minisymposium_abstract_end 
    end

    def presentation_proposal_start
      @@presentation_proposal_start
    end

    def presentation_proposal_end
      @@presentation_proposal_end
    end

    def before_proposal?
      Date.today < @@minisymposium_proposal_start
    end

    def can_propose?(what)
      t = Date.today
      case what
      when :minisymposium
        Date.today.between?(@@minisymposium_proposal_start, @@minisymposium_proposal_end)
      when :presentation
        Date.today.between?(@@presentation_proposal_start, @@presentation_proposal_end)
      end
    end
  end

end
