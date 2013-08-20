actions :install

def initialize(*args)
  super
  @action = :install
end

attribute :user, kind_of: String
attribute :home_directory, kind_of: String
attribute :version, kind_of: String
attribute :make_default, kind_of: [TrueClass, FalseClass], default: false
