<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>
	
	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>
	
	<!-- Шаблон для типов доставки -->
	<xsl:template match="/shop">
		
		
		<div class="row">
			<div class="col-lg-12 col-sm-12 col-xs-12">
				<div id="WiredWizard" class="wizard wizard-wired" data-target="#WiredWizardsteps">
					<ul class="steps">
			<li data-target="#wiredstep1" class="complete"><span class="step">1</span><span class="title">Адрес доставки</span><span class="chevron"></span></li>
			<li data-target="#wiredstep2" class="active"><span class="step">2</span><span class="title">Способ доставки</span> <span class="chevron"></span></li>
			<li data-target="#wiredstep3"><span class="step">3</span><span class="title">Форма оплаты</span> <span class="chevron"></span></li>
			<li data-target="#wiredstep4"><span class="step">4</span><span class="title">Данные доставки</span> <span class="chevron"></span></li>
					</ul>
				</div>
			</div>
		</div>
		
		<h1 class="item_title">Способ доставки</h1>
		
		<form method="post" class="form-horizontal">
			<!-- Проверяем количество способов доставки -->
			<xsl:choose>
				<xsl:when test="count(shop_delivery) = 0">
					<p>По выбранным Вами условиям доставка не возможна, заказ будет оформлен без доставки.</p>
					<p>Уточнить данные о доставке Вы можете, связавшись с представителем нашей компании.</p>
					<input type="hidden" name="shop_delivery_condition_id" value="0"/>
				</xsl:when>
				<xsl:otherwise>
					<table class="table shop_cart">
						<tr class="total">
							<th width="20%">Способ доставки</th>
							<th class="hidden-xs">Описание</th>
							<th width="15%">Цена доставки</th>
							<th width="15%" class="hidden-xs">Стоимость товаров</th>
							<th width="15%">Итого</th>
						</tr>
						<xsl:apply-templates select="shop_delivery"/>
					</table>
				</xsl:otherwise>
			</xsl:choose>
			
			<div class="form-group">
				<input name="step" value="3" type="hidden" />
				
				<!-- <label for="" class="col-sm-1 control-label"></label>-->
				<div class="col-sm-3">
					<div class="actions">
						<button class="btn btn-primary" type="submit" name="submit" value="submit">Далее</button>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	
	<xsl:template match="shop_delivery">
		<tr>
			<td>
				<label>
					<input type="radio" value="{shop_delivery_condition/@id}" name="shop_delivery_condition_id">
						<xsl:if test="position() = 1">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
			</input><xsl:text> </xsl:text><span class="caption"><xsl:value-of select="name"/></span>
				</label>
			</td>
			<td class="hidden-xs">
				<!--<xsl:value-of disable-output-escaping="yes" select="description"/>-->
				<xsl:choose>
					<xsl:when test="normalize-space(shop_delivery_condition/description) !=''">
						<xsl:value-of disable-output-escaping="yes" select="concat(description,' (',shop_delivery_condition/description,')')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="description"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
			<xsl:value-of select="format-number(shop_delivery_condition/price, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_currency/name"/></td>
			<td class="hidden-xs">
				<xsl:value-of select="format-number(/shop/total_amount, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_currency/name"/>
			</td>
			<td class="total">
				<xsl:value-of select="format-number(/shop/total_amount + shop_delivery_condition/price, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_currency/name"/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>