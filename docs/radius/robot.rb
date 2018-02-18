class Robot
  attr_accessor :age, :name
  @@count = 0
  def initialize(**params)
    if params[:name]
      @name = params[:name]
    end
    if params[:age]
      @age = params[:age]
    end
    @@count += 1
  end
  def sayHello
    puts("Hello!")
  end
  def sayGoodBye
    puts("goodbye")
  end
  def count
    return @@count
  end
  def count= val
    @@count = val
  end
end

if __FILE__== $0
  robo1 = Robot.new(name: 'Robot1', age: 20)
  puts(" name: #{robo1.name}")
  puts("  age: #{robo1.age}")
  puts("count: #{robo1.count}")
  str1 = Marshal.dump(robo1)
  puts(str1)

  robo3 = Marshal.load(str1)
  puts(" name: #{robo3.name}")
  puts("  age: #{robo3.age}")
  puts("count: #{robo3.count}")

end