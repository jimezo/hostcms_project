<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<!-- Шаблон для корзины -->
	<xsl:template match="/shop">
		<xsl:choose>
			<xsl:when test="count(shop_cart) = 0">
				<h1 class="item_title">В корзине нет ни одного товара.</h1>
				<p><xsl:choose>
						<!-- Пользователь авторизован или модуль пользователей сайта отсутствует -->
					<xsl:when test="siteuser_id > 0 or siteuser_id = 0"><p id="message">Для оформления заказа добавьте товар в корзину.</p></xsl:when>
					<xsl:otherwise><p id="message">Вы не авторизированы. Если Вы зарегистрированный пользователь, данные Вашей корзины станут видны после авторизации.</p></xsl:otherwise>
				</xsl:choose></p>
			</xsl:when>
			<xsl:otherwise>
				<h1 class="item_title">Моя корзина</h1>

				<p id="message">Для оформления заказа, нажмите «Оформить заказ».</p>

				<form action="{/shop/url}cart/" method="post" class="form-horizontal">
					<!-- Если есть товары -->
					<xsl:if test="count(shop_cart[postpone = 0]) > 0">
						<xsl:call-template name="tableHeader"/>
						<xsl:apply-templates select="shop_cart[postpone = 0]"/>
						<xsl:call-template name="tableFooter">
							<xsl:with-param name="nodes" select="shop_cart[postpone = 0]"/>
						</xsl:call-template>

						<!-- Скидки -->
						<xsl:if test="count(shop_purchase_discount)">
							<xsl:apply-templates select="shop_purchase_discount"/>
							<div class="row table-cart">
								<div class="col-xs-2">Всего:</div>
								<div class="col-xs-2 col-sm-1"></div>
								<div class="col-xs-2"></div>
								<div class="col-xs-2">
									<xsl:value-of select="format-number(total_amount, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="/shop/shop_currency/name"/>
								</div>
								<div class="col-xs-2"></div>
								<xsl:if test="count(/shop/shop_warehouse)">
									<div class="col-xs-2"></div>
								</xsl:if>
								<div class="hidden-xs col-sm-1"></div>
								<div class="col-xs-2"></div>
							</div>
						</xsl:if>
					</xsl:if>

					<!-- Купон -->

					<div class="form-group margin-top-20 margin-bottom-5">
						<label for="" class="col-xs-3 col-md-1 control-label">Купон:</label>
						<div class="col-xs-9 col-md-5">
							<input class="form-control" type="text" name="coupon_text" size="50" value="{coupon_text}"/>
						</div>
					</div>

					<!-- Если есть отложенные товары -->
					<xsl:if test="count(shop_cart[postpone = 1]) > 0">
						<div class="transparent">
							<h1 class="item_title">Отложенные товары</h1>
							<xsl:call-template name="tableHeader"/>
							<xsl:apply-templates select="shop_cart[postpone = 1]"/>
							<xsl:call-template name="tableFooter">
								<xsl:with-param name="nodes" select="shop_cart[postpone = 1]"/>
							</xsl:call-template>
						</div>
					</xsl:if>

					<div class="row">
						<label for="" class="hidden-xs col-md-1 control-label"></label>
						<div class="col-xs-12 col-md-11">
							<div class="actions">
								<button class="btn btn-secondary" type="submit" name="recount" value="recount">Пересчитать</button>

								<xsl:if test="count(shop_cart[postpone = 0]) and (siteuser_id > 0 or siteuser_exists = 0)">
									<input name="step" value="1" type="hidden" />
									<button class="btn btn-primary" type="submit" name="submit" value="submit">Оформить заказ</button>
								</xsl:if>
							</div>
						</div>


						<!-- Кнопки -->
						<!-- Пользователь авторизован или модуль пользователей сайта отсутствует -->
						<!-- <xsl:if test="count(shop_cart[postpone = 0]) and (siteuser_id > 0 or siteuser_exists = 0)">
							<input name="step" value="1" type="hidden" />

							<div class="col-xs-6">
								<div class="actions">
									<button class="btn btn-primary" type="submit" name="submit" value="submit">Оформить заказ</button>
								</div>
							</div>
						</xsl:if>-->
					</div>
				</form>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Заголовок таблицы -->
	<xsl:template name="tableHeader">
		<div class="row header-cart">
			<div class="col-xs-3 col-sm-2">Товар</div>
			<div class="col-xs-3 col-sm-1">Кол-во</div>
			<div class="col-xs-4 col-sm-2">Цена</div>
			<div class="hidden-xs col-sm-2">Сумма</div>
			<xsl:if test="count(/shop/shop_warehouse)">
				<div class="hidden-xs col-sm-2">Склад</div>
			</xsl:if>
			<div class="hidden-xs col-sm-1">Отложить</div>
			<div class="hidden-xs col-sm-2">Действия</div>
		</div>
	</xsl:template>

	<!-- Итоговая строка таблицы -->
	<xsl:template name="tableFooter">
		<xsl:param name="nodes"/>

		<div class="row table-cart">
			<div class="col-xs-3 col-sm-2">Итого:</div>
			<div class="col-xs-3 col-sm-1"><xsl:value-of select="sum($nodes/quantity)"/></div>
			<div class="hidden-xs col-sm-2"><xsl:text> </xsl:text></div>
			<div class="col-xs-4 col-sm-2">
				<xsl:variable name="subTotals">
					<xsl:for-each select="$nodes">
						<sum><xsl:value-of select="shop_item/price * quantity"/></sum>
					</xsl:for-each>
				</xsl:variable>

				<xsl:value-of select="format-number(sum(exsl:node-set($subTotals)/sum), '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="/shop/shop_currency/name"/>
			</div>
			<xsl:if test="count(/shop/shop_warehouse)">
			<div class="hidden-xs col-sm-2"><xsl:text> </xsl:text></div>
			</xsl:if>
			<div class="hidden-xs col-sm-1"><xsl:text> </xsl:text></div>
			<div class="col-xs-2"><xsl:text> </xsl:text></div>
		</div>
	</xsl:template>

	<!-- Шаблон для товара в корзине -->
	<xsl:template match="shop_cart">
		<div class="row table-cart">
			<div class="col-xs-3 col-sm-2">
				<a href="{shop_item/url}">
					<xsl:value-of disable-output-escaping="yes" select="shop_item/name"/>
				</a>
			</div>
			<div class="col-xs-3 col-sm-1">
				<input class="form-control" type="text" size="3" name="quantity_{shop_item/@id}" id="quantity_{shop_item/@id}" value="{quantity}"/>
			</div>
			<div class="col-xs-4 col-sm-2">
				<!-- Цена -->
				<xsl:value-of select="format-number(shop_item/price, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="shop_item/currency" disable-output-escaping="yes"/>
			</div>
			<div class="hidden-xs col-sm-2">
				<!-- Сумма -->
				<xsl:value-of disable-output-escaping="yes" select="format-number(shop_item/price * quantity, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="shop_item/currency"/>
			</div>
			<xsl:if test="count(/shop/shop_warehouse)">
				<div class="hidden-xs col-sm-2 ">
					<xsl:choose>
						<xsl:when test="sum(shop_item/shop_warehouse_item/count) > 0">
							<select class="form-control" name="warehouse_{shop_item/@id}">
								<xsl:apply-templates select="shop_item/shop_warehouse_item"/>
							</select>
						</xsl:when>
						<xsl:otherwise>—</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:if>
			<div class="hidden-xs col-sm-1">
				<!-- Отложить -->
				<input type="checkbox" name="postpone_{shop_item/@id}">
					<xsl:if test="postpone = 1">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
			</div>
		<div class="col-xs-1 col-sm-2"><a href="?delete={shop_item/@id}" onclick="return confirm('Вы уверены, что хотите удалить?')" title="Удалить товар из корзины" alt="Удалить товар из корзины">Удалить</a></div>
		</div>
	</xsl:template>

	<!-- Шаблон для скидки от суммы заказа -->
	<xsl:template match="shop_purchase_discount">
		<div class="row table-cart">
			<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
				<xsl:value-of select="name"/>
			</div>
			<div class="col-xs-2 col-sm-1 col-md-1 col-lg-1"></div>
			<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2"></div>
			<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
				<!-- Сумма -->
				<xsl:value-of select="format-number(discount_amount * -1, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_currency/name" disable-output-escaping="yes"/>
			</div>
			<xsl:if test="count(/shop/shop_warehouse)">
				<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2"></div>
			</xsl:if>
			<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2"></div>
			<div class="hidden-xs col-sm-1 col-md-1 col-lg-1"></div>
		</div>
	</xsl:template>

	<!-- option для склада -->
	<xsl:template match="shop_warehouse_item">
		<xsl:if test="count != 0">
			<xsl:variable name="shop_warehouse_id" select="shop_warehouse_id" />
			<option value="{$shop_warehouse_id}">
				<xsl:if test="../../shop_warehouse_id = $shop_warehouse_id">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="/shop/shop_warehouse[@id=$shop_warehouse_id]/name"/> (<xsl:value-of select="count - reserved"/>)
			</option>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>