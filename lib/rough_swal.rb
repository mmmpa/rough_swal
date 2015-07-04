module RoughSwal
  PARAMETERS = [
      :title,
      :text,
      :type,
      :allow_escape_key,
      :custom_class,
      :allow_outside_click,
      :show_cancel_button,
      :show_confirm_button,
      :confirm_button_text,
      :confirm_button_color,
      :cancel_button_text,
      :close_on_confirm,
      :close_on_cancel,
      :image_url,
      :image_size,
      :timer,
      :html,
      :animation,
      :input_type,
      :input_placeholder,
      :input_value,
      :function,
  ]


  def self.configure(&block)
    Configure.(&block) if block_given?
  end


  module ParamsSetter
    RoughSwal::PARAMETERS.each do |name|
      class_eval <<-EOS
        def #{name}(value)
          @swal_params['#{name}'] = value
        end
      EOS
    end
  end


  class Alert
    include ParamsSetter


    def initialize(session, &block)
      @swal_params = Default.params
      instance_eval(&block)
      Caller.sweet_alert(session, :sweet_alert, @swal_params)
    end


    def method_missing(name, pre_title = nil, pre_text = nil)
      params = Preset.find(name) || super
      @swal_params.merge!(params)
      title pre_title
      text pre_text if pre_text
    end
  end


  class Caller
    class << self
      def sweet_alert(session, session_name, swal_params)
        session[session_name] = swal_params
      end
    end
  end


  class Configure
    def self.call(&block)
      instance_eval(&block)
    end


    def self.default(&block)
      Default.(&block) if block_given?
    end


    def self.preset(name, &block)
      Preset.(name, &block) if block_given?
    end
  end


  class Default
    include ParamsSetter


    def self.call(&block)
      @default = new
      @default.instance_eval(&block)
    end


    def self.params
      @default ? @default.params : {}
    end


    def initialize
      @swal_params = {}
    end


    def params
      @swal_params || {}
    end
  end


  class Preset
    def self.call(name, &block)
      @preset ||= {}
      @preset[name] = Default.new.tap do |preset|
        preset.instance_eval(&block)
      end
    end


    def self.find(name)
      @preset[name].try(:params) || (raise NotFound)
    end


    class NotFound < StandardError

    end
  end


  class Renderer
    class << self
      def call(*args)
        new(*args)
      end
    end


    def initialize(session)
      @session = session
    end


    def render
      return ' ' if (params = @session.delete(:sweet_alert)).nil?

      tag(code(parse(params))).html_safe
    end


    def code(params)
      function = if (function = params.delete('function')).present?
                   "," + function
                 end

      "swal(#{params.to_json}#{function});"
    end


    def parse(params)
      params.map do |key, value|
        [key.to_s.camelize(:lower), value]
      end.to_h
    end


    def tag(js)
      "<script>#{js}</script>"
    end
  end


  self.configure do
    preset(:success) { type :success }
    preset(:info) { type :info }
    preset(:warning) { type :warning }
    preset(:error) { type :error }
  end


  module ::ActionController
    module Renderers
      def _render_template(options)
        super.tap do |rendered|
          rendered.try(:<<, RoughSwal::Renderer.(session).render) if formats.first == :html
        end
      end
    end


    class Base
      def swal(&block)
        RoughSwal::Alert.new(session, &block)
      end
    end
  end
end