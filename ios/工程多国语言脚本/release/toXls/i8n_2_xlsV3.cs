�
m;5Xc           @   s�  d  d l  Z  d  d l Z d  d l Z d Z g  Z d Z d Z d  d l Z d  d l Z d  d l	 Z	 e
 d � Z d Z d d � Z y4 e d d � j �  Z e d	 d	 e � Z e j Z Wn e k
 r� Z e GHe Z n Xd
 e f d �  �  YZ d �  Z i e d 6e d 6e d 6Z e d k r�d  d l Z e e j � d k rTe d � e j d � n  e j d Z i  Z y` e e j d � Z x* e j �  D] \ Z  Z! e! e e  j" �  <q�We j e# e �  p�d � � Wq�e k
 r�Z e GHq�Xn  d S(   i����Nt   ens4   /Users/chensi/Desktop/myself_i8n/Language(国际化)t    c         B   s�   | d  e  j �  k r) e d | � � n  e j | d � } e  j �  zp e  j |  � } | e j |  <y9 | | _	 | r� |  j
 d d � g | _ n  | | j UWn e j |  =�  n XWd  e  j �  X| S(   Ni   s   Bad magic number in %si   t   .t   /(   t   impt	   get_magict   ImportErrort   marshalt   loadst   acquire_lockt
   new_modulet   syst   modulest   __file__t   replacet   __path__t   __dict__t   release_lock(   t   namet   filenamet   datat	   ispackaget   codet   mod(    (    s   i8n_2_xlsV3.pyt   load_compiled_from_memory   s"    
	
c         C   s	   |  GHd  S(   N(    (   t   msgt   types(    (    s   i8n_2_xlsV3.pyt	   backPrint8   s    s
   csPrint.cst   rbt   csPrintt   TranslateSourceFile2XLSc           B   sn   e  Z d  �  Z d �  Z d �  Z d �  Z g  d � Z d �  Z d �  Z d �  Z	 d g  d	 � Z
 i  d
 � Z RS(   c         C   sU   t  |  _ d |  _ d |  _ g  |  _ d |  _ d |  _ i  |  _ d  |  _	 d |  _
 d  S(   NR   i    i   (   t   Falset   m_flagIgnoreNotet   m_sourceFilet   m_destXlsFilet   m_IgnoreKeyst   m_Keyst   m_KeyNumt	   cacheDictt   Nonet   wst   m_col(   t   self(    (    s   i8n_2_xlsV3.pyt   __init__F   s    								c         C   sz   g  } xm t  j | � D]\ } | d d k sF t  j j | d | � r] t d | d � q n  | j | d | � q W| S(   Ni    R   R   s   忽略:t   action(   t   ost   listdirt   patht   isfileR   t   append(   R*   R/   t   filelistt   i(    (    s   i8n_2_xlsV3.pyt   listDirS   s    *c         C   sz   g  } xm t  j | � D]\ } | d d k sF t  j j | d | � r] t d | d � q n  | j | d | � q W| S(   Ni    R   R   s   忽略文件:R,   (   R-   R.   R/   t   isdirR   R1   (   R*   R/   R2   R3   (    (    s   i8n_2_xlsV3.pyt	   listFiles\   s    *c         C   sp   t  | t � s t � g  } y6 g  | D]% } t j j | � j d � d ^ q% } Wn t k
 rk } | GHn X| S(   NR   i    (   t
   isinstancet   listt   AssertionErrorR-   R/   t   basenamet   splitt	   Exception(   R*   t   pathst   resultt   xt   e(    (    s   i8n_2_xlsV3.pyt   listBaseNamee   s    6	c         C   s=   t  } x0 | D]( } t j j | � t k r t } Pq q W| S(   N(   t   TrueR-   R/   t   existsR   (   R*   t   filePathR>   t   xFile(    (    s   i8n_2_xlsV3.pyt	   fileCheckm   s    c         C   s�   |  j  |  j � } |  j | � } g  } |  j | k rG t d d � | S| j |  j � x< | D]4 } | |  j k r^ | |  j k r^ | j | � q^ q^ W| S(   Ns   关键key不匹配t   error(   R4   R!   RA   R$   R   R1   R#   (   R*   t   retDirst   retBaseNamest	   real_keyst   xkey(    (    s   i8n_2_xlsV3.pyt   _getRealKeyt   s    c         C   sS   d  } y& t | � } | j �  } | j �  Wn  t k
 rN } t d d � n X| S(   Ns   文件读取出错RG   (   R'   t   opent	   readlinest   closeR<   R   (   R*   t	   file_patht   i8nLinest   fhR@   (    (    s   i8n_2_xlsV3.pyt	   _fileRead�   s    c         C   sg   |  j  | � } g  } y+ x$ | D] } | j |  j | � � q WWn  t k
 rb } t d d � n X| S(   Ns   数据读取出错了RG   (   R6   t   extendRS   R<   R   (   R*   R/   t   retFilest   retLineDatast   itemFileR@   (    (    s   i8n_2_xlsV3.pyt   _readAllLines�   s    s   Sheet csc         C   s6  t  | � d k r# t d d � d St j d � } t j d � } t j d � } |  j } | j d � } | j d � }	 | j | � |	 j | � t }
 | |  j k r� t	 }
 n  |
 r� | j
 d d d	 | � | j
 d d d
 | � n |  j d 7_ | j
 d |  j | | � | j
 d |  j d
 | � d } t } x�| D]�} | j �  d d !d k r�|  j t k r.| j | � } | j | � |
 r�| j
 | d | | � n  | j
 | |  j | | � | d 7} q.q8| j �  d d !d k r�t	 } q8| j d � d d k rt } q8| rq8| j d � } t  | � d k r8| d j �  } | j d � } | d j d d � j �  } | j d � } |
 r�| |  j | <| j
 | d | | � | j
 | d | | � | d 7} q.|  j j | d � } | d k r| j
 | |  j | | � n t d | d | � | d 7} q8q8Wd  S(   Ni    s   数据不存在RG   i����s   font:height 280, name SimSuns`   font:height 280, name SimSun, colour_index red, bold on;pattern:pattern solid,fore_colour yellowsd   font:height 280, name SimSun, colour_index red, bold on;pattern:pattern solid,fore_colour light_bluei   t   keys   //注释i   s   //s   /*s   
