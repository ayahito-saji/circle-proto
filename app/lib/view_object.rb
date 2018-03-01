class ViewObject
  attr_accessor :params
  def initialize(id, type, **params)
    @id = "_#{id}"
    @type = type
    @params = params
  end
  def to_js
    js_code = ""
    options = params_parser
    case @type
      when :HeadText
        options[:attr][:class] = "head-text"
        options[:attr][:title] = options[:attr][:text]
        js_code += "var #{@id} = $(\"<span></span>\", #{options[:attr].to_json});"
      when :Link
        options[:attr][:href] = "javascript:void(0)"
        js_code += "var #{@id} = $(\"<a></a>\", #{options[:attr].to_json});"
    end
    js_code += "#{@id}.on({#{options[:on].join(',')}});" if options[:on].length > 0
    js_code += "$(\"#play-screen\").append(#{@id});"
    return js_code
  end
  def set_param(key, value)
    @params[key] = value
  end

  private
  def params_parser
    options = {
        attr: {},
        on: []
    }
    options[:attr][:id] = @id
    options[:attr][:css] = {
        position: "absolute"
    }
    @params.each_key do |key|
      case key
        when :top, :left, :bottom, :right, :width, :height
          options[:attr][:css][key] = "#{@params[key]}%"
        when :size
          options[:attr][:css][:fontSize] = "#{@params[:size]}vw"
        when :home
          if @params[:home] == :center
            options[:attr][:css][:webkitTransform] = "translate(-50%,-50%)"
            options[:attr][:css][:transform] = "translate(-50%,-50%)"
          end
        when :opacity, :color
          options[:attr][:css][key] = @params[key]
        when :on
          @params[:on].each_key do |key|
            options[:on].append("'#{key}': function(){#{@params[:on][key]}}")
          end
        else
          options[:attr][key] = @params[key]
      end
    end
    return options
  end
end