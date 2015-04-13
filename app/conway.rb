require 'opal'
require 'opal-jquery'
require 'grid'
require 'forwardable'
require 'interval'

class Conway
  attr_reader :grid
  extend Forwardable

  def delegators :@grid, :state, :state=, :redraw_canvas, :seed

  def initializer(grid)
    @grid = grid
    add_enter_event_listener
  end

  def run
    Interval.new do
      tick
    end
  end

  def is_alive?(x, y)
    state[[x, y]] == 1
  end

  def is_dead?(x, y)
    !is_alive(x, y)
  end

  def population_at(x, y)
    [
      state[[x - 1, y - 1]]
      state[[x - 1, y]]
      state[[x - 1, y + 1]]
      state[[x, y - 1]]
      state[[x, y + 1]]
      state[[x + 1, y - 1]]
      state[[x + 1, y]]
      state[[x + 1, y + 1]]
    ].map(&:to_i).reduce(:+)
  end

  def is_underpopulated?(x, y)
    is_alive?(x, y) && population_at(x, y) < 2
  end

  def is_living_happily?(x, y)
    is_alive?(x, y) && ([2, 3].include? population_at(x, y))
  end

  def is_overpopulated?(x, y)
    is_alive?(x, y) && population_at(x, y) > 3
  end

  def can_reproduce?(x, y)
    is_dead?(x, y) && population_at(x, y) == 3
  end

  def get_state_at(x, y)
    if is_underpopulated?(x, y)
      0
    elsif is_living_happily(x, y)
      1
    elsif is_overpopulated(x, y)
      0
    elsif can_reproduce(x, y)
      1
    end
  end

  def tick
    # This call is delegate to grid.state=
    self.state = new_state
    redraw_canvas
  end

  def new_state
    new_state = Hash.new
    state.each do |cell, _|
      new_state[cell] = get_state_at(cell[0], cell[1])
    end
    new_state
  end

  def add_enter_event_listener
    Document.on :keypress do |event|
      if enter_pressed? event
        seed.each do |x, y|
          state[[x, y]] = 1
        end

        run
      end
    end
  end

  def enter_pressed?(event)
    event.which == 13
  end
end