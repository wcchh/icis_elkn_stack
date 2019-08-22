# -*- coding: utf-8 -*-
import unittest
from PttWebCrawler.crawler import PttWebCrawler as crawler
import codecs, json, os
import glob
import ntpath
import xmlrunner

class TestCrawler(unittest.TestCase):
    def test_parse(self):
        self.link = 'https://www.ptt.cc/bbs/PublicServan/M.1409529482.A.9D3.html'
        self.article_id = 'M.1409529482.A.9D3'
        self.board = 'PublicServan'

        jsondata = crawler.parse(self.link, self.article_id, self.board)
        self.assertIn('article_title', jsondata)
        self.assertIn('content', jsondata)
        self.assertIn('date', jsondata)
        self.assertIn('url', jsondata)
        self.assertIn('ip', jsondata)
        self.assertIn('board', jsondata)

        self.assertEqual(jsondata['article_id'], self.article_id)
        self.assertEqual(jsondata['board'], self.board)
        self.assertEqual(jsondata['message_count']['count'], 57)
        

    
    def test_parse_with_structured_push_contents(self):
        self.link = 'https://www.ptt.cc/bbs/Gossiping/M.1119222660.A.94E.html'
        self.article_id = 'M.1119222660.A.94E'
        self.board = 'Gossiping'

        jsondata = crawler.parse(self.link, self.article_id, self.board)
        self.assertEqual(jsondata['article_id'], self.article_id)
        self.assertEqual(jsondata['board'], self.board)
        # 目前messages暫時非json格式，故無法執行以下這段assert
        # isCatched = False
        # for msg in jsondata['messages']:
        #     if u'http://tinyurl.com/4arw47s' in msg['push_content']:
        #         isCatched = True
        # self.assertTrue(isCatched)

    def test_parse_with_push_without_contents(self):
        self.link = 'https://www.ptt.cc/bbs/Gossiping/M.1433091897.A.1C5.html'
        self.article_id = 'M.1433091897.A.1C5'
        self.board = 'Gossiping'

        jsondata = crawler.parse(self.link, self.article_id, self.board)
        self.assertEqual(jsondata['article_id'], self.article_id)
        self.assertEqual(jsondata['board'], self.board)

    def test_parse_without_metalines(self):
        self.link = 'https://www.ptt.cc/bbs/NBA/M.1432438578.A.4B0.html'
        self.article_id = 'M.1432438578.A.4B0'
        self.board = 'NBA'

        jsondata = crawler.parse(self.link, self.article_id, self.board)
        self.assertEqual(jsondata['article_id'], self.article_id)
        self.assertEqual(jsondata['board'], self.board)

    def test_crawler(self):
        self.board = 'PublicServan'
        crawler(['-b', self.board, '-i', '1', '1'])
        filenamePrefix = self.board + '-'
        findOldFile = glob.glob(os.path.join('.', filenamePrefix + '*'))
        self.assertGreater(len(findOldFile), 0)
        
        with codecs.open(findOldFile[0], 'r', encoding='utf-8') as f:
            data = json.load(f)
            # 檢查擷取儲存的檔案名稱是否如預期
            self.assertEqual(ntpath.basename(findOldFile[0]), self.board + '-' + data['article_id'] + '-' + str(data['message_count']['all']) + '.json')
            self.assertEqual(data['board'], self.board)
        # os.remove(filename)
        for fnPath in findOldFile:
            os.remove(fnPath)

    def test_getLastPage(self):
        boards = ['NBA', 'Gossiping', 'b994060work']  # b994060work for 6259fc0 (pull/6)
        for board in boards:
            try:
                _ = crawler.getLastPage(board)
            except:
                self.fail("getLastPage() raised Exception.")


if __name__ == '__main__':
    with open('./report.xml', 'wb') as output:
        unittest.main(
            testRunner=xmlrunner.XMLTestRunner(output=output),
            failfast=False, buffer=False, catchbreak=False)