class Deadline
  @@_deadlines = Hash.new {|hash, key| hash[key] = {}}

  @@_deadlines[:pre_registration][:start]         = Date.parse(Rails.configuration.deadlines[:pre_registration][0])
  @@_deadlines[:pre_registration][:end]           = Date.parse(Rails.configuration.deadlines[:pre_registration][1])
  @@_deadlines[:minisymposium_proposal][:start]   = Date.parse(Rails.configuration.deadlines[:minisymposium_proposal][0])
  @@_deadlines[:minisymposium_proposal][:end]     = Date.parse(Rails.configuration.deadlines[:minisymposium_proposal][1])
  @@_deadlines[:minisymposium_acceptance][:start] = Date.parse(Rails.configuration.deadlines[:minisymposium_acceptance][0])
  @@_deadlines[:minisymposium_acceptance][:end]   = Date.parse(Rails.configuration.deadlines[:minisymposium_acceptance][1])
  @@_deadlines[:minisymposium_abstract][:start]   = Date.parse(Rails.configuration.deadlines[:minisymposium_abstract][0])
  @@_deadlines[:minisymposium_abstract][:end]     = Date.parse(Rails.configuration.deadlines[:minisymposium_abstract][1])
  @@_deadlines[:presentation_proposal][:start]    = Date.parse(Rails.configuration.deadlines[:presentation_proposal][0])
  @@_deadlines[:presentation_proposal][:end]      = Date.parse(Rails.configuration.deadlines[:presentation_proposal][1])

  class << self
    def deadlines
      @@_deadlines
    end

    def pre_registration_start
      @@_deadlines[:pre_registration][:start]
    end

    def pre_registration_end
      @@_deadlines[:pre_registration][:end]
    end

    def in_preregistration?(t)
      (t >= pre_registration_start) && (t <= pre_registration_end) 
    end

    def minisymposium_proposal_start
      @@_deadlines[:minisymposium_proposal][:start] 
    end

    def minisymposium_proposal_end
      @@_deadlines[:minisymposium_proposal][:end] 
    end

    def in_minisymposium_proposal?
      t = Date.today
      (t >= minisymposium_proposal_start) && (t <= minisymposium_proposal_end)
    end

    def minisymposium_abstract_start
      @@_deadlines[:minisymposium_abstract][:start] 
    end

    def minisymposium_abstract_end
      @@_deadlines[:minisymposium_abstract][:end] 
    end

    def in_minisymposium_abstract?
      t = Date.today
      (t >= minisymposium_abstract_start) && (t <= minisymposium_abstract_end)
    end

    def minisymposium_acceptance_start
      @@_deadlines[:minisymposium_acceptance][:start] 
    end

    def minisymposium_acceptance_end
      @@_deadlines[:minisymposium_acceptance][:end] 
    end

    def in_minisymposium_acceptance?
      t = Date.today
      (t >= minisymposium_acceptance_start) && (t <= minisymposium_acceptance_end)
    end

    def presentation_proposal_start
      @@_deadlines[:presentation_proposal][:start]
    end

    def presentation_proposal_end
      @@_deadlines[:presentation_proposal][:end]
    end

    def in_preregistration_proposal?
      t = Date.today
      (t >= presentation_proposal_start) && (t <= presentation_proposal_end)
    end

    # start with minisymposia
    def first_proposal_start
      @@_deadlines[:minisymposium_proposal][:start]
    end

    # ends with presentation_proposals
    def last_proposal_end
      @@_deadlines[:presentation_proposal][:end]
    end

    def conference_start_date
      Rails.configuration.conference_start_date
    end

    def conference_end_date
      @@_conference_end_date ||= Rails.configuration.conference_start_date + Rails.configuration.number_of_days.days
    end

    def before_minisymposium_proposal?
      Date.today < @@_deadlines[:minisymposium_proposal][:start]
    end

    def before_presentation_proposal?
      Date.today < @@_deadlines[:presentation_proposal][:start]
    end

    def before_first_proposal?
      Date.today < first_proposal_start
    end

    def registration_open?
      t = Date.today
      (t >= pre_registration_start) and (t <= conference_end_date)
    end

    def can_propose?(what)
      t = Date.today
      what = :presentation_proposal  if what == :presentation
      what = :minisymposium_proposal if what == :minisymposium

      t.between?(@@_deadlines[what][:start], @@_deadlines[what][:end])
    end

    # all expired
    def proposals_expired?
      t = Date.today
      t > minisymposium_proposal_end and t > minisymposium_abstract_end and t > presentation_proposal_end
    end
  end
end
