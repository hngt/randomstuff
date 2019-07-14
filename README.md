Random stuff
============
Various programs which I have written in my free time, and are solutions to minor problems I encounter everyday.

### perseus.py
A tool for simpler querying of [Perseus](http://www.perseus.tufts.edu) portal, I personally use it for greek, but works with any language. For usage just write `perseus -h` and you should get more than you need. You can change default language by changing the variable `lang` to any other valid one from `lang_list`.

Requirements:
- BeautifulSoup4

Tags: _greek, latin, arabic, learning, inflection, python, bash, study, script_

### audio-split.sh
A simpler tool for changing youtube mixes into nice tracks, using youtube-dl and ffmpeg. The awk code is prepared for format used by user Pafdingo, but should be easy to modify for variety of different formats with a bit of knowldge of awk.

Requirements:
- awk
- exiftool
- ffmpeg
- youtube-dl

