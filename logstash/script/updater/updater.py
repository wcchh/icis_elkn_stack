from twnews.soup import NewsSoup
from elasticsearch import Elasticsearch
from argparse import ArgumentParser
import re

# 指令參數
parser = ArgumentParser()
parser.add_argument("docid", help="document id")
args = parser.parse_args()
docid = args.docid
print("參數: " + docid)

# 建立es連線
es = Elasticsearch([
    {'host': 'elasticsearch'},
    {'host': 'localhost'}
])

# 取得該筆資料
item = es.get(index="guo", doc_type="doc", id=docid)
newsurl = item['_source']['link']
# 如果存在google url代理，則需要先取出真正的新聞網址
if item['_source']['type'] == 'google-alerts':
    x = re.findall(r"https:\/\/www\.google\.com\/url\?rct=j&sa=t&url=(.*)&ct=ga.*", newsurl)
    if len(x) > 0:
        newsurl = x[0]
print("網址: " + newsurl)

# print(item['_source']['link'])
if 'error' not in item['_source'] and 'fulltext' not in item['_source']:
    # 透過twnews工具取得內文
    nsoup = NewsSoup(newsurl)
    # print(nsoup.title())
    try:
        if nsoup.conf is not None and nsoup.title() is not None:
            fulltext = nsoup.contents()
            # print('內文:')
            # print(fulltext)

            # 將內文回填es
            es.update(
                index="guo", 
                doc_type="doc", 
                id=docid, 
                body={"doc": {"fulltext": nsoup.contents(), "title": nsoup.title(), "channel": nsoup.channel}})
            print("已完成: " + docid)
        else:
            print("不支援該網站: " + newsurl)
            print("document id: " + docid)
            # 將內文回填es
            es.update(
                index="guo", 
                doc_type="doc", 
                id=docid, 
                body={"doc": {"error": 'twnews not support'}})
    except:
        print("不支援該網站: " + newsurl)
        print("document id: " + docid)
        # 將內文回填es
        es.update(
            index="guo", 
            doc_type="doc", 
            id=docid, 
            body={"doc": {"error": 'twnews not support'}})
else:
    print("已執行過: " + docid)
    print("Url: " + newsurl)
