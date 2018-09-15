<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- ОтображениеРезультатовОпроса -->

	<xsl:template match="/">
		<xsl:apply-templates select="/poll_group"/>
	</xsl:template>

	<xsl:template match="poll_group">

		<h1 hostcms:id="{poll/@id}" hostcms:field="poll/name" hostcms:entity="poll">
			<xsl:value-of select="poll/name"/>
		</h1>

		<xsl:if test="ПользовательИмеетПравоОтвечать=1">
			<xsl:if test="ОтображатьСообщениеПользователю=1">
				<div class="alert alert-success">
					Спасибо Ваш ответ принят!
				</div>
			</xsl:if>
		</xsl:if>

		<xsl:if test="poll/show_results != 1 and ОтображатьСообщениеПользователю != 1">
			<div class="alert alert-danger">
				Запрещено отображение результатов!
			</div>
		</xsl:if>

		<xsl:if test="ПользовательИмеетПравоОтвечать=0">
			<div class="alert alert-danger">
				Вы уже голосовали по данному опросу!
			</div>
		</xsl:if>

		<xsl:if test="not(НеВыбранВариантОтвета=1 and poll/show_results != 1)">
			<xsl:if test="poll/show_results = 1 or ПоказатьРезультытыБезГолосования = 1">
				<!-- Отображаем результаты голосования -->

				<div class="row">
					<div class="col-xs-12">
						<xsl:apply-templates select="poll/poll_response" />
					</div>
					<div class="col-xs-12">
						<h3>Всего голосов: <strong><xsl:value-of select="poll/voted"/></strong></h3>
					</div>
				</div>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!-- Отображение результатов голосования -->
	<xsl:template match="poll/poll_response">
		<xsl:variable name="color_number">
			<xsl:choose>
				<xsl:when test="position() &lt;= 4 and position() mod 4 != 0">
					<xsl:value-of select="position()"/>
				</xsl:when>
				<xsl:when test="position() mod 4 = 0">4</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="position() mod 4"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="percent"><xsl:choose>
				<xsl:when test="../voted = 0">0</xsl:when>
				<xsl:otherwise><xsl:value-of select="round(voted div ../voted * 100)" /></xsl:otherwise>
		</xsl:choose></xsl:variable>

		<div class="row">
			<div class="col-xs-3">
				<h4><xsl:value-of select="name"/></h4>
			</div>
			<div class="col-xs-9">
				<div class="polls">
					<div>
						<xsl:choose>
							<xsl:when test="$percent = 0">
								<xsl:attribute name="class">bg-vote-0</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">bg-vote-<xsl:value-of select="$color_number"/></xsl:attribute>
								<xsl:attribute name="style">width: <xsl:value-of select="$percent"/>%</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<span><xsl:value-of select="$percent"/>%</span>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>