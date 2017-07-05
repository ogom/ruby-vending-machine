class Drink
  attr_reader :name, :price

  def initialize(name, price)
    @name, @price = name, price
  end

  def to_h
    { name: @name, price: @price }
  end
end
