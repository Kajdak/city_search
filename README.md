# city_search

Execute na ordem:

1-`docker-compose up web --build -d`

2-`docker-compose run web rails db:create`

3-`docker-compose run web rails db:migrate`

4-`docker-compose run web rails db:seed`


Para rodar testes, execute `docker-compose run rspec`
