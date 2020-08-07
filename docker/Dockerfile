FROM ruby:2.7-alpine3.10
RUN apk --no-cache add git build-base ruby-dev \
  && cd /tmp/ \
  && git clone https://github.com/ninoseki/miteru.git \
  && cd miteru \
  && gem build miteru.gemspec -o miteru.gem \
  && gem install miteru.gem \
  && rm -rf /tmp/miteru \
  && apk del --purge git build-base ruby-dev

ENTRYPOINT ["miteru"]

CMD ["--help"]
