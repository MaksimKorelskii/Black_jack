class Player < Person
  def take_card(random_card)
    super(random_card)
    puts "#{@cards.last[:suit]}#{@cards.last[:rank]}"
  end
end
