# frozen_string_literal: true

pr_cities = [
  { name: 'Faxinal do Céu' },
  { name: 'Bituruna' },
  { name: 'Reserva do Iguaçu' }
]

pr = State.find_or_create_by(name: 'Paraná', abbreviation: 'PR')
pr_cities.each do |city|
  pr.cities.find_or_create_by(city)
end

sc_cities = [
  { name: 'Navegantes' },
  { name: 'Itapema' },
  { name: 'Balneário Camboriú' }
]

sc = State.find_or_create_by(name: 'Santa Catarina', abbreviation: 'SC')
sc_cities.each do |city|
  sc.cities.find_or_create_by(city)
end

rs_cities = [
  { name: 'Porto Alegre' },
  { name: 'Gramado' },
  { name: 'São Sebastião do Caí' }
]

rs = State.find_or_create_by(name: 'Rio Grande do Sul', abbreviation: 'RS')
rs_cities.each do |city|
  rs.cities.find_or_create_by(city)
end
