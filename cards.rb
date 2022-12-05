class Cards
  SUITS = ['♥', '♦', '♣', '♠'].freeze
  RANKS = %w[A 2 3 4 5 6 7 8 9 10 J Q K].freeze
  VALUES = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10].freeze

  attr_reader :card_deck

  def initialize
    @card_deck = []
    generate_deck
  end

  def generate_deck
    SUITS.each do |suit|
      RANKS.each_with_index do |rank, index|
        @card_deck << { suit: suit, rank: rank, scored: VALUES[index] }
      end
    end
    card_deck.shuffle
  end

  # случайная карта из бесконечной колоды
  def random_card
    card_deck.sample # sample случайный элемент массива
  end
end
