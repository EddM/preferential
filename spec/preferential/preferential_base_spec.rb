require "spec_helper"

describe Preferential::Base do
  let(:user) { create(:user) }

  context "Associations" do
    it "establishes a has_many association with the preferences object" do
      preferences_reflection = User.reflections[:preferences]

      expect(preferences_reflection.macro).to eq(:has_many)
    end

    it "doesn't establish a has_many association when no preferences are defined" do
      preferences_reflection = Widget.reflections[:preferences]

      expect(preferences_reflection).to be_nil
    end
  end

  context "Hooks" do
    it "creates preference records on creation" do
      names = user.preferences.pluck(:name)

      expect(Preferential::Preference.count).to eq(4)
      expect(user.preferences.size).to eq(4)
      expect(names).to match_array(["private_mode", "send_email_on_login",
                                    "maximum_login_attempts", "time_zone"])
    end
  end

  context "Attributes" do
    it "fetches the default value for a preference" do
      value = user.preference(:maximum_login_attempts)

      expect(value).to eq(5)
    end

    it "responds to a predicate method for a preference" do
      expect(user.send_email_on_login?).to eq(false)
    end

    it "sets the value for a preference then fetches it" do
      user.maximum_login_attempts = 13

      expect(user.preference(:maximum_login_attempts)).to eq(13)

      user = User.first

      expect(user.preference(:maximum_login_attempts)).to eq(13)
    end

    context "Type casting" do
      it "casts the value of a prefence to a given type" do
        value = user.preference(:private_mode)

        expect(value).to be_instance_of(TrueClass)
      end

      it "infers the type from the default if no explicit type is given" do
        value = user.preference(:send_email_on_login)

        expect(value).to be_instance_of(FalseClass)
      end
    end
  end
end
