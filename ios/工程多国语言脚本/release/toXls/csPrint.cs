�
���Wc           @   sL   d  �  Z  d �  Z d �  Z d Z i e d 6e d 6e  d 6Z d d � Z d S(	   c         C   s   d |  d GHd  S(   Ns   [31ms   [提示]s   [0ms   [31m[提示](    (   t   msg(    (    s
   csPrint.pyt   consolePrint   s    c         C   s   d |  d GHd  S(   Ns   [32ms   [操作]s   [0ms   [32m[操作](    (   R    (    (    s
   csPrint.pyt   actionPrint
   s    c         C   s   d |  d GHd  S(   Ns   [33ms   [终止运行]s   [0ms   [33m[终止运行](    (   R    (    (    s
   csPrint.pyt   errPrint   s    i    t   errort   actiont   tipc         C   sF   t  d k r d  St j | j �  � } | r8 | |  � n
 t d � d  S(   Ni   s(   请输入有效操作：error/action/tip(   t   g_debugt   Print_Type_Mapt   gett   lowerR   (   R    t	   printTypet   fn(    (    s
   csPrint.pyt   csPrint   s    N(   R   R   R   R   R   R   (    (    (    s
   csPrint.pyt   <module>   s   			
