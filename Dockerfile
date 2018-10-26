FROM ruby:2.5

WORKDIR /app

COPY . .

CMD ["ruby", "./main.rb"]
