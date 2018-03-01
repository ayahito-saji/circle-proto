module PlayObjects
  load 'animations.rb'
  load 'view_object.rb'
  # テキストオブジェクトのソースコードを返します
  # paramsで
  def text_object(**params)
    puts(params)
    params[:tag] = 'span' if !params[:tag]
    option = {}
    option[:href] = 'javascript:void(0)' if params[:tag] == 'a'
    option[:id] = params[:id] if params[:id]
    option[:text] = params[:text] if params[:text]
    option[:css] = params[:css] ? params[:css] : {}
    option[:css][:position] = 'absolute'
    if params[:home] == 'center'
      option[:css][:webkitTransform] = 'translate(-50%,-50%)'
      option[:css][:transform] = 'translate(-50%,-50%)'
    end
    option[:css][:top] = "#{params[:top]}%" if params[:top]
    option[:css][:left] = "#{params[:left]}%" if params[:left]
    option[:css][:right] = "#{params[:right]}%" if params[:right]
    option[:css][:bottom] = "#{params[:bottom]}%" if params[:bottom]
    option[:css][:width] = "#{params[:width]}%" if params[:width]
    option[:css][:height] = "#{params[:height]}%" if params[:height]
    option[:css][:fontSize] = params[:size] ? "#{params[:size]}vw" : "2vw"
    option[:css][:color] = params[:color] ? params[:color] : "#ffffff"
    option[:css][:opacity] = params[:opacity] ? params[:opacity] : 1
    return "$(\"#play-screen\").append($(\"<#{params[:tag]}></#{params[:tag]}>\", #{option.to_json}));"
  end

  def object_animation(data)
    code = ""
    data.each do |datum|
      code += "$(\"##{datum[:id]}\").css(#{animation_object_option(datum[:start]).to_json});";
    end
    code += sub_object_animation(data)
    puts code
    return code
  end
  def sub_object_animation(data)
    code = ""
    loop do
      datum = data.shift
      code += "$(\"##{datum[:id]}\").animate(#{animation_object_option(datum[:end]).to_json}, #{datum[:time] * 1000}"
      break if data.blank? || data[0][:timing] == :after
      code += ");"
    end
    code += ", 'swing', function(){#{sub_object_animation(data)}}" if !data.blank? && data[0][:timing] == :after
    code += ");"
    return code
  end
  def animation_object_option(option)
    option[:fontSize] = "#{option[:size]}vw" if option[:size]
    option[:top] = "#{option[:top]}%" if option[:top]
    option[:left] = "#{option[:left]}%" if option[:left]
    option[:right] = "#{option[:right]}%" if option[:right]
    option[:bottom] = "#{option[:bottom]}%" if option[:bottom]
    return option
  end
end