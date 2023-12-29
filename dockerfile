FROM python:3.8-slim

WORKDIR /app 

# Copy the application files
COPY . /app 

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unixodbc unixodbc-dev odbcinst odbcinst1debian2 libpq-dev gcc gnupg wget

# Install Microsoft ODBC Driver for SQL Server
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    wget -qO- https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Install Python dependencies
RUN pip install -r requirements.txt

# Clean up
RUN apt-get purge -y --auto-remove wget && \
    apt-get clean

EXPOSE 5000

CMD ["python", "./app.py"]
