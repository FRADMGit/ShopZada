FROM python:3.9-slim

WORKDIR /app

RUN pip install pandas openpyxl lxml html5lib pyarrow fastparquet psycopg2-binary
