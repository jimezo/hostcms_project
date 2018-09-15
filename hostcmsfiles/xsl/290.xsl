<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="no" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/">
		<xsl:apply-templates select="shop"/>
	</xsl:template>

	<!-- Шаблон для списка заказов -->
	<xsl:template match="shop">

		<h1 class="item_title">Мои заказы</h1>

		<!-- Show Error -->
		<xsl:if test="error/node()">
			<div class="alert alert-danger">
				<xsl:value-of select="error"/>
			</div>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="count(shop_order)">
				<xsl:apply-templates select="shop_order"/>

				<xsl:if test="total &gt; 0 and limit &gt; 0">
					<xsl:variable name="count_pages" select="ceiling(total div limit)"/>

					<xsl:variable name="visible_pages" select="5"/>

					<xsl:variable name="real_visible_pages"><xsl:choose>
						<xsl:when test="$count_pages &lt; $visible_pages"><xsl:value-of select="$count_pages"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$visible_pages"/></xsl:otherwise>
					</xsl:choose></xsl:variable>

					<!-- Links before current -->
					<xsl:variable name="pre_count_page"><xsl:choose>
						<xsl:when test="page - (floor($real_visible_pages div 2)) &lt; 0">
							<xsl:value-of select="page"/>
						</xsl:when>
						<xsl:when test="($count_pages - page - 1) &lt; floor($real_visible_pages div 2)">
							<xsl:value-of select="$real_visible_pages - ($count_pages - page - 1) - 1"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="round($real_visible_pages div 2) = $real_visible_pages div 2">
									<xsl:value-of select="floor($real_visible_pages div 2) - 1"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="floor($real_visible_pages div 2)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose></xsl:variable>

					<!-- Links after current -->
					<xsl:variable name="post_count_page"><xsl:choose>
						<xsl:when test="0 &gt; page - (floor($real_visible_pages div 2) - 1)">
							<xsl:value-of select="$real_visible_pages - page - 1"/>
						</xsl:when>
						<xsl:when test="($count_pages - page - 1) &lt; floor($real_visible_pages div 2)">
							<xsl:value-of select="$real_visible_pages - $pre_count_page - 1"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$real_visible_pages - $pre_count_page - 1"/>
						</xsl:otherwise>
					</xsl:choose></xsl:variable>

					<xsl:variable name="i"><xsl:choose>
						<xsl:when test="page + 1 = $count_pages"><xsl:value-of select="page - $real_visible_pages + 1"/></xsl:when>
						<xsl:when test="page - $pre_count_page &gt; 0"><xsl:value-of select="page - $pre_count_page"/></xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose></xsl:variable>

					<p>
						<xsl:call-template name="for">
							<xsl:with-param name="limit" select="limit"/>
							<xsl:with-param name="page" select="page"/>
							<xsl:with-param name="items_count" select="total"/>
							<xsl:with-param name="i" select="$i"/>
							<xsl:with-param name="post_count_page" select="$post_count_page"/>
							<xsl:with-param name="pre_count_page" select="$pre_count_page"/>
							<xsl:with-param name="visible_pages" select="$real_visible_pages"/>
						</xsl:call-template>
					</p>
					<div style="clear: both"></div>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<p id="message">Список заказов пуст.</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Шаблон для заказа -->
	<xsl:template match="shop_order">

		<h2><xsl:text>Заказ №</xsl:text><xsl:choose>
				<xsl:when test="invoice != ''"><xsl:value-of select="invoice"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="@id"/></xsl:otherwise></xsl:choose><xsl:text> от </xsl:text><xsl:value-of select="date"/><xsl:text> г.</xsl:text>
		</h2>

		<!-- Ссылка на бланк оплаты -->
		<xsl:if test="shop_payment_system/name != ''">
			<p id="message">
				<xsl:text>Распечатать бланк «</xsl:text><a href="{/shop/url}cart/print/{guid}/" target="_blank"><xsl:value-of select="shop_payment_system/name" /></a><xsl:text> </xsl:text><img src="/hostcmsfiles/images/new_window.gif"/><xsl:text>».</xsl:text>
			</p>
		</xsl:if>

		<p id="message">
			<xsl:choose>
				<xsl:when test="paid != '0'">
					<span class="paid">Заказ оплачен&#xA0;<xsl:value-of select="payment_datetime"/></span>
				</xsl:when>
				<xsl:when test="canceled != 0">
					<span class="canceled">Заказ отменен.</span>
				</xsl:when>
				<xsl:otherwise>
					<span class="notPaid">Заказ не оплачен.</span>
					<xsl:text> </xsl:text>
					<a href="?action=cancel&amp;guid={guid}" onclick="return confirm('Вы действительно хотите отменить заказ?');">Отменить заказ</a>,
					<xsl:text> </xsl:text><a onclick="$('#change_payment_system{@id}').toggle('slow')">изменить форму оплаты</a>,
				</xsl:otherwise>
			</xsl:choose>

			<xsl:text> </xsl:text><a href="{/shop/url}cart/?action=repeat&amp;guid={guid}" onclick="return confirm('Вы действительно хотите повторить заказ?')">повторить заказ</a>.

			<!-- Блок для смены статуса оплаты -->
			<xsl:if test="paid = 0 and canceled = 0">
				<div class="orderListChangePaymentSystem" id="change_payment_system{@id}">
					<form method="post" class="form-horizontal">
						<div class="form-group">
							<div class="col-sm-6 control-label margin-top-5">
								<select class="form-control" name="shop_payment_system_id">
									<xsl:apply-templates select="/shop/shop_payment_systems/shop_payment_system">
										<xsl:with-param name="shop_payment_system_id" select="shop_payment_system_id"/>
									</xsl:apply-templates>
								</select>
							</div>
							<div class="col-sm-6">
								<input type="hidden" name="shop_order_id" value="{@id}"/>
								<div class="actions">
									<button class="btn btn-primary" type="submit" name="change_payment_system" value="change_payment_system">Изменить форму оплаты</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</xsl:if>
		</p>

		<xsl:if test="shop_order_status/node()">
			<p id="message">
				Статус:&#xA0;<b><xsl:value-of select="shop_order_status/name"/></b><xsl:if test="status_datetime != '0000-00-00 00:00:00'">, <xsl:value-of select="status_datetime"/></xsl:if>.
			</p>
		</xsl:if>

		<p id="message">
			Адрес:&#xA0;<strong><xsl:if test="postcode != ''">
					<xsl:value-of select="postcode"/>, </xsl:if>

				<xsl:if test="shop_country/name != ''">
					<xsl:value-of select="shop_country/name"/>, </xsl:if>

				<xsl:if test="shop_country/shop_country_location/name != ''">
					<xsl:value-of select="shop_country/shop_country_location/name"/>, </xsl:if>

				<xsl:if test="shop_country/shop_country_location/shop_country_location_city/name != ''">г. <xsl:value-of select="shop_country/shop_country_location/shop_country_location_city/name"/>, </xsl:if>

				<xsl:if test="shop_country/shop_country_location/shop_country_location_city/shop_country_location_city_area/name != ''">
					<xsl:value-of select="shop_country/shop_country_location/shop_country_location_city/shop_country_location_city_area/name"/>, </xsl:if>

				<xsl:value-of select="address"/></strong>

			<xsl:if test="phone != ''">
				<br />Телефон:&#xA0;<strong><xsl:value-of select="phone"/></strong>
			</xsl:if>

			<xsl:if test="shop_delivery/node()">
				<br />Доставка:&#xA0;<strong><xsl:value-of select="shop_delivery/name"/></strong>
			</xsl:if>

			<xsl:if test="delivery_information != ''">
				<br />Информация об отправлении:&#xA0;<strong><xsl:value-of select="delivery_information"/></strong>
			</xsl:if>
		</p>

		<!-- Заказанные товары -->
		<table class="table shop_cart">
			<tr>
				<th>Наименование</th>
				<th>Цена</th>
				<th>Количество</th>
				<th></th>
				<th>Стоимость</th>
			</tr>
			<xsl:apply-templates select="shop_order_item"/>
			<tr class="total">
				<td colspan="4" style="text-align: right">
					Итого:
				</td>
				<td style="white-space: nowrap; text-align: right">
					<xsl:value-of select="format-number(amount,'### ##0,00', 'my')"/>&#160;<xsl:value-of select="shop_currency/name" disable-output-escaping="yes"/>
				</td>
			</tr>
		</table>
	</xsl:template>

	<!-- Шаблон для элементов заказа -->
	<xsl:template match="shop_order_item">
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="shop_item/node()">
						<a href="{shop_item/url}">
							<xsl:value-of select="name"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="name"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td align="right" width="90px" style="white-space: nowrap">
				<xsl:value-of select="format-number(price,'### ##0,00', 'my')"/>
				<!-- If show currency -->
				<xsl:if test="../shop_currency/name != ''"><xsl:text> </xsl:text><xsl:value-of select="../shop_currency/name" disable-output-escaping="yes"/></xsl:if>
			</td>
			<td width="60px" style="white-space: nowrap">
				<b>x&#xA0;</b><xsl:text> </xsl:text><xsl:value-of select="quantity"/><xsl:text> </xsl:text><xsl:value-of select="shop_item/shop_measure/name"/></td>
			<td width="15px" align="center">=</td>
			<td width="90px" align="right">
				<xsl:value-of select="format-number(price * quantity,'### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="../shop_currency/name" disable-output-escaping="yes"/>
			</td>
		</tr>
	</xsl:template>

	<!-- Список платежных систем для изменения платежной системы -->
	<xsl:template match="shop_payment_system">
		<xsl:param name="shop_payment_system_id"/>

		<xsl:choose>
			<xsl:when test="$shop_payment_system_id = @id">
				<option value="{@id}" selected="selected"><xsl:value-of select="name"/></option>
			</xsl:when>
			<xsl:otherwise>
				<option value="{@id}"><xsl:value-of select="name"/></option>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Pagination -->
	<xsl:template name="for">
		<xsl:param name="limit"/>
		<xsl:param name="page"/>
		<xsl:param name="pre_count_page"/>
		<xsl:param name="post_count_page"/>
		<xsl:param name="i" select="0"/>
		<xsl:param name="items_count"/>
		<xsl:param name="visible_pages"/>

		<xsl:variable name="n" select="ceiling($items_count div $limit)"/>

		<xsl:variable name="start_page"><xsl:choose>
				<xsl:when test="$page + 1 = $n"><xsl:value-of select="$page - $visible_pages + 1"/></xsl:when>
				<xsl:when test="$page - $pre_count_page &gt; 0"><xsl:value-of select="$page - $pre_count_page"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose></xsl:variable>

		<xsl:if test="$i = $start_page and $page != 0">
			<span class="ctrl">
				← Ctrl
			</span>
		</xsl:if>

		<xsl:if test="$i = ($page + $post_count_page + 1) and $n != ($page+1)">
			<span class="ctrl">
				Ctrl →
			</span>
		</xsl:if>

		<xsl:if test="$items_count &gt; $limit and ($page + $post_count_page + 1) &gt; $i">

			<!-- Set $link variable -->
			<xsl:variable name="number_link"><xsl:if test="$i != 0">page-<xsl:value-of select="$i + 1"/>/</xsl:if></xsl:variable>

			<!-- First pagination item -->
			<xsl:if test="$page - $pre_count_page &gt; 0 and $i = $start_page">
				<a href="{/shop/path}" class="page_link" style="text-decoration: none;">←</a>
			</xsl:if>

			<!-- Pagination item -->
			<xsl:if test="$i != $page">
				<xsl:if test="($page - $pre_count_page) &lt;= $i and $i &lt; $n">
					<!-- Pagination item -->
					<a href="{/shop/path}{$number_link}" class="page_link">
						<xsl:value-of select="$i + 1"/>
					</a>
				</xsl:if>

				<!-- Last pagination item -->
				<xsl:if test="$i+1 &gt;= ($page + $post_count_page + 1) and $n &gt; ($page + 1 + $post_count_page)">
					<!-- Last pagination item -->
					<a href="{/shop/path}page-{$n}/" class="page_link" style="text-decoration: none;">→</a>
				</xsl:if>
			</xsl:if>

			<!-- Ctrl+left link -->
			<xsl:if test="$page != 0 and $i = $page"><xsl:variable name="prev_number_link"><xsl:if test="$page &gt; 1">page-<xsl:value-of select="$i"/>/</xsl:if></xsl:variable><a href="{/shop/path}{$prev_number_link}" id="id_prev"></a></xsl:if>

			<!-- Ctrl+right link -->
			<xsl:if test="($n - 1) > $page and $i = $page">
				<a href="{/shop/path}page-{$page+2}/" id="id_next"></a>
			</xsl:if>

			<!-- Current pagination item -->
			<xsl:if test="$i = $page">
				<span class="current">
					<xsl:value-of select="$i+1"/>
				</span>
			</xsl:if>

			<!-- Recursive Template -->
			<xsl:call-template name="for">
				<xsl:with-param name="i" select="$i + 1"/>
				<xsl:with-param name="limit" select="$limit"/>
				<xsl:with-param name="page" select="$page"/>
				<xsl:with-param name="items_count" select="$items_count"/>
				<xsl:with-param name="pre_count_page" select="$pre_count_page"/>
				<xsl:with-param name="post_count_page" select="$post_count_page"/>
				<xsl:with-param name="visible_pages" select="$visible_pages"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>