class User < ActiveRecord::Base
  has_preferences private_mode: { default: true, type: :boolean },
                  send_email_on_login: { default: false },
                  maximum_login_attempts: { default: 5 }
  has_preference :time_zone
end

class UserWithSinglePreference < ActiveRecord::Base
  has_preference private_mode: { default: true }
end

class UserWithSinglePreferenceNoDefault < ActiveRecord::Base
  has_preference :private_mode
end

class Widget < ActiveRecord::Base
end
