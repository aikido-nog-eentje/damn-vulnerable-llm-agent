FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    pip \
    && rm -rf /var/lib/apt/lists/*

RUN pip install python-dotenv

COPY * /app/
RUN pip3 install -r requirements.txt

RUN mkdir -p /home/appuser/.streamlit
COPY config.toml /home/appuser/.streamlit/config.toml

EXPOSE 8501

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

RUN useradd -U -u 1000 appuser && chown -R 1000:1000 /app && chown -R 1000:1000 /home/appuser
USER 1000

ENTRYPOINT ["streamlit", "run", "main.py", "--server.port=8501", "--server.address=0.0.0.0"]