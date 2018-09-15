<?php
// Счетчик
if (Core::moduleIsActive('counter'))
{
?>
<!-- HostCMS Counter -->
<script type="text/javascript">document.cookie="hostmake=1; path=/";document.write("<a href=\"http://www.hostcms.ru/\"><img src=\"/counter/counter.php?rand="+Math.random()+"&id=<?php echo CURRENT_SITE?>&refer="+escape(document.referrer)+"&amp;current_page="+escape(window.location.href)+"&cookie="+(document.cookie?"Y":"N")+"&java="+(navigator.javaEnabled()?"Y":"N")+"&screen="+screen.width+'x'+screen.height+"&px="+(((navigator.appName.substring(0,9)=="Microsoft"))?screen.colorDepth:screen.pixelDepth)+"&js_version=1.6&counter=0\" alt=\"HostCMS Counter\" width=\"88\" height=\"31\" /></a>")</script>
<noscript>
<a href="http://www.hostcms.ru/">
<img alt="HostCMS Counter" height="31" src="/counter/counter.php?id=<?php echo CURRENT_SITE?>&amp;counter=0" width="88" /></a></noscript><!-- HostCMS Counter -->
<?php
}
?>