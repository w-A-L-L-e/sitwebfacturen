# frozen_string_literal: true

# Application record all model classes derive from this
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
