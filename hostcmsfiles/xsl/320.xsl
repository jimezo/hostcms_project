<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- МагазинГруппыТоваровНаГлавной -->

	<xsl:template match="/">
		<xsl:apply-templates select="/shop"/>
	</xsl:template>

	<!-- Шаблон для магазина -->
	<xsl:template match="/shop">
		<div class="left-block-widget">
			<h4>Магазин</h4>

			<div class="shop-group-menu">
				<ul>
					<xsl:apply-templates select="shop_group"/>
				</ul>
			</div>
		</div>
	</xsl:template>

	<!-- Шаблон для групп товара -->
	<xsl:template match="shop_group">
		<li>
			<a href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_group">
				<xsl:if test="@id = /shop/current_group_id">
					<xsl:attribute name="class">current-group</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="name"/>
			</a>

			<span>(<xsl:value-of disable-output-escaping="yes" select="items_count"/>)</span>
		</li>
	</xsl:template>
</xsl:stylesheet>