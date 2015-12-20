
#download song.html is ok
curl -o song.html https://www.kkbox.com/tw/tc/search.php?word=%E4%B8%89%E5%B9%B4%E4%BA%8C%E7%8F%AD&search=mix&lang=tc
curl -o song.html https://www.kkbox.com/tw/tc/search.php?word=三年二班&search=mix&lang=tc

#download album is not ok,
curl -o album.html -A "Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.73 Safari/537.36" --referer https://www.kkbox.com https://www.kkbox.com/tw/tc/search.php?search=mix&word=%E8%91%89%E6%83%A0%E7%BE%8E

curl -o album.html -A "Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.73 Safari/537.36" --referer https://www.kkbox.com https://www.kkbox.com/tw/tc/search.php?search=mix&word=%E8%91%89%E6%83%A0%E7%BE%8E&lang=tc

#問題點, line 337的value沒有帶上"葉惠美", chrome的網頁內容裡面有，不知道差異再哪裡
curl -o album.html https://www.kkbox.com/tw/tc/search.php?search=mix&word=葉惠美&lang=tc

