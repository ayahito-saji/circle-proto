class Animations < Array
  def to_js(callback)
    js_code = ""
    self.each do |datum|
      js_code += "$(\"#_#{datum[:id]}\").css(#{datum_to_options(datum[:start]).to_json});";
    end
    js_code += to_js_sub(self, callback)
    return js_code
  end

  def update_view_objects(view_objects)
    self.each do |datum|
      datum[:end].each_key do |key|
        view_objects[datum[:id]].set_param(key, datum[:end][key])
      end
    end
    return view_objects
  end

  private
  def to_js_sub(data, callback)
    code = ""
    loop do
      datum = data.shift
      code += "$(\"#_#{datum[:id]}\").animate(#{datum_to_options(datum[:end]).to_json}, #{datum[:time] * 1000}"
      break if data.blank? || data[0][:timing] == :after
      code += ");"
    end
    code += ", 'swing', function(){"
    code += to_js_sub(data, callback) if !data.blank? && data[0][:timing] == :after
    code += callback if data.blank?
    code += "}"

    code += ");"
    return code
  end

  def datum_to_options(datum)
    options = {}
    datum.each_key do |key|
      case key
        when :top, :left, :bottom, :right, :width, :height
          options[key] = "#{datum[key]}%"
        when :size
          options[:fontSize] = "#{datum[:size]}vw"
        else
          options[key] = datum[key]
      end
    end
    return options
  end

end