FROM frolvlad/alpine-python3
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 5002
CMD python showmovies.py
