<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/site">

		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1" />

			<style type="text/css">
				<xsl:text disable-output-escaping="yes">
					<![CDATA[
						@import url(http://fonts.googleapis.com/css?family=Roboto:600,400,300&subset=latin,cyrillic);
						html { width: 100% }
						body { font-family: 'Roboto',Helvetica,Arial; -webkit-text-size-adjust: none; -ms-text-size-adjust: none; margin: 0; padding: 0 }
						table { border-spacing: 0; border-collapse: collapse }
						table td { border-collapse: collapse }
						img { display: block !important }
						a { text-decoration: none; color: #f55555 }
						b, strong { color: #333 }
						.text_container {color: #8a8a8a; line-height: 18px }
						.text_container strong { color: #333333 }
						@media screen and (min-width: 731px) {
						  .container {width: 700px!important;}
						}
					]]>
				</xsl:text>
			</style>
		</head>

		<body marginwidth="0" marginheight="0" offset="0" topmargin="0" leftmargin="0" style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space; margin-top: 0; margin-bottom: 0; padding-top: 0; padding-bottom: 0; width: 100%; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; background-color: #efeeea">
			<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td align="center" style="padding-left: 15px; padding-right: 15px">
						<table class="container" width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td style="font-size: 1px; line-height: 30px" height="30"> </td>
							</tr>
							<tr>
								<td align="center">
									<!-- Разместите ссылку на логотип с http:// -->
								</td>
							</tr>
							<tr>
								<td style="font-size: 1px; line-height: 30px" height="30"></td>
							</tr>
							<tr>
								<td style="background-color: #ffffff; padding: 20px">
									<table width="100%">
										<xsl:apply-templates select="shop/abandoned_cart_mail_template" />
									</table>
								</td>
							</tr>
							<tr>
								<td align="center" height="2" bgcolor="#f55555">

								</td>
							</tr>
							<tr>
								<td height="20"></td>
							</tr>
							<tr>
								<td>
									<table style="width: 100%;" cellspacing="0" cellpadding="0" border="0">
									<tbody>
									<tr>
										<td width="100%" align="left" class="text_container" style="font-size: 12px">
											<xsl:value-of disable-output-escaping="yes" select="shop/company/name"/>
											<br/>Телефон: <strong><xsl:value-of disable-output-escaping="yes" select="shop/company/directory_phone/value"/></strong>
											<br/>Электронная почта: <a href="mailto:{shop/company/directory_email/value}"><xsl:value-of disable-output-escaping="yes" select="shop/company/directory_email/value"/></a>
											<br/><a href="{shop/company/directory_website/value}"><xsl:value-of disable-output-escaping="yes" select="shop/company/directory_website/value"/></a>
										</td>
									</tr>
									</tbody>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height="25" style="font-size: 25px; line-height: 25px"> </td>
				</tr>
				<!-- </tbody>-->
			</table>
		</body>
		</html>
	</xsl:template>

	<xsl:template match="abandoned_cart_mail_template">
		<tr>
			<td style="padding-bottom:20px; margin: 0px;font-size:20px;line-height:34px;color:#333333" align="center">
				<xsl:variable name="userName">
					<xsl:choose>
						<xsl:when test="/site/siteuser/name !=''">
							<xsl:value-of disable-output-escaping="yes" select="/site/siteuser/name"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of disable-output-escaping="yes" select="/site/siteuser/login"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				Здравствуйте, <xsl:value-of disable-output-escaping="yes" select="$userName"/>
			</td>
		</tr>
		<tr>
			<td style="font-size: 13px; color: #52565C; line-height: 24px" align="left">
				В вашей корзине остались товары. Им грустно, т.к. они не будут зарезервированы на ваше имя и вскоре могут быть проданы другим пользователям.
				<p>
					<xsl:apply-templates select="shop_cart/shop_item" />
					Сумма: <b><xsl:value-of select="format-number(/site/shop/total_amount, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="/site/shop/shop_currency/name"/></b>
				</p>
				<p>
					Пожалуйста, купите их. Перейти в <a href="http://{/site/site_alias/name}/shop/cart/">корзину</a>.
				</p>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="shop_item">
		<b><xsl:value-of select="name"/></b><xsl:text>, </xsl:text>
		<xsl:value-of disable-output-escaping="yes" select="round(../quantity)"/><xsl:text> × </xsl:text>
		<xsl:apply-templates select="/site/shop/shop_currency/code">
			<xsl:with-param name="value" select="price" />
		</xsl:apply-templates>
		<br />
	</xsl:template>

	<xsl:template match="shop_currency/code">
		<xsl:param name="value" />

		<xsl:variable name="spaced" select="format-number($value, '# ###', 'my')" />

		<xsl:choose>
			<xsl:when test=". = 'USD'">$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'EUR'">€<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'GBP'">£<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'RUB'"><xsl:value-of select="$spaced"/> руб.</xsl:when>
			<xsl:when test=". = 'AUD'">AU$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'CNY'"><xsl:value-of select="$spaced"/>元</xsl:when>
			<xsl:when test=". = 'JPY'"><xsl:value-of select="$spaced"/>¥</xsl:when>
			<xsl:when test=". = 'KRW'"><xsl:value-of select="$spaced"/>₩</xsl:when>
			<xsl:when test=". = 'PHP'"><xsl:value-of select="$spaced"/>₱</xsl:when>
			<xsl:when test=". = 'THB'"><xsl:value-of select="$spaced"/>฿</xsl:when>
			<xsl:when test=". = 'BRL'">R$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$spaced"/> <xsl:value-of select="." /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>