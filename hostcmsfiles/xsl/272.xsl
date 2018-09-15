<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/">
		<xsl:apply-templates select="/document"/>
	</xsl:template>

	<xsl:template match="/document">

		<!-- Получаем ID родительской группы и записываем в переменную $parent_group_id -->
		<xsl:variable name="parent_group_id" select="blocks/parent_group_id"/>

		
		<xsl:if test="blocks/parent_group_id=0">
			<h1>
				<xsl:value-of disable-output-escaping="yes" select="blocks/name"/>
			</h1>
			<xsl:value-of disable-output-escaping="yes" select="blocks/description"/>
		</xsl:if>

		<!-- Show group name inside group -->
		<xsl:if test="blocks/parent_group_id!=0">
			<h1>
				<xsl:value-of disable-output-escaping="yes" select=".//group[@id=$parent_group_id]/name"/>
			</h1>

			<!-- Breadcrumbs -->
			<p>
				<xsl:apply-templates select=".//group[@id=$parent_group_id]" mode="goup_path"/>
			</p>
		</xsl:if>

		<!-- Отображение подгрупп данной группы -->
		<ul>
			<xsl:apply-templates select=".//group[@parent_id=$parent_group_id]" mode="goups"/>
		</ul>

		<!-- Show informationsystem_item -->
		<xsl:apply-templates select="blocks/items/item[item_status=1]"/>

		<p>
			<!-- Pagination -->
			<xsl:if test="ОтображатьСсылкиНаСледующиеСтраницы=1">
				<xsl:if test="blocks/items/count_items &gt; blocks/items/items_on_page">
					<p>
						<xsl:call-template name="for">
							<xsl:with-param name="n" select="blocks/items/count_items div blocks/items/items_on_page"/>
							<xsl:with-param name="current_page" select="blocks/items/current_page"/>
						</xsl:call-template>
						<div style="clear: both"></div>
					</p>
				</xsl:if>
			</xsl:if>
		</p>

		<div style="margin-right:10px">
			<table border="0" width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<!-- Ссылка на архив -->
					<xsl:if test="ОтображатьСсылкуНаАрхив=1">
						<td>
							<a href="{blocks/url}">Архив "<xsl:value-of disable-output-escaping="yes" select="blocks/name"/>"</a>
						</td>
					</xsl:if>
					<td align="right">
						<a href="{blocks/url}rss/">
							<img src="/images/rss/rss_2.0.gif"/>
						</a>
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>

	<!-- ======================================================== -->
	<!-- Breadcrumb -->
	<!-- ======================================================== -->

	<xsl:template match="group" mode="goup_path">
		<xsl:variable name="parent_id" select="@parent_id"/>

		<xsl:apply-templates select="//group[@id=$parent_id]" mode="goup_path"/>

		<xsl:if test="@parent_id=0">
			<a href="{/document/blocks/url}">
				<xsl:value-of disable-output-escaping="yes" select="/document/blocks/name"/>
			</a>
		</xsl:if>

		<span><xsl:text> → </xsl:text></span>
		<a href="{/document/blocks/url}{fullpath}">
			<xsl:value-of select="name"/>
		</a>
	</xsl:template>

	<!-- ======================================================== -->
	<!-- Subgroups Template -->
	<!-- ======================================================== -->
	<xsl:template match="group" mode="goups">
		<li>
			<xsl:if test="small_image!=''">
				<a href="{/document/blocks/url}{fullpath}">
					<img src="{small_image}"/>
				</a><xsl:text> </xsl:text></xsl:if>
			<a href="{/document/blocks/url}{fullpath}">
				<b>
					<xsl:value-of select="name"/>
				</b>
			</a>
		</li>
	</xsl:template>

	<!-- ======================== -->
	<!-- Данные об инф. элементах -->
	<!-- ======================== -->
	<xsl:template match="blocks/items/item">

		<div style="margin-right:10px; margin-bottom: 5px;">


			<!-- Text representation of a date -->

			<br/>
			<!-- Название -->
			<a href="{item_path}" class="news_title">
				<xsl:value-of disable-output-escaping="yes" select="item_name"/>
			</a>
			<span class="news_date" style="padding-left: 10px">Опубликовано <xsl:value-of disable-output-escaping="yes" select="item_datetime"/></span>
			<br/>

			<!-- Image -->
			<xsl:if test="item_small_image!=''">
				<a href="{item_path}" class="news_title">
					<img src="{item_small_image}" class="partner_img" alt="" style="margin: 3px 10px 10px 0px" align="left"/>
				</a>
			</xsl:if>

			<xsl:value-of disable-output-escaping="yes" select="item_description"/>

			<div style="clear: both;"></div>
		</div>
	</xsl:template>

	<!-- Pagination -->
	<xsl:template name="for">
		<xsl:param name="i" select="0"/>
		<xsl:param name="n"/>
		<xsl:param name="current_page"/>

		<xsl:if test="$n &gt; $i">
			<!-- Pagination item -->
			<xsl:if test="$i != $current_page">

				<!-- Заносим в переменную $parent_group_id идентификатор текущей группы -->
				<xsl:variable name="parent_group_id" select="/document/blocks/parent_group_id"/>

				<!-- Choose Group Path -->
				<xsl:variable name="group_link">
					<xsl:choose>
						<!-- If the group is not root -->
						<xsl:when test="$parent_group_id != 0">
							<xsl:value-of select="/document/blocks//group[@id=$parent_group_id]/fullpath"/>
						</xsl:when>
						
						 <xsl:otherwise><xsl:value-of select="/informationsystem/url"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- Set $link variable -->
				<xsl:variable name="number_link">
					<xsl:choose>
						
						<xsl:when test="$i != 0">page-<xsl:value-of select="$i+1"/>/</xsl:when>
						
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<a href="{/document/blocks/url}{$group_link}{$number_link}" class="page_link">
					<xsl:value-of select="$i + 1"/>
				</a>
			</xsl:if>

			<!-- Current pagination item -->
			<xsl:if test="$i = $current_page">
				<span class="current">
					<xsl:value-of select="$i + 1"/>
				</span>
			</xsl:if>

			<!-- Recursive Template -->
			<xsl:call-template name="for">
				<xsl:with-param name="i" select="$i + 1"/>
				<xsl:with-param name="n" select="$n"/>
				<xsl:with-param name="current_page" select="$current_page"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>