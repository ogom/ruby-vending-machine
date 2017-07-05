class DrinkStore
  attr_reader :state

  def initialize()
    @state = {
      drinks: []
    }
  end

  def insert(drink)
    dispatch({type: :insert, payload: drink})
  end

  def eject(name)
    dispatch({type: :eject, payload: name})
  end

  def find(name)
    state[:drinks].find do |drink|
      drink.name == name
    end
  end

  private
  def reducer(state, action)
    case action[:type]
    when :insert
      state[:drinks] << action[:payload]
    when :eject
      index = state[:drinks].map(&:name).index(action[:payload])
      state[:drinks].delete_at(index)
    end
    state
  end

  def dispatch(action)
    @state = reducer(state, action)
  end
end
