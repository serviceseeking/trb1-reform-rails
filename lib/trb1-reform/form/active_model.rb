require "trb1-uber/delegates"

module Trb1::Reform::Form::ActiveModel
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      register_feature ActiveModel

      extend Trb1::Uber::Delegates
      delegates :model, *[:persisted?, :to_key, :to_param, :id] # Trb1::Uber::Delegates

      def to_model # this is called somewhere in FormBuilder and ActionController.
        self
      end
    end
  end


  module ClassMethods
    # this module is only meant to extend (not include). # DISCUSS: is this a sustainable concept?
    def self.extended(base)
      base.class_eval do
        extend Trb1::Uber::InheritableAttribute
        inheritable_attr :model_options
      end
    end

    # DISCUSS: can we achieve that somehow via features in build_inline?
    def property(*)
      super.tap do |dfn|
        return dfn unless dfn[:nested]
        _name = dfn[:name]
        dfn[:nested].instance_eval do
          @_name = _name.singularize.camelize
          # this adds Form::name for AM::Validations and I18N.
          def name
            @_name
          end
        end
      end
    end


    # Set a model name for this form if the infered is wrong.
    #
    #   class CoverSongForm < Trb1::Reform::Form
    #     model :song
    #
    # or we can setup a isolated namespace model ( which defined in isolated rails egine )
    #
    #   class CoverSongForm < Trb1::Reform::Form
    #     model "api/v1/song", namespace: "api"
    def model(main_model, options={})
      self.model_options = [main_model, options]
    end

    def model_name
      if model_options
        form_name = model_options.first.to_s.camelize
        namespace = model_options.last[:namespace].present? ? model_options.last[:namespace].to_s.camelize.constantize : nil
      else
        if name
          form_name = name.sub(/(::)?Form$/, "") # Song::Form => "Song"
          namespace = nil
        else # anonymous forms. let's drop AM and forget about all this.
          form_name = "reform"
          namespace = nil
        end
      end

      active_model_name_for(form_name, namespace)
    end

  private
    def active_model_name_for(string, namespace=nil)
      return ::ActiveModel::Name.new(OpenStruct.new(:name => string)) if Trb1::Reform.rails3_0?
      ::ActiveModel::Name.new(self, namespace, string)
    end
  end # ClassMethods


  def model_name(*args)
    self.class.model_name(*args)
  end
end
