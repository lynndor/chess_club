# db/scripts/add_members.rb
# Run with: rails runner db/scripts/add_members.rb

names = [
  ["Magnus", "Carlsen"],
  ["Hikaru", "Nakamura"],
  ["Fabiano", "Caruana"],
  ["Ian", "Nepomniachtchi"],
  ["Ding", "Liren"],
  ["Anish", "Giri"],
  ["Levon", "Aronian"],
  ["Wesley", "So"],
  ["Teimour", "Radjabov"],
  ["Shakhriyar", "Mamedyarov"],
  ["Maxime", "Vachier-Lagrave"],
  ["Sergey", "Karjakin"],
  ["Viswanathan", "Anand"],
  ["Richard", "Rapport"],
  ["Jan-Krzysztof", "Duda"],
  ["Alireza", "Firouzja"]
]

names.each_with_index do |(first, last), idx|
  email = "#{first.downcase}.#{last.downcase.gsub(/[^a-z]/, '')}@example.com"
  Member.create!(
    name: first,
    surname: last,
    email: email,
    current_rank: idx + 1
  )
end

puts "Added 16 members."
