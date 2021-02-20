# Handles the game logic, flow, rules, etc.
class Game
  # Allows us to get 'winner' outside of class
  attr_reader :winner

  def initialize
    # Variables to keep track of the user, dealer, and if/who won the game
    @user   = User.new
    @dealer = Dealer.new
    @winner = nil
  end

  # The dealer deals 2 cards to each player
  def initial_deal
    while @user.hand.to_a.count < 2 and @dealer.hand.to_a.count < 2
      @user.hand = @user.hand.push(@dealer.deal_card)
      @dealer.hand = @dealer.hand.push(@dealer.deal_card)
    end
  end

  # Check for win states, lose states, handle player turns, hits, etc.
  def evaluate_game
    if @user.stayed # If user has stayed, the dealer is the active player
      dealer_hand_sum = @dealer.hand.sum

      # If dealer has equal or higher value hand than user, dealer wins, unless he busted
      if dealer_hand_sum >= @user.hand.sum and dealer_hand_sum <= 21
        @winner = 'dealer'
      else
        # If dealer's hand sum < 17, dealer hits
        if (0..16).include?(dealer_hand_sum)
          hit('dealer')
        # Dealer has no options and his hand is lower than user's OR he busted
        else
          @winner = 'user'
        end
      end
    else # Otherwise, the user is the active player
      # Evaluate user's current hand
      case @user.hand.sum
      # Give user the option to hit, even when they shouldn't
      when 0..20 then prompt_user
      # If user gets a blackjack, they automatically win
      when 21 then @winner = 'user'
      # Above 21 means user busted; dealer wins (max hand sum should be 31)
      when 22..31 then @winner = 'dealer'
      else puts "Error in evaluate_game" # Shouldn't ever be here
      end
    end
  end

  def show_hands
    dealer_info = @user.stayed ?
      [ @dealer.hand, @dealer.hand.sum ] : # If user stayed, display dealers full hand/sum
      [ "[X,#{@dealer.hand[1]}]", ">#{@dealer.hand[1]}" ] # While user is playing, obscure dealer info
    puts "\nDealer's hand: #{dealer_info[0]} == #{dealer_info[1]}\nYour hand: #{@user.hand} == #{@user.hand.sum}\n"
  end

  private # Private methods are only callable from inside the class
    # Prompt user to hit or stay; react to decision
    def prompt_user
      puts "\nWhat will you do? (hit/stay):"

      input = gets.chomp # Get user input from console

      if input == 'hit'
        hit('user')
      elsif input == 'stay'
        @user.stayed = true
        puts "\nYou stayed."
      else
        prompt_user # Restart function if user entered something invalid
      end
    end

    # Have dealer deal a card to whichever player is hitting
    def hit(player)
      player == 'user' ?
        # Ruby passes by value (kind of?), so assignment must be done this way
        @user.hand = @user.hand.push(@dealer.deal_card) :
        @dealer.hand = @dealer.hand.push(@dealer.deal_card)
      puts (player == 'user' ? "\nYou" : "\nDealer").concat(" hit.")
    end
end

# A player in the game; has a hand consisting of cards
class Player
  # Allows us to get and set 'hand' outside of class
  attr_accessor :hand

  def initialize
    @hand = [] # Create empty hand array
  end
end

# Is a player; has the deck; deals cards
class Dealer < Player
  def initialize
    super() # Required to initialize variables in parent class
    # Basically 8 decks worth of cards, with aces always worth 11
    @deck = [2,3,4,5,6,7,8,9,10,10,10,10,11] * 32
  end

  def deal_card
    @deck.sample # Return a random card between 2 and 11
  end
end

# Is a player; has the ability to stay
class User < Player
  # Allows us to get 'stayed' outside of class
  attr_accessor :stayed

  def initialize
    super() # Required to initialize variables in parent class
    @stayed = false # Tracks whether user has stayed
  end
end

# Game session variables
user_quit  = false # Keeps track of whether user chose to quit playing
first_game = true # Keeps track of whether this is user's first game

# Keep track of user's wins/loses this session
wins  = 0
loses = 0

# Session loop
while user_quit == false
  # Initialize game
  game = Game.new
  game.initial_deal

  # Display intro text (alternate text for a little pun ^_^)
  puts first_game ? "\n\nWelcome to BLACKJACK!" : "\n\nWelcome BACK, JACK!"
  puts "\nSCORE: #{wins} - #{loses}" # Display score

  # Game loop
  while game.winner == nil
    game.show_hands # Display hands to user
    game.evaluate_game # Evaluate player hands, prompt/execute hits, stays, determine winner
  end

  # Announce winner, iterate score
  if game.winner == 'user'
    wins += 1
    puts "\nYou won!"
  else
    loses += 1
    puts "\nYou lost..."
  end

  # Prompt for user to play another game
  puts "\nDo you want to play again? (y/n)"
  user_quit = true if gets.chomp != 'y'

  # Make it known that the next game won't be user's first
  first_game = false if first_game
end
