class MoneyStore
  attr_reader :state

  def initialize()
    @state = {
      moneys: [],
      amount: 0
    }
  end

  def insert(money)
    dispatch({type: :insert, payload: money})
  end

  def eject(name)
    dispatch({type: :eject, payload: name})
  end

  def select(amount)
    state[:moneys].select {|money| amount >= money.value ? amount = amount - money.value : false } 
  end

  private
  def reducer(state, action)
    case action[:type]
    when :insert
      state[:moneys] << action[:payload]
    when :eject
      amount = action[:payload]
      state[:moneys].reject! {|money| amount >= money.value ? amount = amount - money.value : false } 
    end
    state[:moneys].sort_by! {|money| - money.value }
    state[:amount] = state[:moneys].map(&:value).reduce(0, :+)
    state
  end

  def dispatch(action)
    @state = reducer(state, action)
  end
end
