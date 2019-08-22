from PttWebCrawler.crawler import *
import sys

c = PttWebCrawler(as_lib=True)

directory = os.path.abspath('./data/pttdata/')
if not os.path.exists(directory):
    os.makedirs(directory)

boards = sys.argv[1].split(',')
for board in boards:
    print(board)
    lastpage = c.getLastPage(board)
    c.parse_articles(lastpage-5, lastpage, board, directory)

