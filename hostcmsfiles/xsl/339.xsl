<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>
	
	<!-- МагазинПоследнийЗаказ -->
	
	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>
	
	<xsl:template match="/shop">
		<div class="left-block-widget">
			<h4>Последний заказ</h4>
			
			<div class="row block-content">
				<xsl:apply-templates select="shop_item[position() &lt; 4]"/>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="shop_item">
		<div class="col-xs-12 spec_item">
			<div class="product-image">
				<a href="{url}" title="{name}">
					<xsl:choose>
						<xsl:when test="image_small != ''">
							<img src="{dir}{image_small}" alt="{name}" />
						</xsl:when>
						<xsl:otherwise>
							<img src="/images/no-image.png" />
						</xsl:otherwise>
					</xsl:choose>
				</a>
			</div>
			
			<div class="product-shop">
				<h3 class="product-name">
					<a href="{url}" title="{name}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item">
						<xsl:value-of select="name"/>
					</a>
				</h3>
			</div>
			
			<div class="price-box">
				<p class="special-price">
					<span class="price">
						<xsl:apply-templates select="/shop/shop_currency/code">
							<xsl:with-param name="value" select="price" />
						</xsl:apply-templates>
					</span>
				</p>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="shop_currency/code">
		<xsl:param name="value" />
		
		<xsl:variable name="spaced" select="format-number($value, '# ###', 'my')" />
		
		<xsl:choose>
			<xsl:when test=". = 'USD'">$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'EUR'">€<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'GBP'">£<xsl:value-of select="$spaced"/></xsl:when>
		<xsl:when test=". = 'RUB'"><xsl:value-of select="$spaced"/><i class="fa fa-ruble"></i></xsl:when>
			<xsl:when test=". = 'AUD'">AU$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'CNY'"><xsl:value-of select="$spaced"/>元</xsl:when>
			<xsl:when test=". = 'JPY'"><xsl:value-of select="$spaced"/>¥</xsl:when>
			<xsl:when test=". = 'KRW'"><xsl:value-of select="$spaced"/>₩</xsl:when>
			<xsl:when test=". = 'PHP'"><xsl:value-of select="$spaced"/>₱</xsl:when>
			<xsl:when test=". = 'THB'"><xsl:value-of select="$spaced"/>฿</xsl:when>
			<xsl:when test=". = 'BRL'">R$<xsl:value-of select="$spaced"/></xsl:when>
		<xsl:when test=". = 'INR'"><xsl:value-of select="$spaced"/><i class="fa fa-inr"></i></xsl:when>
		<xsl:when test=". = 'TRY'"><xsl:value-of select="$spaced"/><i class="fa fa-try"></i></xsl:when>
		<xsl:when test=". = 'ILS'"><xsl:value-of select="$spaced"/><i class="fa fa-ils"></i></xsl:when>
			<xsl:otherwise><xsl:value-of select="$spaced"/> <xsl:value-of select="." /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>