class Money
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def value
    @value ||= to_value
  end

  def valid?
    value > 0
  end

  private
  def to_value
    case name
    when "10円玉"
      10
    when "50円玉"
      50
    when "100円玉"
      100
    when "500円玉"
      500
    when "1000円札"
      1000
    else
      0
    end
  end
end
