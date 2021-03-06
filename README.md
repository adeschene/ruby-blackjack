Eleventh Ruby on Rails Bootcamp assignment.

A simple blackjack CLI game written in Ruby.

INSTRUCTIONS:
  - Download all files to the same folder.
  - Make sure Ruby is installed.
  - If you want to run tests, make sure RSpec is installed.
  - To play:
    - In terminal: ruby game.rb
  - To test:
    - In terminal: ruby tests.rb

NOTES:
  - All Aces are currently worth 11, so the player can actually draw two aces and lose immediately, which doesn't feel right.
  - Dealer only bets on a hand that's less than 17.
  - A draw always goes to the house. If betting were implemented, this would change.
  - A user can play many games during one run of the program, and a score is kept/displayed.

TODO:
  - Add betting, side wagers.
  - Splitting, obscure rules.
  - Implement Aces correctly.
