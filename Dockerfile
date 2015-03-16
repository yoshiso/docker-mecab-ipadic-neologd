FROM ubuntu:latest

RUN apt-get update
RUN apt-get upgrade -y

# Build essentials
RUN apt-get install -y libc6-dev curl build-essential

# Mecab
RUN curl -O https://mecab.googlecode.com/files/mecab-0.996.tar.gz
RUN tar -xzf mecab-0.996.tar.gz
RUN cd mecab-0.996; ./configure --enable-utf8-only; make; make install; ldconfig

# Ipadic
RUN curl -O https://mecab.googlecode.com/files/mecab-ipadic-2.7.0-20070801.tar.gz
RUN tar -xzf mecab-ipadic-2.7.0-20070801.tar.gz
RUN cd mecab-ipadic-2.7.0-20070801; ./configure --with-charset=utf8; make; make install
RUN echo "dicdir = /usr/local/lib/mecab/dic/ipadic" > /usr/local/etc/mecabrc

# Clean up
RUN apt-get remove -y build-essential
RUN rm -rf mecab-0.996.tar.gz*
RUN rm -rf mecab-ipadic-2.7.0-20070801*


# mecab-ipadic-neologd
RUN apt-get install -y git
RUN git clone https://github.com/neologd/mecab-ipadic-neologd.git
RUN cd mecab-ipadic-neologd && ( echo yes | ./bin/install-mecab-ipadic-neologd )

ENTRYPOINT mecab -d /usr/local/lib/mecab/dic/mecab-ipadic-neologd/