FROM python:3.9-slim-buster

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    curl

WORKDIR /app

COPY requirements.txt .

RUN python -m pip install --upgrade pip; \
    pip install -r requirements.txt

COPY . .

RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn", "--worker-tmp-dir", "/dev/shm", "--bind", "0.0.0.0:8000", "--log-level", "INFO", "mysite.wsgi"]
