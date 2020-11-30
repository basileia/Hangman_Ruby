def choose_word
  new_words = []
  File.readlines("czech_words.txt").each {
  |line| new_words << line.sub!("\r\n","")
  }
  new_words.sample.downcase
end

def hangman_pics(missed_letters)
  all_lines = []
  File.foreach("pictures.txt") { |line| all_lines << line}
  if missed_letters.length != 0
    first_index = 8 * (missed_letters.length - 1) + 1
    second_index = 8 * missed_letters.length + 1
    return all_lines[first_index...second_index]
  else
    ""
  end
end

def game_status(missed_letters)
  if missed_letters.length != 0
    picture = hangman_pics(missed_letters)
    puts picture
    print "Špatně hádaná písmena: "
    print missed_letters.join(" ") + "\n"
  else
    print ""
  end
end

def get_index_position(chosen_word, letter)
  index_pos_list = []
  for i in 0...chosen_word.length
    if chosen_word[i].include? letter
      index_pos_list << i
    end
  end
  index_pos_list
end

def move(field, position, letter)
  field[0...position] + letter + field[position + 1..-1]
end

def single_letter?(str)
  /\A[[:alpha:]]\z/.match?(str)
end

def guessing(already_guessed)
  loop do
    print("Hádej písmeno: ")
    answer = gets.chomp.downcase
    if already_guessed.include?(answer)
      puts("Toto písmeno jsi již zkoušel. Vyber jiné.")
    elsif not single_letter?(answer)
      puts("Zadej písmeno, nikoli jiný znak.")
    else
      return answer
    end
  end
end

def play_again
  while true
    print "Chceš hrát znovu? ano/ne "
    answer = gets.chomp.downcase
    if answer == "ano" || answer == "a"
      return true
    elsif answer == "ne" || answer == "n"
      return false
    else
      print "Nerozumím. Zadej ano nebo ne. "
    end
  end
end

def hangman
  puts "Vítej ve hře šibenice"
  game_is_done = false
  missed_letters = []
  correct_letters = []
  random_word = choose_word
  puts "Uhádni slovo. Dané slovo má #{random_word.length} písmen/a."
  game_field = "-" * random_word.length
  puts game_field
  while not game_is_done
    game_status(missed_letters)
    already_guessed = missed_letters + correct_letters
    guess = guessing(already_guessed)
    if !random_word.include?(guess)
        missed_letters << guess
        puts "Dané písmeno ve slově není."
        puts game_field
    else
        indexes = get_index_position(random_word, guess)
        indexes.each { |i| correct_letters << guess
        game_field = move(game_field, i, guess)}
        puts game_field
    end
    if correct_letters.length == random_word.length
        puts "Gratuluji Vyhrál jsi."
        game_is_done = true
    end
    if missed_letters.length == 10
        game_status(missed_letters)
        puts "Hledané slovo bylo: #{random_word}"
        puts "Je mi líto. Prohrál jsi."
        game_is_done = true
    end
    if game_is_done
        if play_again
            missed_letters = []
            correct_letters = []
            game_is_done = false
            random_word = choose_word
            puts "Uhádni slovo. Má #{random_word.length} písmen/a"
            game_field = "-" * random_word.length
            puts game_field
        end
      end
    end
end

hangman
