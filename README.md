# Preferential

Sometimes storing preference data for users (or other types of object) can result in database tables with tons of very infrequently-accessed columns. This isn't always a problem, especially if you optimise your queries everywhere - but sometimes doing this is unwieldy. **Preferential** is a Rails gem that can make the extraction of this "metadata" to another table quick and painless.

## Installation

TBD

## Usage

First, you'll need to generate a migration to create the preferences table:

    $ rails generate preferential migration
    $ rake db:migrate

You can then define preferences for your models like this:

    class User < ActiveAdmin::Base
      has_preference :time_zone
      has_preference :language
      has_preference :send_newsletter
    end

That's it! You can then read and write this preference as you would a normal model attribute:

    user = User.find(3)
    user.time_zone # => "JST"
    user.language = "Japanese"
    user.language # => "Japanese"
    user.send_newsletter? # => true

### Advanced Configuration

Along with the name of the preference attribute, you can also (optionally) provide a `default` value for preferences and a `type`. A preference's `type` will be inferred from its `default` if no `type` is provided but a `default` is.

    class User < ActiveAdmin::Base
      has_preference time_zone: { type: :string }
      has_preference language: { type: :string, default: "Japanese" }
      has_preference send_newsletter: { default: false }
    end

The accepted values for `type` are:

* `:boolean`
* `:string`
* `:float`
* `:integer`

You can also define multiple preferences at once:

    class User < ActiveAdmin::Base
      has_preference time_zone: { type: :string }, language: { type: :string, default: "Japanese" }
    end
