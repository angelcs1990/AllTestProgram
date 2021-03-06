ó
H6Xc           @   sÏ  d  d l  Z  d  d l Z d  d l Z d  d l Z d Z d Z d Z d Z d Z d Z	 d Z
 d	   Z d
   Z d   Z d e f d     YZ d   Z i e d 6e d 6e d 6e	 d 6e
 d 6e d 6Z e d k rËd  d l Z e e j  d k r e e j  d k r e d  e j d  n  i  Z y e e j  d k re e j d  Z x< e j   D]+ \ Z Z e j   d k r^e e e <q^q^Wn  e j e e   p¥d   WqËe k
 rÇZ e GHqËXn  d S(   iÿÿÿÿNt   i8ns   .stringst   keys   zh-Hanss   source.xlsxi   s%   static NSString *const {0} = @"{0}";
c         C   s   d |  d GHd  S(   Ns   [31ms   [æç¤º]s   [0ms   [31m[æç¤º](    (   t   msg(    (    s   i8n_create_GGame.pyt   consolePrint0   s    c         C   s   d |  d GHd  S(   Ns   [32ms   [æä½]s   [0ms   [32m[æä½](    (   R   (    (    s   i8n_create_GGame.pyt   actionPrint2   s    c         C   s   d |  d GHd  S(   Ns   [33ms   [ç»æ­¢è¿è¡]s   [0ms   [33m[ç»æ­¢è¿è¡](    (   R   (    (    s   i8n_create_GGame.pyt   errPrint4   s    t   excel_processc           B   s_   e  Z d  Z d   Z d   Z d   Z d   Z d   Z d   Z d   Z	 d   Z
 d	   Z RS(
   s   docstring for excel_processc         C   sc   t  t |   j   d |  _ d |  _ d |  _ d |  _ d |  _ d  |  _	 d  |  _
 |  j |  d  S(   Nt    i    (   t   superR   t   __init__t   m_keyt
   m_notesKeyt   m_headerFileTypet   m_headerFileTemplatet   m_outputFoldert   Nonet   datat   tablet
   open_excel(   t   selft   filepath(    (    s   i8n_create_GGame.pyR	   9   s    							c         C   sE   y |  j  j   d |  _ Wn$ t k
 r@ } t |  GH|  n Xd  S(   Ni    (   R   t   sheetsR   t	   Exceptiont   str(   R   t   e(    (    s   i8n_create_GGame.pyt
   open_tableD   s
    c         C   sK   y  t  j |  |  _ |  j   Wn$ t k
 rF } t |  GH|  n Xd  S(   N(   t   xlrdt   open_workbookR   R   R   R   (   R   t	   excelnameR   (    (    s   i8n_create_GGame.pyR   J   s    c         C   s`   |  j  j d k r d S|  j  j d  } x1 t d t |   D] } | | | k r> | Sq> Wd S(   Ni    iÿÿÿÿ(   R   t   nrowst
   row_valuest   xranget   len(   R   t   match_titlet   titlest   col(    (    s   i8n_create_GGame.pyt   query_key_indexS   s    c         C   si   d   } |   } | d |  j  } t j j |  se t d | j d  j d   t j |  n  | S(   Nc          S   sI   t  j d }  t j j |   r# |  St j j |   rE t j j |   Sd  S(   Ni    (   t   syst   patht   ost   isdirt   isfilet   dirname(   R&   (    (    s   i8n_create_GGame.pyt   get_cur_path^   s
    t   /s   åå»ºäºæ°ç®å½ï¼s   utf-8t   gb2312(   R   R'   R&   t   existsR   t   decodet   encodet   mkdir(   R   R+   R&   t   i8n_path(    (    s   i8n_create_GGame.pyt   get_path]   s    		 c   	         sï   t    d  d k r d S j   } d   d d t } | | j d  j d  } t | d  } t d | j d  j d      f d	   } t    d  d } x$ t d |  D] } | | |  q½ W| | |  | j   d  S(
   Ni    iÿÿÿÿR,   i   s   utf-8R-   t   wbs   çææ°æä»¶ï¼c            s:   j  j d  | j d d !d k rF  j  j d  | j d } nÔ  j  j d  | j d d k rè   d | d k r¹   d | d d k r¹ d d	   d | d d
 !d } qd d	  j  j d  | j d d
 !d } n2 d	   d | d	 d d	   d | d	 d } | j d  } |  j |  d  S(   Ni    i   s   //s   
t   #i   R   s   CFBundleDisplayName=s   "iÿÿÿÿs   ";
t   =s   ;
s   utf-8(   R   R#   t   valueR0   t   write(   t	   fileHandet   idxt
   value_pairt   strss(   t	   dictvalueR   (    s   i8n_create_GGame.pyt   writeToi18nFilev   s    & #,$/2(	   R    R3   t   file_suffixR/   R0   t   openR   R   t   close(	   R   R=   R2   t   i8n_file_namet   tmpFilePatht   fR>   t   lastIdxR:   (    (   R=   R   s   i8n_create_GGame.pyt   create_i8n_filej   s     c         C   sh   |  j  |  j  } | d k r, t d  d  S|  j j |  } t |  t |  k rd t d  d  S| S(   Niÿÿÿÿs   æ²¡æå¹éå°æ³¨éå¼s   æ³¨éå¼é¿åº¦ä¸å¹é(   R$   R   R   R   R   t
   col_valuesR    (   R   t   arrayValuest   keyColIndext   keys(    (    s   i8n_create_GGame.pyt	   get_notes   s    

c            sî  t    d  d k r d S j   } d } d | } | | j d  j d  } t | d  } t d | j d  j d   | j d	  | j d
   j   d       f d   }     f d   }     f d   }	 t    d  d }
  j d k rGx$ t	 d |
  D] } | | |  q W| | |
  n  j d k rx$ t	 d |
  D] } |	 | |  qfW|	 | |
  nF  j d k rÓx$ t	 d |
  D] } | | |  q¬W| | |
  n  | j d  | j
   d  S(   Ni    iÿÿÿÿs   i18n_header.hR,   s   utf-8R-   R4   s   çææ°æä»¶ï¼s   #ifndef i18n_header_h
s   #define i18n_header_h
c            sa  d }  j  j d  | j d d !d k rL  j  j d  | j d } nõ  j  j d  | j d d k rî   d | d k r¿   d | d d k r¿ d d	   d | d d
 !d } qAd d	  j  j d  | j d d
 !d } nS  d  k rd  | d } n  | d   d | d d   d | d	 d 7} | j d  } |  j |  d  S(   NR   i    i   s   //s   
R5   i   s   CFBundleDisplayName=s   "iÿÿÿÿs   ";
s   /**s   */
s   static NSString *const R6   s   @"s   ;
s   utf-8(   R   R#   R7   R   R0   R8   (   R9   R:   R;   R<   (   R=   t   notesR   (    s   i8n_create_GGame.pyt   writeToi18nFile_static©   s    & #,$/2c            sj  d }  j  j d  | j d d !d k rL  j  j d  | j d } nþ  j  j d  | j d d k rî   d | d k r¿   d | d d k r¿ d d	   d | d d
 !d } qJd d	  j  j d  | j d d
 !d } n\  d  k rd  | d } n   j j d   d |  j d   d |  } | | 7} | j d  } |  j |  d  S(   NR   i    i   s   //s   
R5   i   s   CFBundleDisplayName=s   "iÿÿÿÿs   ";
s   /**s   */
s   {0}s   {1}s   utf-8(   R   R#   R7   R   R   t   replaceR0   R8   (   R9   R:   R;   t   templateStrR<   (   R=   RL   R   (    s   i8n_create_GGame.pyt   writeToi18nFile_template¸   s    & #,$/1
c            sa  d }  j  j d  | j d d !d k rL  j  j d  | j d } nõ  j  j d  | j d d k rî   d | d k r¿   d | d d k r¿ d d	   d | d d
 !d } qAd d	  j  j d  | j d d
 !d } nS  d  k rd  | d } n  | d   d | d d   d | d d 7} | j d  } |  j |  d  S(   NR   i    i   s   //s   
R5   i   s   CFBundleDisplayName=s   "iÿÿÿÿs   ";
s   /**s   */
s   #define t    s   LOCALIZATION(@"s   ")s   ;
s   utf-8(   R   R#   R7   R   R0   R8   (   R9   R:   R;   R<   (   R=   RL   R   (    s   i8n_create_GGame.pyt   writeToi18nFile_defineÉ   s    & #,$/2i   i   s   #endif
(   R    R3   R/   R0   R@   R   R8   RK   R   R   RA   (   R   R=   R2   RB   t   tmpFileNameRC   RD   RM   RP   RR   RE   R:   (    (   R=   RL   R   s   i8n_create_GGame.pyt   create_i18n_header   s:    
 c   
      C   sX  |  j  |  j  } | d k r, t d  d S|  j j } |  j j |  } g  } t } xû t d |  D]ê } g  g  g } |  j j |  } t |  t |  k r° t d  d Sxd t d t |   D]M }	 | t k rþ | j	 | |	 j
   j d d   n  | d j	 | |	  qÆ W| | d <t } |  j |  | | k rf |  j |  qf qf Wd  S(   Niÿÿÿÿs   æ²¡ææ¾å°å¹éå·¦å¼i    s   æ å°æ°æ®ä¸å¯¹ç§°RQ   t   _i   (   R$   R
   R   R   t   ncolsRG   t   TrueR   R    t   appendt   stripRN   t   FalseRF   RT   (
   R   RI   t   colsRJ   t	   keyValuest   bKeyValuesEmptyR#   t   tmpValuet   valuest   row_idx(    (    s   i8n_create_GGame.pyt   create_i8n_valuesë   s.    

&
(   t   __name__t
   __module__t   __doc__R	   R   R   R$   R3   RF   RK   RT   Ra   (    (    (    s   i8n_create_GGame.pyR   7   s   					
		 		Sc          C   s3  t  d }  t  d } t  d } t t  d  } t  d } t  d } i d d 6d	 d
 6d d 6} | d k  su | d k r~ d } n  t d |   t d |  t d |  t d | |  t d | j d d   t d |  t d  t |  } |  | _ | | _ | | _ | | _ | | _	 | j
   d  S(   NR   t   notesKeyt
   sourceFilet   headerFileTypet   headerFileTemplatet   outputFolders   é»è®¤statici    s   é»è®¤definei   s	   èªå®ä¹i   s   ä¸»é®:s
   æ³¨éé®:s
   æºæä»¶:s   çæå¤´æä»¶ç±»å:s   å¤´æä»¶æ¨¡æ¿:s   
R   s   è¾åºç®å½:s@   æååï¼è¯·ç¨i8n_file_replace.pyèæ¬è¿è¡ä¸ä¸æ­¥æä½(   t   g_Paramst   intR   RN   R   R
   R   R   R   R   Ra   (   R   Re   Rf   Rg   Rh   Ri   t   tmpDictt   ep(    (    s   i8n_create_GGame.pyt   main  s.    




	
					Re   Rf   Rg   Rh   Ri   t   __main__i   sÇ   ä¾å­: i8n_create_GGame.cs "{"key":"key", "notesKey":"zh-Hans", "sourceFile":"source.xlsx", "headerFileType":"2", "headerFileTemplate":'static NSString *const {0} = @"{0}";
', "outputFolder":"i8n"}"R   i    (    R   R'   R%   t   ret   file_save_folderR?   t   left_tag_keyt   value_notes_keyt   excel_file_namet   open_header_input_type_definet   template_exampleR   R   R   t   objectR   Rn   Rj   Rb   R    t   argvt   csPrintt   exitt
   dictParamst   evalt   itemsR   R7   RY   Rk   R   R   (    (    (    s   i8n_create_GGame.pyt   <module>   sJ   			Ù	
*
 