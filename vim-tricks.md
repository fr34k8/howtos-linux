# Tipps und tricks mit vim

#### encoding to utf-8

:write ++enc=utf-8

#### dos2unix tipps

:set ff=unix  
 :set ff=dos  
 :e ++ff=mac foo.txt  
 :w ++ff=unix  
 vim \*.txt  
 :set hidden  
 :bufdo %s/\\r\$//e  
 :bufdo %s/\\r/ /eg  
 :xa

#### ask before serach/replace

:1,\$s/text/text2/gc

#### Another .vimrc

set ruler  
 syntax on  
 set showcmd  
 set history=50  
 set incsearch  
 if &amp;t\_Co &gt; 1  
   syntax enable  
 endif  
 colorscheme blue
