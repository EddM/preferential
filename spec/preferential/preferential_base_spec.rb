require "spec_helper"

shared_examples "A model with preferences" do
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
      names = subject.preferences.pluck(:name)

      expect(Preferential::Preference.count).to eq(expected_preferences.size)
      expect(subject.preferences.size).to eq(expected_preferences.size)
      expect(names).to match_array(expected_preferences)
    end
  end
end

describe Preferential::Base do
  context "A model with multiple preferences defined with defaults and types" do
    subject { User.create }

    let(:expected_preferences) do
      ["private_mode", "send_email_on_login",
       "maximum_login_attempts", "time_zone"]
    end

    it_behaves_like "A model with preferences"

    context "Attributes" do
      it "fetches the default value for a preference" do
        value = subject.preference(:maximum_login_attempts)

        expect(value).to eq(5)
      end

      it "responds to a predicate method for a preference" do
        expect(subject.send_email_on_login?).to eq(false)
      end

      it "sets the value for a preference then fetches it" do
        subject.maximum_login_attempts = 13

        expect(subject.preference(:maximum_login_attempts)).to eq(13)

        subject = User.first

        expect(subject.preference(:maximum_login_attempts)).to eq(13)
      end

      context "Type casting" do
        it "casts the value of a prefence to a given type" do
          value = subject.preference(:private_mode)

          expect(value).to be_instance_of(TrueClass)
        end

        it "infers the type from the default if no explicit type is given" do
          value = subject.preference(:send_email_on_login)

          expect(value).to be_instance_of(FalseClass)
        end
      end
    end
  end

  context "A model with a single preference and a default" do
    subject { UserWithSinglePreference.create }

    let(:expected_preferences) do
      ["private_mode"]
    end

    it_behaves_like "A model with preferences"

    context "Attributes" do
      it "fetches the default value for a preference" do
        value = subject.preference(:private_mode)

        expect(value).to eq(true)
      end

      it "responds to a predicate method for a preference" do
        expect(subject.private_mode?).to eq(true)
      end

      it "sets the value for a preference then fetches it" do
        subject.private_mode = false

        expect(subject.preference(:private_mode)).to eq(false)

        subject = User.first

        expect(subject.preference(:private_mode)).to eq(false)
      end

      context "Type casting" do
        it "casts the value of a prefence to a given type" do
          value = subject.preference(:private_mode)

          expect(value).to be_instance_of(TrueClass)
        end
      end
    end
  end

  context "A model with a single preference, no default" do
    subject { UserWithSinglePreferenceNoDefault.create }

    let(:expected_preferences) do
      ["private_mode"]
    end

    it_behaves_like "A model with preferences"

    context "Attributes" do
      it "defaults to nil" do
        value = subject.preference(:private_mode)

        expect(value).to be_nil
      end

      it "responds to a predicate method for a preference" do
        expect(subject.private_mode?).to eq(false)
      end
    end

    context "Type casting" do
      it "returns a string because it doesn't know how to typecast" do
        subject.private_mode = true

        expect(subject.preference(:private_mode)).to eq("t")

        subject = UserWithSinglePreferenceNoDefault.first

        expect(subject.preference(:private_mode)).to eq("t")
      end
    end
  end
end
