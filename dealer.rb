class Dealer < Person
  def take_card(random_card)
    super(random_card)
    puts 'XX'
  end
end
