require 'rails_helper'

RSpec.describe Minitutorial, type: :model do
  let (:minitutorial) { FactoryGirl.create(:minitutorial) }

  it "does create the presentation" do
    expect(minitutorial.presentation).to be
  end

  it "has a presentation without name or abstract" do
    expect(minitutorial.presentation.name).not_to be
    expect(minitutorial.presentation.abstract).not_to be
  end

end

