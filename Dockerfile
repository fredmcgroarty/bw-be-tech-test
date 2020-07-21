FROM ruby:2.6.3

RUN apt-get update && apt-get install -y nodejs --no-install-recommends 
RUN apt-get update && apt-get install -y sqlite3 git curl build-essential 

COPY Gemfile* /tmp/
WORKDIR /tmp 
RUN bundle install

ARG app_path="/test-exercise-fm"
ENV app_path=$app_path  

RUN mkdir -p $app_path  
WORKDIR $app_path 
ADD . $app_path 

EXPOSE 3000

CMD rails s -b 0.0.0.0
