require_relative 'blackjack' # Import Blackjack class
require_relative 'players' # Import Player, Dealer, User classes
require 'rspec/autorun' # Enables RSpec testing

describe Blackjack do
  let(:game) { Blackjack.new }

  it "starts out with no winner" do
    expect(game.winner).to be_nil
  end
end

describe Player do
  let(:player) { Player.new }

  it "has an empty hand" do
    expect(player.hand).to eq([])
  end
end

describe Dealer do
  let(:dealer) { Dealer.new }

  it "has an empty hand" do
    expect(dealer.hand).to eq([])
  end

  it "can deal a card between 2 and 11" do
    expect(2..11).to cover(dealer.deal_card)
  end
end

describe User do
  let(:user) { User.new }

  it "has an empty hand" do
    expect(user.hand).to eq([])
  end

  it "has an indicator of whether it has stayed" do
    expect(user).to respond_to(:stayed)
  end

  it "starts without stayed hand" do
    expect(user.stayed).to be_falsey
  end

  it "can stay its hand" do
    expect(user).to respond_to(:stayed=)
  end
end
