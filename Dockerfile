FROM alpine
RUN apk update \
    && apk add python3 py3-pip \
    && pip install Flask
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]