class ViewObject
  attr_accessor :params
  def initialize(id, type, **params)
    @id = "_#{id}"
    @type = type
    @params = params
  end
  def to_js
    js_code = ""
    case @type
      when :HeadText
        options = params_to_options
        options[:class] = "head-text"
        options[:title] = options[:text]
        js_code += "var #{@id} = $(\"<span></span>\", #{options.to_json});"
        js_code += "$(\"#play-screen\").append(#{@id});"
    end
    return js_code
  end
  def set_param(key, value)
    @params[key] = value
  end

  private
  def params_to_options
    options = {}
    options[:id] = @id
    @params.each_key do |key|
      case key
        when :top, :left, :bottom, :right, :width, :height
          options[:css] = {} if options[:css].nil?
          options[:css][key] = "#{@params[key]}%"
        when :size
          options[:css] = {} if options[:css].nil?
          options[:css][:fontSize] = "#{@params[:size]}vw"
        when :home
          if @params[:home] == :center
            options[:css] = {} if options[:css].nil?
            options[:css][:webkitTransform] = "translate(-50%,-50%)"
            options[:css][:transform] = "translate(-50%,-50%)"
          end
        when :opacity, :color
          options[:css] = {} if options[:css].nil?
          options[:css][key] = @params[key]
        else
          options[key] = @params[key]
      end
    end
    return options
  end
end