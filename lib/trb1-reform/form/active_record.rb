require "trb1-reform/form/orm"

module Trb1::Reform::Form::ActiveRecord
  def self.included(base)
    base.class_eval do
      register_feature Trb1::Reform::Form::ActiveRecord
      include Trb1::Reform::Form::ActiveModel
      include Trb1::Reform::Form::ORM
      extend ClassMethods
    end
  end

  module ClassMethods
    def validates_uniqueness_of(attribute, options={})
      options = options.merge(:attributes => [attribute])
      validates_with(UniquenessValidator, options)
    end
    def i18n_scope
      :activerecord
    end
  end

  def to_nested_hash(*)
    super.with_indifferent_access
  end

  class UniquenessValidator < ::ActiveRecord::Validations::UniquenessValidator
    include Trb1::Reform::Form::ORM::UniquenessValidator
  end
end
