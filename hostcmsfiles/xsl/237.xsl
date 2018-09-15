<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- СписокУслугНаГлавной -->

	<xsl:template match="/">
		<div class="row">
			<xsl:apply-templates select="/informationsystem/informationsystem_item" />
		</div>
	</xsl:template>

	<xsl:template match="informationsystem_item">
		<div class="col-xs-12 col-md-6">
			<div class="item-service border-right">
				<div class="row head-service">
					<div class="col-md-2">
						<xsl:choose>
							<xsl:when test="property_value[tag_name='badge']/value != ''">
								<i class="fa {property_value[tag_name='badge']/value}"></i>
							</xsl:when>
							<xsl:otherwise>
								<i class="fa fa-star-o"></i>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<div class="col-md-10">
						<h4><a href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="informationsystem_item"><xsl:value-of select="name"/></a></h4>
					</div>
				</div>
				<p><xsl:value-of disable-output-escaping="yes" select="description"/></p>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>