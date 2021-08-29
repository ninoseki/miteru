FROM ruby:3-alpine3.13

RUN apk --no-cache add git build-base ruby-dev mysql-client mysql-dev sqlite-dev postgresql-client postgresql-dev \
  && cd /tmp/ \
  && git clone https://github.com/ninoseki/miteru.git \
  && cd miteru \
  && gem build miteru.gemspec -o miteru.gem \
  && gem install miteru.gem \
  && gem install mysql2 \
  && gem install pg \
  && rm -rf /tmp/miteru \
  && apk del --purge git build-base ruby-dev

ENTRYPOINT ["miteru"]

CMD ["--help"]