i����s   */t   =t   "t   ;R   s
   新增Key:t   >(   t   lenR   t   xlwtt   easyxfR(   t   rowt	   set_styleR   R$   RB   t   writeR)   t   stripR    t   rstripR;   R   R&   t   get(   R*   t   keyNamet
   sheet_namet
   list_valuet   style0t   style1t   style2R(   t	   first_rowt   sec_rowt
   note2Cachet   indext   noteFlagt   linet   note_rowt   tmpListt   value1t   value2t   tmpIndex(    (    s   i8n_2_xlsV3.pyt	   _xlsWrite�   sj    				c         C   s�   |  j  �  } t | � d k r/ t d d � d  St j d d � } | j d � |  _ xs | D]k } t d | � |  j |  j d | d	 � } t | � d k r� |  j	 d
 | d | � qZ t | d � qZ W| j
 |  j p� d � t d � d  S(   Ni    s   key处理出错了RG   t   encodings   utf-8s   Sheet css   开始处理>R   s   .lproj/Rg   Ri   s   : 中没有找到任何数据s
   output.xlss   数据转换成功(   RL   R^   R   R_   t   Workbookt	   add_sheetR(   RX   R!   Rx   t   saveR"   (   R*   t   paramst   willWirteKeyst   wbt   itemKeyt	   dataLines(    (    s   i8n_2_xlsV3.pyt   runTranslate�   s    (   t   __name__t
   __module__R+   R4   R6   RA   RF   RL   RS   RX   Rx   R�   (    (    (    s   i8n_2_xlsV3.pyR   E   s   								
	Jc          C   s�   t  �  }  t d |  _ t d |  _ t |  _ t d |  _ t d |  j � t d d j |  j � d � t d |  j � |  j p� d	 } t d
 | � |  j	 �  d  S(   NRY   t
   ignorekeyst   outputs   主键:s   忽略:[t   ,t   ]s
   源目录:s   默认文件s   输出文件:(
   R   t   g_ParamsR$   R#   t   g_sourceFileR!   R"   R   t   joinR�   (   t   tst   tmpV(    (    s   i8n_2_xlsV3.pyt   main�   s    		RY   R�   R�   t   __main__i   s^   例子: i8n_2_xls.cs "源路径" "{"key":"en", "ignoreKeys":["zh, zh-Hant"], "output":"path"}"i   i   i    ($   R_   R-   t	   functoolst   g_keyt   g_IgnoreKeysR�   t   g_destXlsFileR   R   R   R   R   R'   R   R   RM   t   readt   pycDatat   tPrintR<   R@   t   objectR   R�   R�   R�   R^   t   argvt   exitt
   dictParamst   evalt   itemsRY   t   valuet   lowert   int(    (    (    s   i8n_2_xlsV3.pyt   <module>   sJ   $
�	

 