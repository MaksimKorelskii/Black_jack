class Person
  attr_reader :points, :cards, :name
  attr_accessor :chips

  def initialize(name, chips)
    @name = name
    @chips = chips
    @cards = []
    @points = []
  end

  def place_bet(bet)
    @chips -= bet
    puts "#{name}, ставка $#{bet}, осталось $#{chips}"
  end

  def take_card(random_card)
    @cards << random_card
    @points << @cards.last[:scored]
  end

  def count_points
    count = []
    points.each do |point|
      count << if count.sum + point > 21 && (count.include?(11) || point == 11)
                 point - 10
               else
                 point
               end
    end
    count.sum
  end

  def show_points
    puts "#{name}, очки: #{count_points}"
  end

  def show_cards
    @cards.each do |card|
      puts "#{card[:suit]}#{card[:rank]}"
    end
  end
end
