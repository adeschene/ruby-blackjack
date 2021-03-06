class Blackjack # Handles the game logic, flow, rules, etc.
  attr_reader :winner # Allows us to get 'winner' outside of class

  def initialize
    # Variables to keep track of the user, dealer, and if/who won the game
    @user   = User.new
    @dealer = Dealer.new
    @winner = nil
  end

  def initial_deal # The dealer deals 2 cards to each player
    while @user.hand.to_a.count < 2 and @dealer.hand.to_a.count < 2
      @user.hand = @user.hand.push(@dealer.deal_card)
      @dealer.hand = @dealer.hand.push(@dealer.deal_card)
    end
  end

  def evaluate_game # Check for win/lose states, handle player turns, hits, etc.
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
      else print "Error in evaluate_game" # Shouldn't ever be here
      end
    end
  end

  def show_hands # Print dealer (obsured if user playing) and user hands
    format_hand = lambda {
      |cards| cards.map { |card| "\e[5;30;47m%2s%1s\e[0m" % [card,""] }.join(" ")
    }
    # If user stayed, display dealers full hand/sum
    dealer_info = @user.stayed ? [ @dealer.hand, @dealer.hand.sum ]
      # While user is playing, obscure dealer info
      : [ ['X', @dealer.hand[1]], ">#{@dealer.hand[1]}" ]
    dealer_string = "\n%8s\n" % "%-60s" % "Dealer's hand: [ #{format_hand.call(dealer_info[0])} ] == #{dealer_info[1]}"
    user_string   = "\n%12s\n\n" % "%-60s" % "Your hand: [ #{format_hand.call(@user.hand)} ] == #{@user.hand.sum}"
    print dealer_string + user_string
  end

  private # Private methods are only callable from inside the class
    def prompt_user # Prompt user to hit or stay; react to decision
      print "\n%34s" % "What will you do? (hit/stay): "

      input = gets.chomp # Get user input from console

      case input
      when 'hit','h'
        hit('user')
      when 'stay','s'
        @user.stayed = true
        print "\n\n%25s\n" % "You stayed."
        gets # Pause for user to see action
      else
        prompt_user # Restart function if user entered something invalid
      end
    end

    def hit(player) # Have dealer deal a card to whichever player is hitting
      # Ruby passes by value (kind of?), so assignment must be done this way
      player == 'user' ? @user.hand = @user.hand.push(@dealer.deal_card)
        : @dealer.hand = @dealer.hand.push(@dealer.deal_card)
      print "\n\n%#{player == 'user' ? 24 : 26}s\n" % (player == 'user' ? "You hit." : "Dealer hits.")
      gets # Pause for user to see action
    end
end
