require_relative 'cards'
require_relative 'person'
require_relative 'player'
require_relative 'dealer'

class Engine
  CHIPS = 100
  BET = 10
  ACTIONS = [
    { id: 0, title: 'Пропуск хода', action: :player_skip },
    { id: 1, title: 'Взять карту', action: :add_card },
    { id: 2, title: 'Открыть карты', action: :show_cards }
  ].freeze

  attr_reader :player, :dealer, :card_deck

  def initialize
    puts 'Игра Black Jack.'
    puts "У вас в банке $#{CHIPS}"
    puts "Размер одной ставки $#{BET}"
    puts
    print 'Введите ваше имя:'
    player_name = gets.chomp.capitalize
    puts "Удачи, #{player_name}!"
    puts
    @player = Player.new(player_name, CHIPS)
    @dealer = Dealer.new('Дилер', CHIPS)
    @card_deck = Cards.new
  end

  def run
    loop do
      puts '=============================='
      sleep(1)
      player.place_bet(BET)
      dealer.place_bet(BET)
      sleep(1)
      puts
      take_card(player, 2)
      player.show_points
      sleep(1)
      puts
      take_card(dealer, 2)
      sleep(1)
      puts
      action
      sleep(1)
      continue?
    end
  end

  def take_card(who, amount_of_cards = 1)
    amount_of_cards.times { who.take_card(card_deck.random_card) }
  end

  def action
    ACTIONS.each { |item| puts "#{item[:id]} - #{item[:title]}" }
    print 'Ваши действия: '
    choice = gets.chomp
    raise 'Введите или 0, или 1, или 2.' unless %w[0 1 2].include?(choice)

    puts
    send(ACTIONS[choice.to_i][:action])
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def player_skip
    dealer_turn_second
  end

  def add_card
    take_card(player)
    player.show_points
    if player.count_points > 21
      puts 'Упс, перебор. Вы проиграли.'
      take_bank(dealer)
      continue?
    else
      dealer_turn
    end
  end

  def show_cards
    who_win
  end

  def continue?
    puts 'Сыграем ещё раз?'
    puts '1 - да; 0 - нет'
    answer = gets.chomp
    case answer
    when '1'
      reset_data
      run
    when '0'
      exit
    end
    raise 'Введите 1 если желаете продолжить игру, 0 - выйти из игры.' unless %w[0 1].include?(answer)
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def dealer_turn
    if dealer.count_points >= 17
      puts 'Дилер пропускает ход'
      who_win
    else
      take_card(dealer)
      puts 'Дилер взял одну карту.'
      who_win
    end
  end

  def return_to_player_turn
    arr = ACTIONS.drop(1)
    arr.each { |item| puts "#{item[:id]} - #{item[:title]}" }
    print 'Ваши действия: '
    choice = gets.chomp
    raise 'Введите 1 или 2' unless %w[1 2].include?(choice)

    puts
    send(arr[choice.to_i - 1][:action])
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def dealer_turn_second
    if dealer.count_points >= 17
      puts 'Дилер пропускает ход'
      return_to_player_turn
    else
      take_card(dealer)
      puts 'Дилер взял одну карту.'
      return_to_player_turn
    end
  end

  def who_win
    puts
    puts '-----Вскрытие карт-----'
    sleep(1)
    if player.count_points > dealer.count_points || dealer.count_points > 21
      take_bank(player)
      dealer_cards_and_points
      puts 'Поздравляем! Вы победили.'
      puts "Ваш банк: $#{player.chips}"
    elsif player.count_points < dealer.count_points
      take_bank(dealer)
      dealer_cards_and_points
      puts 'Вы проиграли.'
      puts "Ваш банк: $#{player.chips}"
    else
      return_bet(dealer)
      return_bet(player)
      dealer_cards_and_points
      puts 'Ничья. Ставки возвращаются.'
      puts "Ваш банк: $#{player.chips}"
    end
  end

  def take_bank(who)
    who.chips += 2 * BET
  end

  def return_bet(who)
    who.chips += BET
  end

  def dealer_cards_and_points
    puts 'Карты дилера:'
    dealer.show_cards
    dealer.show_points
    puts '-----------------------'
    puts
  end

  def reset_data
    player.cards.clear
    player.points.clear
    dealer.cards.clear
    dealer.points.clear
  end
end
