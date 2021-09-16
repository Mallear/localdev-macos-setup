FROM python:3.8-slim-buster

RUN mkdir /app

ADD . /app

WORKDIR /app

RUN apt-get update && apt-get install -y gcc
RUN pip install -r requirements.txt

ENTRYPOINT [ "python" ]

CMD [ "app/main.py" ]
