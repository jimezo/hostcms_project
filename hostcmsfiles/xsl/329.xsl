<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>
	
	<!-- МагазинСписокПроизводителей -->
	
	<xsl:template match="/">
		<xsl:apply-templates select="shop"/>
	</xsl:template>
	
	<xsl:variable name="n" select="number(3)"/>
	
	<xsl:template match="shop">
		<h1 class="item_title">Производители</h1>
		
		<xsl:if test="count(shop_producer) = 0">
			<div class="alert alert-danger">Производители не найдены!</div>
		</xsl:if>
		
		<!-- <table cellspacing="0" cellpadding="0" border="0" width="100%">
			<tr> -->
				<xsl:apply-templates select="shop_producer[position() mod $n = 1]"/>
				<!-- </tr>
		</table>-->
		
		<!-- Current page link -->
		<xsl:variable name="link"><xsl:value-of select="/shop/url"/>producers/</xsl:variable>
		
		<nav>
			<ul class="pagination">
				<xsl:call-template name="for">
					<xsl:with-param name="link" select="$link"/>
					<xsl:with-param name="limit" select="/shop/limit"/>
					<xsl:with-param name="page" select="/shop/page"/>
					<xsl:with-param name="total" select="/shop/total"/>
					<xsl:with-param name="visible_pages">5</xsl:with-param>
				</xsl:call-template>
			</ul>
		</nav>
		
	</xsl:template>
	
	<xsl:template match="shop_producer">
		<div class="row">
			<xsl:for-each select=". | following-sibling::shop_producer[position() &lt; $n]">
				<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 text-align-center">
					<xsl:if test="image_small != ''">
						<div>
							<img src="{dir}{image_small}" class="item-image"/>
						</div>
					</xsl:if>
					
					<a href="{/shop/url}producers/{path}/"><xsl:value-of disable-output-escaping="no" select="name"/></a>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>
	
	<!-- Pagination -->
	<xsl:template name="for">
		<xsl:param name="i" select="0"/>
		<xsl:param name="prefix">page</xsl:param>
		<xsl:param name="link"/>
		<xsl:param name="limit"/>
		<xsl:param name="page"/>
		<xsl:param name="total"/>
		<xsl:param name="visible_pages"/>
		
		<xsl:variable name="n" select="$total div $limit"/>
		
		<!-- Заносим в переменную $parent_group_id идентификатор текущей группы -->
		<xsl:variable name="parent_group_id" select="/document/parent_group_id"/>
		
		<!-- Links before current -->
		<xsl:variable name="pre_count_page">
			<xsl:choose>
				<xsl:when test="$page &gt; ($n - (round($visible_pages div 2) - 1))">
					<xsl:value-of select="$visible_pages - ($n - $page)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="round($visible_pages div 2) - 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Links after current -->
		<xsl:variable name="post_count_page">
			<xsl:choose>
				<xsl:when test="0 &gt; $page - (round($visible_pages div 2) - 1)">
					<xsl:value-of select="$visible_pages - $page"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="round($visible_pages div 2) = ($visible_pages div 2)">
							<xsl:value-of select="$visible_pages div 2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="round($visible_pages div 2) - 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$i = 0 and $page != 0">
			<li>
			<span aria-hidden="true"><i class="fa fa-angle-double-left"></i></span>
			</li>
		</xsl:if>
		
		<xsl:if test="$i &gt;= $n and ($n - 1) &gt; $page">
			<li>
			<span aria-hidden="true"><i class="fa fa-angle-double-right"></i></span>
			</li>
		</xsl:if>
		
		<xsl:if test="$total &gt; $limit and $n &gt; $i">
			
			<!-- Set $link variable -->
			<xsl:variable name="number_link">
				<xsl:choose>
					
					<xsl:when test="$i != 0">
						<xsl:value-of select="$prefix"/>-<xsl:value-of select="$i + 1"/>/</xsl:when>
					
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<!-- Pagination item -->
			<xsl:if test="$i != $page">
				<!-- First pagination item -->
				<xsl:if test="$page - $pre_count_page &gt; 0 and $i = 0">
					<li>
						<a href="{$link}" class="page_link" style="text-decoration: none;">←</a>
					</li>
				</xsl:if>
				
				<xsl:choose>
					<xsl:when test="$i &gt;= ($page - $pre_count_page) and ($page + $post_count_page) &gt;= $i">
						<li>
							<!-- Pagination item -->
							<a href="{$link}{$number_link}" class="page_link">
								<xsl:value-of select="$i + 1"/>
							</a>
						</li>
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
				
				<!-- Last pagination item -->
				<xsl:if test="$i+1 &gt;= $n and $n &gt; ($page + 1 + $post_count_page)">
					<xsl:choose>
						<xsl:when test="$n &gt; round($n)">
							<li>
								<!-- Last pagination item -->
								<a href="{$link}{$prefix}-{round($n+1)}/" class="page_link" style="text-decoration: none;">→</a>
							</li>
						</xsl:when>
						<xsl:otherwise>
							<li>
								<a href="{$link}{$prefix}-{round($n)}/" class="page_link" style="text-decoration: none;">→</a>
							</li>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:if>
			
			<!-- Ctrl+left link -->
			<xsl:if test="$page != 0 and $i = $page">
				<xsl:variable name="prev_number_link">
					<xsl:choose>
						
						<xsl:when test="$page &gt; 1">page-<xsl:value-of select="$i"/>/</xsl:when>
						
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<a href="{$link}{$prev_number_link}" id="id_prev"></a>
			</xsl:if>
			
			<!-- Ctrl+right link -->
			<xsl:if test="($n - 1) &gt; $page and $i = $page">
				<a href="{$link}page-{$page+2}/" id="id_next"></a>
			</xsl:if>
			
			<!-- Current pagination item -->
			<xsl:if test="$i = $page">
				<span class="current">
					<xsl:value-of select="$i+1"/>
				</span>
			</xsl:if>
			
			<!-- Recursive Template -->
			<xsl:call-template name="for">
				<xsl:with-param name="i" select="$i + 1"/>
				<xsl:with-param name="prefix" select="$prefix"/>
				<xsl:with-param name="link" select="$link"/>
				<xsl:with-param name="limit" select="$limit"/>
				<xsl:with-param name="page" select="$page"/>
				<xsl:with-param name="total" select="$total"/>
				<xsl:with-param name="visible_pages" select="$visible_pages"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>