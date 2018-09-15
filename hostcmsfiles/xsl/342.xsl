<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- МагазинКаталогТоваровНаГлавнойСпецПред -->

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/">
		<xsl:apply-templates select="/shop"/>
	</xsl:template>

	<xsl:template match="/shop">
		<!-- Есть товары -->
		<xsl:if test="shop_item">
			<h1>Новинки</h1>

			<div class="row products-grid">
				<!-- Выводим товары магазина -->
				<xsl:apply-templates select="shop_item" />

				<a id="compareButton" class="btn btn-primary margin-left-20" href="{/shop/url}compare_items/">
					<xsl:if test="count(/shop/comparing/shop_item) = 0">
						<xsl:attribute name="style">display: none</xsl:attribute>
					</xsl:if>
					Сравнить товары
				</a>
			</div>
		</xsl:if>
	</xsl:template>

	<!-- Шаблон для товара -->
	<xsl:template match="shop_item">
		<div class="col-xs-12 col-sm-12 col-md-6 col-lg-4 item">
			<div class="grid_wrap match-height">
				<div class="product-image">
					<a href="{url}" title="{name}">
						<xsl:choose>
							<xsl:when test="image_small != ''">
								<img src="{dir}{image_small}" alt="{name}" class="img-responsive"/>
							</xsl:when>
							<xsl:otherwise>
								<img src="/images/default-image.png"/>
							</xsl:otherwise>
						</xsl:choose>
					</a>

					<xsl:if test="discount != 0">
						<span class="product-label">
							<span class="label-sale">
								<span class="sale-text">-<xsl:value-of disable-output-escaping="yes" select="round(shop_discount/percent)"/>%</span>
							</span>
						</span>
					</xsl:if>

					<xsl:variable name="shop_item_id" select="@id" />
					<div class="product-buttons">
						<div class="product-wishlist">
							<span onclick="return $.addFavorite('{/shop/url}', {@id}, this)">
								<xsl:if test="/shop/favorite/shop_item[@id = $shop_item_id]/node()">
									<xsl:attribute name="class">favorite-current</xsl:attribute>
								</xsl:if>
								<i class="fa fa-heart-o"></i>
							</span>
						</div>
						<div class="product-compare">
							<span onclick="return $.addCompare('{/shop/url}', {@id}, this)">
								<xsl:if test="/shop/comparing/shop_item[@id = $shop_item_id]/node()">
									<xsl:attribute name="class">compare-current</xsl:attribute>
								</xsl:if>
								<i class="fa fa-bar-chart"></i>
							</span>
						</div>
					</div>
				</div>

				<div class="product-content">
					<div class="product-content-inner">
						<h5 class="product-name">
							<a href="{url}" title="{name}">
								<xsl:value-of select="name"/>
							</a>
						</h5>

						<div class="price-box">
							<span id="product-price-12-new" class="regular-price">
								<span class="price">
									<xsl:apply-templates select="/shop/shop_currency/code">
										<xsl:with-param name="value" select="price" />
									</xsl:apply-templates>
								</span>
								<xsl:if test="discount != 0">
									<span class="old-price">
										<xsl:apply-templates select="/shop/shop_currency/code">
											<xsl:with-param name="value" select="price + discount" />
										</xsl:apply-templates>
									</span>
								</xsl:if>
							</span>

							<!-- <xsl:if test="count(shop_bonuses/shop_bonus)">
								<div class="product-bonuses">
									+<xsl:value-of select="shop_bonuses/total" /> бонусов
								</div>
							</xsl:if>-->

							<div class="product-action-buttons">
								<div class="shop-item-add-to-cart">
								<a class="shop-item-add-to-cart-link" href="#" onclick="return $.bootstrapAddIntoCart('{/shop/url}cart/', {@id}, 1)" title="Add to Cart"><i class="fa fa-shopping-basket "></i></a>
								</div>
								<div class="shop-item-fast-order">
								<a class="shop-item-fast-order-link" href="#" onclick="return $.oneStepCheckout('{/shop/url}cart/', {@id}, 1)" title="Fast Order" data-toggle="modal" data-target="#oneStepCheckout{@id}"><i class="fa fa-shopping-cart"></i></a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="shop_currency/code">
		<xsl:param name="value" />

		<xsl:variable name="spaced" select="format-number($value, '# ###', 'my')" />

		<xsl:choose>
			<xsl:when test=". = 'USD'">$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'EUR'">€<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'GBP'">£<xsl:value-of select="$spaced"/></xsl:when>
		<xsl:when test=". = 'RUB'"><xsl:value-of select="$spaced"/><i class="fa fa-ruble"></i></xsl:when>
			<xsl:when test=". = 'AUD'">AU$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'CNY'"><xsl:value-of select="$spaced"/>元</xsl:when>
			<xsl:when test=". = 'JPY'"><xsl:value-of select="$spaced"/>¥</xsl:when>
			<xsl:when test=". = 'KRW'"><xsl:value-of select="$spaced"/>₩</xsl:when>
			<xsl:when test=". = 'PHP'"><xsl:value-of select="$spaced"/>₱</xsl:when>
			<xsl:when test=". = 'THB'"><xsl:value-of select="$spaced"/>฿</xsl:when>
			<xsl:when test=". = 'BRL'">R$<xsl:value-of select="$spaced"/></xsl:when>
		<xsl:when test=". = 'INR'"><xsl:value-of select="$spaced"/><i class="fa fa-inr"></i></xsl:when>
		<xsl:when test=". = 'TRY'"><xsl:value-of select="$spaced"/><i class="fa fa-try"></i></xsl:when>
		<xsl:when test=". = 'ILS'"><xsl:value-of select="$spaced"/><i class="fa fa-ils"></i></xsl:when>
			<xsl:otherwise><xsl:value-of select="$spaced"/> <xsl:value-of select="." /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>