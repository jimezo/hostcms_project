<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- НижнееМеню -->

	<xsl:template match="/site">
		<div class="row footer_menu">
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<ul>
					<div class="row">
						<xsl:apply-templates select="structure[show=1]" />
					</div>
				</ul>
			</div>
		</div>
	</xsl:template>

	<xsl:variable name="count" select="count(/site/structure[show=1])"/>

	<!-- Запишем в константу ID структуры, данные для которой будут выводиться пользователю -->
	<xsl:variable name="floor" select="floor($count div 3)"/>

	<!-- Не распределенные элементы -->

	<xsl:template match="structure">
		<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
			<li>
				<!-- Set $link variable -->
				<xsl:variable name="link">
					<xsl:choose>
						<!-- External link -->
						<xsl:when test="url != ''">
							<xsl:value-of disable-output-escaping="yes" select="url"/>
						</xsl:when>
						<!-- Internal link -->
						<xsl:otherwise>
							<xsl:value-of disable-output-escaping="yes" select="link"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- Menu Node -->
				<a href="{$link}" title="{name}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="structure"><xsl:value-of select="name"/></a>
			</li>
		</div>
	</xsl:template>
</xsl:stylesheet>