class VendingMachine
  attr_reader :state

  def initialize()
    @deposit_money_store = MoneyStore.new
    @change_money_store = MoneyStore.new
    @stock_money_store = MoneyStore.new
    @stock_drink_store = DrinkStore.new
    @state = {
      deposit_amount: 0,
      change_moneys: [],
      stock_amount: 0,
      sale_drinks: [],
      stock_drinks: [],
      choose_drinks: []
    }
  end

  def insert_money(name)
    money = Money.new(name)
    money_store = money.valid? ? @deposit_money_store : @change_money_store
    money_store.insert(money)

    dispatch({type: :update_money, payload: {
      deposit_amount: @deposit_money_store.state[:amount],
      change_moneys: @change_money_store.state[:moneys]
    }})
  end

  def eject_money
    @deposit_money_store.state[:moneys].each do |money|
      @change_money_store.insert(money)
    end
    @deposit_money_store.eject(state[:deposit_amount])

    dispatch({type: :update_money, payload: {
      deposit_amount: @deposit_money_store.state[:amount],
      change_moneys: @change_money_store.state[:moneys]
    }})
  end

  def insert_drink(name, price)
    drink = Drink.new(name, price)
    @stock_drink_store.insert(drink)

    dispatch({type: :update_drink, payload: {
      stock_drinks: @stock_drink_store.state[:drinks]
    }})
  end

  def purchase_drink(name)
    drink = @stock_drink_store.find(name)
    if drink
      @deposit_money_store.select(drink.price).each do |money|
        @stock_money_store.insert(money)
      end
      @deposit_money_store.eject(drink.price)
      @stock_drink_store.eject(drink.name)
    end

    dispatch({type: :purchase_drink, payload: {
      deposit_amount: @deposit_money_store.state[:amount],
      stock_amount: @stock_money_store.state[:amount],
      stock_drinks: @stock_drink_store.state[:drinks]
    }})
  end

  private
  def reducer(state, action)
    case action[:type]
    when :update_money
      state[:deposit_amount] = action[:payload][:deposit_amount]
      state[:change_moneys] = action[:payload][:change_moneys].map(&:name)
      state[:choose_drinks] = state[:sale_drinks].select {|drink| drink[:price] <= state[:deposit_amount] }
    when :update_drink
      state[:stock_drinks] = action[:payload][:stock_drinks]
      state[:sale_drinks] = action[:payload][:stock_drinks].map(&:to_h).uniq
    when :purchase_drink
      state[:deposit_amount] = action[:payload][:deposit_amount]
      state[:stock_amount] = action[:payload][:stock_amount]
      state[:stock_drinks] = action[:payload][:stock_drinks]
      state[:sale_drinks] = action[:payload][:stock_drinks].map(&:to_h).uniq
      state[:choose_drinks] = state[:sale_drinks].select {|drink| drink[:price] <= state[:deposit_amount] }
    end
    state
  end

  def dispatch(action)
    @state = reducer(state, action)
  end
end
