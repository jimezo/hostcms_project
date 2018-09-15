<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- СписокНовостейНаГлавной -->

	<xsl:template match="/informationsystem">
		<div class="left-block-widget">
			<h4><xsl:value-of select="name" /></h4>

			<!-- Отображение записи информационной системы -->
			<div class="news-list">
				<xsl:apply-templates select="informationsystem_item" />
			</div>
		</div>
	</xsl:template>

	<xsl:template match="informationsystem_item">
		<div class="row margin-bottom-10">
			<div class="col-xs-12">
				<div class="date">
					<xsl:call-template  name="date_to_str">
						<xsl:with-param name="date" select="date" />
					</xsl:call-template>
				</div>
				<a href="{url}"><xsl:value-of select="name" /></a>
			</div>
		</div>
	</xsl:template>

	<!-- Вывод даты с месяцем на русском -->
	<xsl:template name="date_to_str">
	   <xsl:param name="date" select="date"/>

	   <xsl:variable select="substring-after($date, '.')" name="month_postfixDate" />
	   <xsl:variable select="substring-before($month_postfixDate, '.')" name="month" />

	   <xsl:value-of select="number(substring-before($date, '.'))"/>&#160;<xsl:choose>
		  <xsl:when test="$month = 1">января</xsl:when>
		  <xsl:when test="$month = 2">февраля</xsl:when>
		  <xsl:when test="$month = 3">марта</xsl:when>
		  <xsl:when test="$month = 4">апреля</xsl:when>
		  <xsl:when test="$month = 5">мая</xsl:when>
		  <xsl:when test="$month = 6">июня</xsl:when>
		  <xsl:when test="$month = 7">июля</xsl:when>
		  <xsl:when test="$month = 8">августа</xsl:when>
		  <xsl:when test="$month = 9">сентября</xsl:when>
		  <xsl:when test="$month = 10">октября</xsl:when>
		  <xsl:when test="$month = 11">ноября</xsl:when>
		  <xsl:otherwise>декабря</xsl:otherwise>
	   </xsl:choose>&#160;<xsl:value-of select="substring-after($month_postfixDate, '.')"/>
	</xsl:template>

	<!-- informationsystem_item template -->
	<xsl:template match="informationsystem_item" mode="123">
		<div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
			<div class="thumbnail">
				<!-- Text representation of a date -->
				<div class="box clearfix">
					<div>
						<strong>
							<xsl:value-of select="substring-before(date, '.')"/>
						</strong>
						<xsl:variable name="month_year" select="substring-after(date, '.')"/>
						<xsl:variable name="month" select="substring-before($month_year, '.')"/>
						<span>
							<xsl:choose>
								<xsl:when test="$month = 1"> января </xsl:when>
								<xsl:when test="$month = 2"> февраля </xsl:when>
								<xsl:when test="$month = 3"> марта </xsl:when>
								<xsl:when test="$month = 4"> апреля </xsl:when>
								<xsl:when test="$month = 5"> мая </xsl:when>
								<xsl:when test="$month = 6"> июня </xsl:when>
								<xsl:when test="$month = 7"> июля </xsl:when>
								<xsl:when test="$month = 8"> августа </xsl:when>
								<xsl:when test="$month = 9"> сентября </xsl:when>
								<xsl:when test="$month = 10"> октября </xsl:when>
								<xsl:when test="$month = 11"> ноября </xsl:when>
								<xsl:otherwise> декабря </xsl:otherwise>
							</xsl:choose>
						</span>
					<!-- <span><xsl:value-of select="substring-after($month_year, '.')"/><xsl:text> г.</xsl:text></span>-->
					</div>

					<hr/>
					<a href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="informationsystem_item">
						<xsl:value-of select="name"/>
					</a>
				</div>

				<div class="caption" hostcms:id="{@id}" hostcms:field="description" hostcms:entity="informationsystem_item">
					<xsl:value-of disable-output-escaping="yes" select="description"/>
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>