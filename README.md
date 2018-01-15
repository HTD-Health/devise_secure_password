# DeviseSecurePassword
DeviseSecurePassword is a Devise extension for enchancing security.

It is composed of 4 additional Devise modules:

* `password_validatable` - check password complexity.
* `password_archivable` - prohibit using old passwords.
* `password_uncommonable` - prohibit using 100k most common password and add passwords which should be forbidden.
* `password_expirable` - force user to change password after given time.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise_secure_password'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install devise_secure_password
```

## Configuration
```ruby
module Devise
  # Validate password for strength
  mattr_accessor :password_regex
  @@password_regex = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!"#$%&'()*+,-.\/:;<=>?@\\\[\]^_`{|}~])/

  # Number of old passwords in archive
  mattr_accessor :password_archiving_count
  @@password_archiving_count = 5

  # Should the password expire (e.g 3.months)
  mattr_accessor :expire_password_after
  @@expire_password_after = 3.months
end
```

## Schema

### Password expirable
```ruby
create_table :the_resources do |t|
  # other devise fields

  t.datetime :password_changed_at
end
add_index :the_resources, :password_changed_at
```

### Password archivable
```ruby
create_table :old_passwords do |t|
  t.string :encrypted_password, :null => false
  t.string :password_archivable_type, :null => false
  t.integer :password_archivable_id, :null => false
  t.datetime :created_at
end
add_index :old_passwords, [:password_archivable_type, :password_archivable_id], :name => :index_password_archivable
```

### Password uncommonable
```ruby
create_table :common_passwords do |t|
  t.string :password

  t.timestamps
end
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
