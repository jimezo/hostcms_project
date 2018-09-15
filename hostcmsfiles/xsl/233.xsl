<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>
	
	<!-- Запишем в константу ID структуры, данные для которой будут выводиться пользователю -->
	<xsl:variable name="current_structure_id" select="/site/current_structure_id"/>
	
	<xsl:template match="/site">
		<nav class="navbar navbar-default">
			<div class="container-fluid">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#top-menu">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
				</div>
				<div class="collapse navbar-collapse" id="top-menu">
					<ul class="nav navbar-nav">
						<!-- Главная -->
						<li>
							<xsl:if test="//structure[@id = $current_structure_id]/path = '/'">
								<xsl:attribute name="class">current</xsl:attribute>
							</xsl:if>
							
							<a href="/" title="{name}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="structure"><i class="fa fa-home fa-fw"></i>
							</a>
						</li>
						
						<!-- Выбираем узлы структуры первого уровня -->
						<xsl:apply-templates select="structure[show=1]" />
					</ul>
				</div>
			</div>
		</nav>
	</xsl:template>
	
	<xsl:template match="structure">
		<li>
			<xsl:if test="structure[show=1]">
				<xsl:attribute name="class">dropdown</xsl:attribute>
			</xsl:if>
			<xsl:if test="structure[show=1] and position() = 1">
				<xsl:attribute name="class">dropdown first</xsl:attribute>
			</xsl:if>
			<xsl:if test="structure[show=1] and position() = last()">
				<xsl:attribute name="class">dropdown last</xsl:attribute>
			</xsl:if>
			<!--
			Выделяем текущую страницу добавлением к li класса current,
			если это текущая страница, либо у нее есть ребенок с атрибутом id, равным текущей группе.
			-->
			<xsl:if test="$current_structure_id = @id or count(.//structure[@id=$current_structure_id]) = 1">
				<xsl:attribute name="class">dropdown current</xsl:attribute>
			</xsl:if>
			
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
			<a href="{$link}" role="button" aria-haspopup="true"  title="{name}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="structure">
				<xsl:if test="structure[show=1]">
					<xsl:attribute name="data-toggle">dropdown</xsl:attribute>
					<xsl:attribute name="class">dropdown-toggle</xsl:attribute>
				</xsl:if>
				
				<xsl:value-of select="name"/>
				
				<xsl:if test="structure[show=1]">
					<i class="fa fa-angle-down"></i>
					<!-- <span class="caret"></span> -->
				</xsl:if>
			</a>
			
			<xsl:if test="structure[show=1]">
				<ul class="dropdown-menu" id="menu1">
					<xsl:apply-templates select="structure[show=1]" mode="submenu" />
				</ul>
			</xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template match="structure" mode="submenu">
		<li>
			<xsl:if test="structure[show=1]">
				<xsl:attribute name="class">dropdown</xsl:attribute>
			</xsl:if>
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
			<a href="{$link}" title="{name}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="structure">
				<xsl:if test="structure[show=1]">
					<xsl:attribute name="data-toggle">dropdown</xsl:attribute>
					<xsl:attribute name="class">dropdown-toggle</xsl:attribute>
				</xsl:if>
				
				<xsl:value-of select="name"/>
				
				<xsl:choose>
					<xsl:when test="structure[show=1]">
						<i class="fa fa-angle-right"></i>
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</a>
			
			<xsl:if test="structure[show=1]">
				<ul class="dropdown-menu sub-menu">
					<xsl:apply-templates select="structure[show=1]" mode="sub-submenu" />
				</ul>
			</xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template match="structure" mode="sub-submenu">
		<li>
			<xsl:if test="structure[show=1]">
				<xsl:attribute name="class">dropdown</xsl:attribute>
			</xsl:if>
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
	</xsl:template>
</xsl:stylesheet>