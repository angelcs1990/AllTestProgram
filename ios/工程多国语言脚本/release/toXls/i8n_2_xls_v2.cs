�
�9)Xc           @   s�  d  d l  Z  d  d l Z d  d l Z d Z g  Z d Z d Z d  d l Z d  d l Z d  d l	 Z	 e
 d � Z d Z d d � Z y4 e d d � j �  Z e d	 d	 e � Z e j Z Wn e k
 r� Z e GHe Z n Xd
 e f d �  �  YZ d �  Z i e d 6e d 6e d 6Z e d k r�d  d l Z e e j � d k rTe d � e j d � n  e j d Z i  Z y` e e j d � Z x* e j �  D] \ Z  Z! e! e e  j" �  <q�We j e# e �  p�d � � Wq�e k
 r�Z e GHq�Xn  d S(   i����Nt   ens4   /Users/chensi/Desktop/myself_i8n/Language(国际化)t    c         B   s�   | d  e  j �  k r) e d | � � n  e j | d � } e  j �  zp e  j |  � } | e j |  <y9 | | _	 | r� |  j
 d d � g | _ n  | | j UWn e j |  =�  n XWd  e  j �  X| S(   Ni   s   Bad magic number in %si   t   .t   /(   t   impt	   get_magict   ImportErrort   marshalt   loadst   acquire_lockt
   new_modulet   syst   modulest   __file__t   replacet   __path__t   __dict__t   release_lock(   t   namet   filenamet   datat	   ispackaget   codet   mod(    (    s   i8n_2_xls.pyt   load_compiled_from_memory   s"    
	
c         C   s	   |  GHd  S(   N(    (   t   msgt   types(    (    s   i8n_2_xls.pyt	   backPrint1   s    s
   csPrint.cst   rbt   csPrintt   TranslateSourceFile2XLSc           B   se   e  Z d  �  Z d �  Z d �  Z g  d � Z d �  Z d g  d � Z d �  Z d �  Z	 i  d	 � Z
 RS(
   c         C   s:   t  |  _ d |  _ d |  _ g  |  _ d |  _ d |  _ d  S(   NR   i    (   t   Falset   m_flagIgnoreNotet   m_sourceFilet   m_destXlsFilet   m_IgnoreKeyst   m_Keyst   m_KeyNum(   t   self(    (    s   i8n_2_xls.pyt   __init__?   s    					c         C   s`   g  } xS t  j | � D]B } | d d k rC t d | d � q n  | j | d | � q W| S(   Ni    R   s   忽略:t   actionR   (   t   ost   listdirR   t   append(   R&   t   patht   filelistt   i(    (    s   i8n_2_xls.pyt   listDirH   s    c         C   sp   t  | t � s t � g  } y6 g  | D]% } t j j | � j d � d ^ q% } Wn t k
 rk } | GHn X| S(   NR   i    (   t
   isinstancet   listt   AssertionErrorR)   R,   t   basenamet   splitt	   Exception(   R&   t   pathst   resultt   xt   e(    (    s   i8n_2_xls.pyt   listBaseNameQ   s    6	c         C   s=   t  } x0 | D]( } t j j | � t k r t } Pq q W| S(   N(   t   TrueR)   R,   t   existsR   (   R&   t   filePathR7   t   xFile(    (    s   i8n_2_xls.pyt	   fileCheckY   s    c         C   s�   |  j  |  j � } |  j | � } g  } |  j | k rG t d d � | S| j d � | j |  j � x< | D]4 } | |  j k rk | |  j k rk | j | � qk qk W| S(   Ns   关键key不匹配t   errort   key(   R/   R!   R:   R$   R   R+   R#   (   R&   t   retDirst   retBaseNamest	   real_keyst   xkey(    (    s   i8n_2_xls.pyt   _getRealKey`   s    s   Sheet csc         C   s�  t  | � d k r# t d d � d S|  j �  } t  | � d k rE d St j d � } t j d � } t j d � } t j d	 d
 � } | j | � } d }	 | j d � }
 | j d � } |
 j | � | j | � xD | D]< } | j	 d |	 | | � | j	 d |	 d | � |	 d 7}	 q� Wd } t
 } xi| D]a} | j �  d d !d k r�|  j t
 k r�| j | � } | j | � | j	 | d | | � | d 7} q�q+| j �  d d !d k r�t } q+| j d � d d k r�t
 } q+| r�q+| j d � } t  | � d k r+| d j �  } | j d � } | d j d d � j �  } | j d � } | j	 | d | | � | j	 | d | | � | d 7} q+q+W| j |  j p�d � t d � d  S(   Ni    s   数据不存在R@   i����i����s   font:height 280, name SimSuns`   font:height 280, name SimSun, colour_index red, bold on;pattern:pattern solid,fore_colour yellowsd   font:height 280, name SimSun, colour_index red, bold on;pattern:pattern solid,fore_colour light_bluet   encodings   utf-8i   s   //注释i   s   //s   /*s   
s   */t   =t   "t   ;R   s
   output.xlss   数据转换成功(   t   lenR   RF   t   xlwtt   easyxft   Workbookt	   add_sheett   rowt	   set_stylet   writeR   t   stripR    R;   t   rstripR4   R   t   saveR"   (   R&   t
   sheet_namet
   list_valueRD   t   style0t   style1t   style2t   wbt   wst   colt	   first_rowt   sec_rowt
   xHeadValuet   indext   noteFlagt   linet   note_rowt   tmpListt   value1t   value2(    (    s   i8n_2_xls.pyt	   _xlsWritew   s\    		c         C   sS   d  } y& t | � } | j �  } | j �  Wn  t k
 rN } t d d � n X| S(   Ns   文件读取出错R@   (   t   Nonet   opent	   readlinest   closeR5   R   (   R&   t	   file_patht   i8nLinest   fhR9   (    (    s   i8n_2_xls.pyt	   _fileRead�   s    c         C   sg   |  j  | � } g  } y+ x$ | D] } | j |  j | � � q WWn  t k
 rb } t d d � n X| S(   Ns   数据读取出错了R@   (   R/   t   extendRp   R5   R   (   R&   R,   t   retFilest   retLineDatast   itemFileR9   (    (    s   i8n_2_xls.pyt   _readAllLines�   s    c         C   sW   |  j  |  j d |  j d � } t | � d k rF |  j d | � n t d d � d  S(   NR   s   .lproj/i    RW   s   runTranslate出错R@   (   Ru   R!   R$   RK   Rh   R   (   R&   t   paramst	   dataLines(    (    s   i8n_2_xls.pyt   runTranslate�   s    !(   t   __name__t
   __module__R'   R/   R:   R?   RF   Rh   Rp   Ru   Rx   (    (    (    s   i8n_2_xls.pyR   >   s   						8	
	
c          C   s�   t  �  }  t d |  _ t d |  _ t |  _ t d |  _ t d |  j � t d d j |  j � d � t d |  j � |  j p� d	 } t d
 | � |  j	 �  d  S(   NRA   t
   ignorekeyst   outputs   主键:s   忽略:[t   ,t   ]s
   源目录:s   默认文件s   输出文件:(
   R   t   g_ParamsR$   R#   t   g_sourceFileR!   R"   R   t   joinRx   (   t   tst   tmpV(    (    s   i8n_2_xls.pyt   main�   s    		RA   R{   R|   t   __main__i   s^   例子: i8n_2_xls.cs "源路径" "{"key":"en", "ignoreKeys":["zh, zh-Hant"], "output":"path"}"i   i   i    ($   RL   R)   t	   functoolst   g_keyt   g_IgnoreKeysR�   t   g_destXlsFileR   R   R   R   R   Ri   R   R   Rj   t   readt   pycDatat   tPrintR5   R9   t   objectR   R�   R   Ry   RK   t   argvt   exitt
   dictParamst   evalt   itemsRA   t   valuet   lowert   int(    (    (    s   i8n_2_xls.pyt   <module>   sJ   $
�	

 