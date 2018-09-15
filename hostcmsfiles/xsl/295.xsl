<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- МагазинКорзинаКраткая -->

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/shop">
		<div class="mt-cart">
			<div class="little-cart-info">
				<div class="cart-ico">
					<i class="fa fa-shopping-cart"></i>
				</div>
				<xsl:choose>
					<!-- В корзине нет ни одного элемента -->
					<xsl:when test="count(shop_cart) = 0">
						<div class="empty-cart">
							<div>0 товаров — 0 руб.</div>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<div class="full-cart">
							<div>
								<xsl:variable name="totalQuantity" select="sum(shop_cart[postpone = 0]/quantity)" />

								<!-- Вывод общих количества, веса и стоимости товаров -->
								<xsl:value-of select="$totalQuantity"/>

							<xsl:text> </xsl:text><xsl:call-template name="declension"><xsl:with-param name="number" select="$totalQuantity"/></xsl:call-template>
							<xsl:text> — </xsl:text><xsl:value-of select="format-number(total_amount, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="shop_currency/name"/>
							</div>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</div>

			<div class="more-cart-info">
				<xsl:choose>
					<!-- В корзине нет ни одного элемента -->
					<xsl:when test="count(shop_cart[postpone = 0]) = 0">
						<div class="cart-item-list-empty">В корзине нет ни одного товара</div>
					</xsl:when>
					<xsl:otherwise>
						<div class="cart-item-list">
							<xsl:apply-templates select="shop_cart[postpone = 0]/shop_item" />
						</div>

				<div class="cart-link"><a href="/shop/cart/">В корзину</a><i class="fa fa-long-arrow-right"></i></div>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="shop_item">
		<div class="cart-item">
			<a class="cart-item-image" title="{name}" href="{url}">
				<xsl:choose>
					<xsl:when test="image_small != ''">
						<img alt="{name}" src="{dir}{image_small}" />
					</xsl:when>
					<!-- Картинка родительского товара -->
					<xsl:when test="modification_id and shop_item/image_small != ''">
						<img alt="{name}" src="{shop_item/dir}{shop_item/image_small}" />
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</a>
			<div class="cart-item-details">
				<div class="cart-item-name">
					<a href="{url}"><xsl:value-of select="name"/></a>
				</div>
				<div class="cart-price">
					<xsl:value-of select="price"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="/shop/shop_currency/name"/>
				</div>
			</div>
		</div>
	</xsl:template>

	<!-- Declension of the numerals -->
	<xsl:template name="declension">

		<xsl:param name="number" select="number"/>

		<!-- Nominative case / Именительный падеж -->
		<xsl:variable name="nominative">
			<xsl:text>товар</xsl:text>
		</xsl:variable>

		<!-- Genitive singular / Родительный падеж, единственное число -->
		<xsl:variable name="genitive_singular">
			<xsl:text>товара</xsl:text>
		</xsl:variable>


		<xsl:variable name="genitive_plural">
			<xsl:text>товаров</xsl:text>
		</xsl:variable>

		<xsl:variable name="last_digit">
			<xsl:value-of select="$number mod 10"/>
		</xsl:variable>

		<xsl:variable name="last_two_digits">
			<xsl:value-of select="$number mod 100"/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$last_digit = 1 and $last_two_digits != 11">
				<xsl:value-of select="$nominative"/>
			</xsl:when>
			<xsl:when test="$last_digit = 2 and $last_two_digits != 12     or     $last_digit = 3 and $last_two_digits != 13     or     $last_digit = 4 and $last_two_digits != 14">
				<xsl:value-of select="$genitive_singular"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$genitive_plural"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>