from pyspark import SparkContext, SparkConf
import os

if __name__ == "__main__":
    conf = SparkConf().setAppName("WordCount")
    sc = SparkContext(conf=conf)

    words = sc.textFile("/app/movies.csv").flatMap(lambda line: line.split(" "))

    wordCounts = words.map(lambda word: (word, 1)).reduceByKey(lambda a, b: a + b)

    wordCounts.saveAsTextFile("/app/output")

    sc.stop()
