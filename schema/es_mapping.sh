#!/bin/bash

while ! nc -z localhost 9200; do
  echo "Waiting port to ElasticSearch launch on 9200..."
  sleep 1
done
echo "Go..."

curl -XPUT http://localhost:9200/guo -d'
{
  "settings": {
    "analysis": {
      "analyzer": {
        "by_smart": {
          "type": "custom",
          "tokenizer": "ik_smart",
          "filter": [
            "by_tfr",
            "by_length"
          ],
          "char_filter": [
            "by_cfr"
          ]
        },
        "by_max_word": {
          "type": "custom",
          "tokenizer": "ik_max_word",
          "filter": [
            "by_tfr",
            "by_length"
          ],
          "char_filter": [
            "by_cfr"
          ]
        },
        "by_max_word1": {
          "type": "custom",
          "tokenizer": "ik_max_word",
          "filter": [
            "by_tfr"
          ],
          "char_filter": [
            "by_cfr"
          ]
        }
      },
      "filter": {
        "by_tfr": {
          "type": "stop",
          "stopwords": [
            " "
          ]
        },
        "by_length": {
          "type": "length",
          "min": 2
        }
      },
      "char_filter": {
        "by_cfr": {
          "type": "mapping",
          "mappings": [
            "| => |"
          ]
        }
      }
    }
  },
  "mappings": {
    "doc":{
       "properties":{
            "fulltext": {
               "analyzer": "by_max_word",
               "term_vector": "with_positions_offsets",
                "boost": 8,
                "type": "text",
                "fielddata":"true"
            }
        }
    }
  }
}'