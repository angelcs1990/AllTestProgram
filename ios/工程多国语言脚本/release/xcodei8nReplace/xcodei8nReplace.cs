ó
Ù­äXc           @   sC  d  d l  Z  d  d l Z d  d l Z d  d l Z d  d l Z d  d l Z d  d l Z d  d l Z d Z d Z	 d Z
 d Z d Z d Z d d d	 d
 d d d d g Z d d d d g Z d e f d     YZ e d d d d d d  j   Z d   Z d e f d     YZ d e f d     YZ d    Z e d! k r?e   n  d S("   iÿÿÿÿNi    s7   /Users/chensi/project/Export/GameGuess_CN2/GameGuess_CNs{   /Users/chensi/project/svn/GameGuess_CN2/GameGuess_CN/Supporting Files/Language(å½éå)/zh-Hans.lproj/Localizable.stringssl   /Users/chensi/project/svn/GameGuess_CN2/GameGuess_CN/Supporting Files/Language(å½éå)/GGLanguageString.hs   %st	   WebSockett   SWebViewControllert   Httpt   SRouter2t
   STableViewt   STabViewt   SPopViewt   CSs   YYTextView.ms   YYTextUtilities.ms   NSAttributedString+YYText.ms   SR2LocalHandler.mt   Loggerc           B   s   e  Z d    Z d   Z RS(   c         C   sÝ   t  j |  |  _ |  j j t  j  t  j |  } | j t  j  t  j   } | j t  j  t  j d  } | j |  | j |  |  j j	 |  |  j j	 |  d t
 j
 j   j d  d } |  j j |  d  S(   Ns   %(levelname)s - %(message)ss   =================s   %Y-%m-%d %H:%M:%S(   t   loggingt	   getLoggert   loggert   setLevelt   DEBUGt   FileHandlert   StreamHandlert	   Formattert   setFormattert
   addHandlert   datetimet   nowt   strftimet   debug(   t   selft   lognamet   loglevelR   t   fht   cht	   formattert   startOutTitle(    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyt   __init__=   s     c         C   s   |  j  S(   N(   R   (   R   (    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyR
   U   s    (   t   __name__t
   __module__R   R
   (    (    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyR   <   s   	R   s   log.txtR   i   R   t   foxc         C   s   t  j |   d  S(   N(   R   R   (   t   value(    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyt   logPrintY   s    t   TimeDurationc           B   s,   e  Z d    Z d   Z d   Z d   Z RS(   c         C   s   d |  _  d  S(   Ni    (   t	   totalCost(   R   (    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyR   ^   s    c         C   s   t  j  j   |  _ d  |  _ d  S(   N(   R   R   t
   start_timet   Nonet   end_time(   R   (    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyt   start`   s    c         C   sG   t  j  j   |  _ |  j |  j } | j   } |  j | 7_ t |  S(   N(   R   R   R(   R&   t   total_secondsR%   t   str(   R   t   deltat   tmpCost(    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyt   getDurationStrc   s
    c         C   s   t  |  j  S(   N(   R+   R%   (   R   (    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyt   getTotalCostj   s    (   R   R    R   R)   R.   R/   (    (    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyR$   ]   s   			t   XCodeProjecti8nAutoReplacec           B   sh   e  Z d    Z i  d  Z d   Z d   Z d   Z d   Z d   Z d   Z	 g  d  Z
 d	   Z RS(
   c         C   sU   t  |  _ i  |  _ d |  _ t |  _ t |  _ | |  _ | |  _	 g  |  _
 i  |  _ d  S(   Ni    (   t   Truet   m_debugModelt   m_cacheMapi8nt   m_countFoldert   g_ignoreFoldert   m_ignoreFoldert   g_ignoreFilest   m_ignoreFilest   m_i8nMapPatht   m_projectFoldert   m_cacheAllFilest   m_cacheFile_Array(   R   t   projectFoldert
   i8nMapPath(    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyR   o   s    								c   	      C   sÀ   z® y t  | d  } | j   } xm | D]e } | j d  } | j d  } t |  d k r | d j d d  | | d <q( t d	 |  q( WWn t k
 r¬ } | GHn XWd  | j   Xd  S(
   Nt   rs   ;
t   =i   i    t   "t    i   s   å¿½ç¥å¤ç:(	   t   opent	   readlinest   stript   splitt   lent   replaceR#   t	   Exceptiont   close(	   R   t
   i8nSrcFilet   outMapCachet   fHandlert   tmpLinest   linet   tmpt   tmpArrayt   e(    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyt
   loadi8nMapz   s     !c         C   s   x t  j |  D]q } t  j j | |  } t  j j |  rb |  j d 7_ |  j | | |  q | j |  r | j |  q q W| S(   Ni   (	   t   ost   listdirt   patht   joint   isdirR4   t   listDirt   endswitht   append(   R   RV   t   filtert   outFilest   filet   tmpFilePath(    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyRY      s    c         C   s   z ye t  | d  } | j   } t j d | j d   } | d  k rg t |  d k rg | | | <n  Wn t k
 r } t |  n XWd  | j	   Xd  S(   NR?   u    @("[0-9a-zA-Z\S]*?[^ -Ã¿]+?.*?")t   utf8i    (
   RC   t   readt   ret   findallt   decodeR'   RG   RI   R#   RJ   (   R   t   filePatht   keyValuet   cachet   ft   all_the_linest   tRR   (    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyt   findKeyForFile   s     c         C   sy  |  j  t k r d  Sx3 |  j j   D]" \ } } t d | d |  q# Wt d  t d t |  j  d  t d t t |  j   d  t d  d } x« |  j	 j   D] \ } } | t |  7} t d t
 j j t
 j j |   d	 d
 t
 j j |  d t t |   d  x% | D] } t d | j d   q(Wq¯ Wt d  t t |  d  t d  d  S(   Ns   key:s	   	->value:s   ==========================s	   æ¥æ¾äºs   ä¸ªæä»¶å¤¹s	   ä¸ªæä»¶i    s   æä»¶iÿÿÿÿt   /s   ï¼s   ä¸ªs   	R`   s   ===========================s   ä¸ªéæ¿æ¢å­ç¬¦æ£æµå°(   R2   t   FalseR3   t   itemsR#   R+   R4   RG   R;   R<   RT   RV   RF   t   dirnamet   basenamet   encode(   R   Rj   t   vt
   totalCheckt   it(    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyt   outputDebug¡   s"    
!
V
c         C   s.   x' |  j  D] } |  j | d |  j  q
 Wd  S(   NRB   (   R;   Rk   R<   (   R   R^   (    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyt   analyzeFiles¶   s    c         C   s¯   y t  d  t d  } t d  } t |  d k rI t |  |  _ n  t |  d k rm t |  |  _ n  t  d |  j  t  d |  j  Wn t k
 rª } | GHn Xd  S(   Ns6   å¿½ç¥æä»¶è¾å¥æ ¼å¼:["TestFolder", "Test2Folder"]s5   æè¾å¥éè¦å¿½ç¥çç®å½(æ²¡æç´æ¥åè½¦)ï¼s5   æè¾å¥éè¦å¿½ç¥çæä»¶(æ²¡æç´æ¥åè½¦)ï¼i    s   å¿½ç¥çç®å½ä¸ºï¼s   å¿½ç¥çæä»¶ä¸ºï¼(   R#   t	   raw_inputRG   t   evalR8   R6   RI   (   R   t   ignoreFoldert   ignoreFilesRR   (    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyt
   readIgnore¹   s    
c         C   s,  t  d  t  d  t  d  d } xÙ |  j j   D]È \ } } t j j t j j |   d } t j j |  } | |  j k s4 | |  j	 k r q4 n  t
 t |   } | t |  7} t  d t j j |  d t t |   d  |  j | |  q4 Wt  d  t  t |  d  t  d  d  S(	   Ns   ************************i    iÿÿÿÿs   å¤çæä»¶:s   ï¼s   ä¸ªs   ===========================s   ä¸ªéæ¿æ¢å­ç¬¦æ£æµå°(   R#   R<   Rn   RT   RV   RF   Ro   Rp   R6   R8   t   listt   setRG   R+   t   dealFile(   R   Rs   Rj   Rr   t	   dirFoldert   dirFileNamet   tmpList(    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyt   replaceFilesÉ   s     


"2
c         C   s?  z-y	g  } t  | d  } | j   } t } x | D] } | j d  } |  j j |  } | d  k r¦ t d | d |  t } t	 | }	 | j
 d | |	  } q4 | j d |  q4 Wt d  x  | D] }
 t d |
 d  qÌ W| r| j d  | j |  n  Wn t k
 r+} t |  n XWd  | j   Xd  S(	   Ns   r+R`   s   		@s	   æ¿æ¢ä¸ºt   @s   		æªæ¿æ¢ï¼s   æ²¡æè¢«æ¿æ¢i    (   RC   Ra   Rm   Rq   R3   t   getR'   R#   R1   t   warpperValueRH   R[   t   seekt   writeRI   RJ   (   R   Re   t	   willArrayt   unChangedListRM   t
   allContentt   changedt   wordt   willWordt   outPutt   itemRR   (    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyR~   Ü   s0     

c         C   s  t  d  t   } | j   |  j |  j |  j  t  d | j    t  d  |  j |  j | |  j	  t  d | j    t  d  |  j
   t  d | j    |  j   |  j   | j   t  d  |  j   t  d | j    t  d	 | j    d  S(
   Ns   å¼å§è½½å¥è¯­è¨æä»¶s   è½½å¥è¯­è¨æä»¶ç¨æ¶ï¼s   å¼å§æ«æå·¥ç¨ç®å½s   æ«æå·¥ç¨ç®å½ç¨æ¶ï¼s   å¼å§åæå·¥ç¨æä»¶s   åæå·¥ç¨æä»¶ç¨æ¶ï¼s   å¼å§æå­æ¿æ¢s   æå­æ¿æ¢ç¨æ¶ï¼s   å±è±è´¹æ¶é´ï¼(   R#   R$   R)   RS   R9   R3   R.   RY   R:   R;   Rv   Ru   R{   R   R/   (   R   R\   t   dur(    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyt   startRunü   s$    
	








(   R   R    R   RS   RY   Rk   Ru   Rv   R{   R   R~   R   (    (    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyR0   n   s   		
					 c          C   sî   t  t j  d k r= d t t  t j   GHt j d  n  t j d }  t j d } t j d } g  } g  } t  t j d  d k r t t j d  } n  t  t j d  d k rÎ t t j d  } n  t |  |  } | j d	  d  S(
   Ni   s	   åºéäºi   i   i   i   i    i   s   .m(   RG   t   syst   argvR+   t   exitRx   R0   R   (   t   dst_dirt
   map_dirSrcR   R7   R5   t   handler(    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyt   main  s    t   __main__(   RT   t   shutilRb   t   codecsR   t   timeR	   R   t   countFolderst
   countFilesR   R   t
   map_dirDefR   R5   R7   t   objectR   R
   R   R#   R$   R0   R   R   (    (    (    sC   /Users/chensi/Desktop/myself_i8n/xcodei8nReplace/xcodei8nReplace.pyt   <module>   s.   "!	§	