require 'rails_helper'

RSpec.describe Minitutorial, type: :model do
  let (:minitutorial) { FactoryBot.create(:minitutorial) }
  let (:user) { FactoryBot.create(:user) }

  it "does create the presentation" do
    expect(minitutorial.presentation).to be
  end

  it "has a presentation" do
    expect(minitutorial.presentation).to be_a(Presentation)
  end

  it "has a presentation with same name" do
    expect(minitutorial.presentation.name).to eq(minitutorial.name)
    # expect(minitutorial.presentation.abstract).to eq(minitutorial.description)
  end

  it "accepts user for organizer" do
    expect(minitutorial.organizers.build(user: user)).to be_valid
  end
end

