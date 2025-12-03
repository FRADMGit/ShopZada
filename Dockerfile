FROM python:3.9-slim

RUN pip install pandas openpyxl lxml html5lib pyarrow fastparquet psycopg2-binary