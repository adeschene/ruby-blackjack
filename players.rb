class Player # A player in the game; has a hand consisting of cards
  attr_accessor :hand # Allows us to get and set 'hand' outside of class

  def initialize
    @hand = [] # Create empty hand array
  end
end

class Dealer < Player # Is a player; has the deck; deals cards
  def initialize
    super() # Required to initialize variables in parent class
    # Basically 8 decks worth of cards, with aces always worth 11
    @deck = [2,3,4,5,6,7,8,9,10,10,10,10,11] * 32
  end

  def deal_card
    @deck.sample # Return a random card between 2 and 11
  end
end

class User < Player # Is a player; has the ability to stay
  attr_accessor :stayed # Allows us to get 'stayed' outside of class

  def initialize
    super() # Required to initialize variables in parent class
    @stayed = false # Tracks whether user has stayed
  end
end
