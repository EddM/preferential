require "spec_helper"

describe Preferential::Preference do
  let(:object) do
    create(:user)
  end

  it "will not allow more than one preference record for a given owner" do
    create(:preference, owner: object, name: "bar", value: true)
    create(:preference, owner: object, name: "foo", value: true)

    expect do
      create(:preference, owner: object, name: "foo", value: true)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end
end
