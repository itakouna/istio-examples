FROM frolvlad/alpine-python3
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 8080
CMD python movies.py
