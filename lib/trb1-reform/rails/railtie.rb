module Trb1
  module Reform
    module Rails
      class Railtie < ::Rails::Railtie
        config.trb1_reform = ActiveSupport::OrderedOptions.new

        initializer "trb1.reform.form_extensions", after: :load_config_initializers do
          validations = config.trb1_reform.validations || :active_model

          if validations == :active_model
            active_model!
          elsif validations == :dry
            dry!
          else
            warn "[Trb1::Reform::Rails] No validation backend set. Please do so via `config.trb1.reform.validations = :active_model`."
          end
        end

        def active_model!
          require "trb1-reform"
          require "trb1-reform/form/active_model/model_validations"
          require "trb1-reform/form/active_model/form_builder_methods"
          require "trb1-reform/form/active_model"
          require "trb1-reform/form/active_model/validations"
          require "trb1-reform/form/multi_parameter_attributes"

          require "trb1-reform/active_record" if defined?(ActiveRecord)
          require "trb1-reform/mongoid" if defined?(Mongoid)

          Trb1::Reform::Form.class_eval do
            include Trb1::Reform::Form::ActiveModel
            include Trb1::Reform::Form::ActiveModel::FormBuilderMethods
            include Trb1::Reform::Form::ActiveRecord if defined?(ActiveRecord)
            include Trb1::Reform::Form::Mongoid if defined?(Mongoid)
            include Trb1::Reform::Form::ActiveModel::Validations
          end
        end

        def dry!
          require "trb1-reform"
          require "trb1-reform/form/dry"

          require "trb1-reform/form/multi_parameter_attributes"
          require "trb1-reform/form/active_model/form_builder_methods" # this is for simple_form, etc.

          # This adds Form#persisted? and all the other crap #form_for depends on. Grrrr.
          require "trb1-reform/form/active_model" # DISCUSS: only when using simple_form.

          Trb1::Reform::Form.class_eval do
            include Trb1::Reform::Form::ActiveModel # DISCUSS: only when using simple_form.
            include Trb1::Reform::Form::ActiveModel::FormBuilderMethods

            include Trb1::Reform::Form::Dry
          end
        end
      end # Railtie
    end
  end
end
