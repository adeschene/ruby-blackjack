require_relative "blackjack"
require_relative "players"

# Game session variables
user_quit  = false # Keeps track of whether user chose to quit playing
first_game = true # Keeps track of whether this is user's first game

wins  = 0 # Keep track of user's wins
loses = 0 # Keep track of dealer's wins

# Session loop
while user_quit == false
  # Initialize game
  game = Blackjack.new
  game.initial_deal

  divider = "\n" + "-" * 38 + "\n" # Visual divider for output readibility

  # Display intro text (alternate text for a little pun ^_^)
  print divider + (first_game ? "\n\n%30s\n" % "Welcome to BLACKJACK!"
    : "\n\n%29s\n" % "Welcome BACK, JACK!")
  print "\n%25s\n\n" % "SCORE: #{wins} - #{loses}" # Display score

  # Game loop
  while game.winner == nil
    print divider # Visual divider for readability
    game.show_hands # Display hands to user
    game.evaluate_game # Evaluate hands; hits, stays, determine winner
  end

  # Announce winner, iterate score
  if game.winner == 'user'
    wins += 1
    print "\n%24s\n" % "You won!"
  else
    loses += 1
    print "\n%25s\n" % "You lost..."
  end
  gets # Pause for user to see action

  # Prompt for user to play another game
  print divider + "\n%36s" % "Do you want to play again? (y/n): "
  user_quit = true if gets.chomp != 'y'

  # Make it known that the next game won't be user's first
  first_game = false if first_game
end
