FROM ubuntu:20.04

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y \
    netcat \
    fortune \
    cowsay \
    bash

RUN dpkg -l
RUN ls -l /usr/games /usr/games/fortune /usr/games/cowsay
RUN echo "Path for cowsay: $(command -v cowsay)" && echo "Path for fortune: $(command -v fortune)"

RUN chmod +x /app/wisecow.sh

RUN ls -l /app

EXPOSE 4499

CMD ["/app/wisecow.sh"]
