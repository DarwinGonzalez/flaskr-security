# docker build . -t stodh/uwsgi-nginx-flaskr-security
FROM tiangolo/uwsgi-nginx-flask:python3.6-alpine3.7
RUN pip install zxcvbn
#COPY ./app /app
