FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk-headless && \
    apt-get install -y python && \
    apt-get install -y python-pip && \
    apt-get install -y curl && \
    apt-get clean

# Set versions
ENV SPARK_VERSION=1.5.2 \
HADOOP_VERSION=2.6

# Set Spark home
ENV SPARK_HOME=/spark

# Download Spark
RUN curl -O http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME} && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

# Update env variables
ENV PATH $PATH:$SPARK_HOME/bin
ENV FILE_PATH=/app
ENV INPUT_FILE=movies.csv

# Copy required files
COPY WordCount.py /app/
COPY ${INPUT_FILE} /app/

# Run WordCount.py with input and output files
VOLUME /app
WORKDIR /app
CMD $SPARK_HOME/bin/spark-submit WordCount.py ${FILE_PATH}/${INPUT_FILE} ${FILE_PATH}/output
