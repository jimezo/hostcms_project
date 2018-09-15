<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/">
		<div class="left-block-widget">
			<h4>Фильтр</h4>

			<div class="block-content">
				<xsl:apply-templates select="/shop">
					<xsl:with-param name="group" select="group"></xsl:with-param>
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>

	<!-- <xsl:variable name="n" select="number(3)"/>-->

	<xsl:template match="/shop">
		<xsl:variable name="group" select="group"/>
		<xsl:variable name="path"><xsl:choose>
			<xsl:when test="/shop//shop_group[@id=$group]/node()"><xsl:value-of select="/shop//shop_group[@id=$group]/url"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="/shop/url"/></xsl:otherwise>
		</xsl:choose><xsl:if test="count(tag) = 1">tag/<xsl:value-of select="tag/urlencode"/>/</xsl:if></xsl:variable>

		<form method="get" action="{$path}" class="show">
			<div class="filter">
				<div class="form-group">
					<div class="field">
						<select name="sorting" class="form-control" onchange="$(this).parents('form:first').submit()">
							<option value="0">Сортировать</option>
							<option value="1">
							<xsl:if test="sorting = 1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								По цене (сначала дешевые)
							</option>
							<option value="2">
							<xsl:if test="sorting = 2"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								По цене (сначала дорогие)
							</option>
							<option value="3">
							<xsl:if test="sorting = 3"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								По названию
							</option>
						</select>
					</div>
				</div>

				<div class="input-group">
					<span class="input-group-addon">Цена от: </span>
					<input class="form-control" name="price_from" size="5" type="text" value="{/shop/min_price}">
						<xsl:if test="/shop/price_from != 0">
							<xsl:attribute name="value"><xsl:value-of select="/shop/price_from"/></xsl:attribute>
						</xsl:if>
					</input>

					<span class="input-group-addon">до: </span>
					<input class="form-control" name="price_to" size="5" type="text" value="{/shop/max_price}">
						<xsl:if test="/shop/price_to != 0">
							<xsl:attribute name="value"><xsl:value-of select="/shop/price_to"/></xsl:attribute>
						</xsl:if>
					</input>

					<input name="price_from_original" value="{/shop/min_price}" hidden="hidden" />
					<input name="price_to_original" value="{/shop/max_price}" hidden="hidden" />
				</div>

				<div class="slider"></div>

				<!-- Фильтр по дополнительным свойствам товара: -->
				<xsl:if test="count(shop_item_properties//property[filter != 0 and (type = 0 or type = 1 or type = 3 or type = 7 or type = 11)])">
					<xsl:apply-templates select="shop_item_properties//property[filter != 0 and (type = 0 or type = 1 or type = 3 or type = 7 or type = 11)]" mode="propertyList"/>
				</xsl:if>

				<xsl:if test="/shop/on_page/node() and /shop/on_page &gt; 0">
					<input type="hidden" name="on_page" value="{/shop/on_page}" />
				</xsl:if>

				<button class="btn btn-secondary" type="submit" name="filter" value="filter">Применить</button>
			</div>
		</form>
	</xsl:template>

	<!-- Шаблон для фильтра по дополнительным свойствам -->
	<xsl:template match="property" mode="propertyList">
		<xsl:variable name="nodename">property_<xsl:value-of select="@id"/></xsl:variable>
		<xsl:variable name="nodename_from">property_<xsl:value-of select="@id"/>_from</xsl:variable>
		<xsl:variable name="nodename_to">property_<xsl:value-of select="@id"/>_to</xsl:variable>

		<div class="input-group">
			<!-- Не флажок -->
			<xsl:if test="filter != 5">
				<span class="input-group-addon"><xsl:value-of select="name"/></span>
			</xsl:if>

			<xsl:choose>
				<!-- Отображаем поле ввода -->
				<xsl:when test="filter = 1">
					<input class="form-control" type="text" name="property_{@id}">
						<xsl:if test="/shop/*[name()=$nodename] != ''">
							<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
						</xsl:if>
					</input>
				</xsl:when>
				<!-- Отображаем список -->
				<xsl:when test="filter = 2">
					<select class="form-control" name="property_{@id}">
						<option value="0">...</option>
						<xsl:apply-templates select="list/list_item"/>
					</select>
				</xsl:when>
				<!-- Отображаем переключатели -->
				<xsl:when test="filter = 3">
					<div class="propertyInput">
						<div>
							<input type="radio" name="property_{@id}" value="0" id="id_prop_radio_{@id}_0"></input>
							<label for="id_prop_radio_{@id}_0">Любой вариант</label>
						</div>
						<xsl:apply-templates select="list/list_item"/>
					</div>
				</xsl:when>
				<!-- Отображаем флажки -->
				<xsl:when test="filter = 4">
					<div class="propertyInput">
						<xsl:apply-templates select="list/list_item"/>
					</div>
				</xsl:when>
				<!-- Отображаем флажок -->
				<xsl:when test="filter = 5">
					<input type="checkbox" name="property_{@id}" id="property_{@id}" style="padding-top:4px">
						<xsl:if test="/shop/*[name()=$nodename] != ''">
							<xsl:attribute name="checked"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
						</xsl:if>
					</input>
					<label for="property_{@id}">
						<xsl:value-of select="name"/><xsl:text> </xsl:text>
					</label>
				</xsl:when>
				<!-- Отображение полей "от и до" -->
				<xsl:when test="filter = 6">
					<span class="input-group-addon">от: </span><input class="form-control" type="text" name="property_{@id}_from" size="5" value="{/shop/*[name()=$nodename_from]}"/>
					<span class="input-group-addon">до: </span><input class="form-control" type="text" name="property_{@id}_to" size="5" value="{/shop/*[name()=$nodename_to]}"/>

					<input name="property_{@id}_from_original" value="{/shop/*[name()=$nodename_from]}" hidden="hidden" />
					<input name="property_{@id}_to_original" value="{/shop/*[name()=$nodename_to]}" hidden="hidden" />
				</xsl:when>
				<!-- Отображаем список с множественным выбором-->
				<xsl:when test="filter = 7">
					<select class="form-control" name="property_{@id}[]" multiple="multiple">
						<xsl:apply-templates select="list/list_item"/>
					</select>
				</xsl:when>
			</xsl:choose>
		</div>
		<xsl:if test="filter = 6">
			<div class="slider"></div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="list/list_item">
		<xsl:if test="../../filter = 2">
			<!-- Отображаем список -->
			<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
			<option value="{@id}">
			<xsl:if test="/shop/*[name()=$nodename] = @id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				<xsl:value-of disable-output-escaping="yes" select="value"/>
			</option>
		</xsl:if>
		<xsl:if test="../../filter = 3">
			<!-- Отображаем переключатели -->
			<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
			<div>
			<input type="radio" name="property_{../../@id}" value="{@id}" id="id_property_{../../@id}_{@id}">
				<xsl:if test="/shop/*[name()=$nodename] = @id">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				<label for="id_property_{../../@id}_{@id}">
					<xsl:value-of disable-output-escaping="yes" select="value"/>
				</label>
			</input>
			</div>
		</xsl:if>
		<xsl:if test="../../filter = 4">
			<!-- Отображаем флажки -->
			<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
			<div>
			<input type="checkbox" value="{@id}" name="property_{../../@id}[]" id="property_{../../@id}_{@id}">
				<xsl:if test="/shop/*[name()=$nodename] = @id">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				<label for="property_{../../@id}_{@id}">
					<xsl:value-of disable-output-escaping="yes" select="value"/>
				</label>
			</input>
			</div>
		</xsl:if>
		<xsl:if test="../../filter = 7">
			<!-- Отображаем список -->
			<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
			<option value="{@id}">
				<xsl:if test="/shop/*[name()=$nodename] = @id">
					<xsl:attribute name="selected">
					</xsl:attribute>
				</xsl:if>
				<xsl:value-of disable-output-escaping="yes" select="value"/>
			</option>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>