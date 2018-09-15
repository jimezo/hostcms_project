<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- МагазинПлатежнаяСистема -->
	<xsl:template match="/shop">


		<div class="row">
			<div class="col-lg-12 col-sm-12 col-xs-12">
				<div id="WiredWizard" class="wizard wizard-wired" data-target="#WiredWizardsteps">
					<ul class="steps">
						<li data-target="#wiredstep1" class="complete"><span class="step">1</span><span class="title">Адрес доставки</span><span class="chevron"></span></li>
						<li data-target="#wiredstep2" class="complete"><span class="step">2</span><span class="title">Способ доставки</span> <span class="chevron"></span></li>
						<li data-target="#wiredstep3" class="active"><span class="step">3</span><span class="title">Форма оплаты</span> <span class="chevron"></span></li>
						<li data-target="#wiredstep4"><span class="step">4</span><span class="title">Данные доставки</span> <span class="chevron"></span></li>
					</ul>
				</div>
			</div>
		</div>

		<h1 class="item_title">Выбор формы оплаты</h1>

		<form method="post" class="form-horizontal">
			<xsl:choose>
				<xsl:when test="count(shop_payment_system) = 0">
					<p><b>В данный момент нет доступных платежных систем!</b></p>
					<p>Оформление заказа невозможно, свяжитесь с администрацией Интернет-магазина.</p>
				</xsl:when>
				<xsl:otherwise>
					<table class="table shop_cart">
						<tr class="total">
							<th>Форма оплаты</th>
							<th>Описание</th>
						</tr>
						<xsl:apply-templates select="shop_payment_system"/>
					</table>

					<div class="form-group">
						<input name="step" value="4" type="hidden" />

						<div class="col-lg-12 col-sm-12 col-xs-12">
							<!-- Частичная оплата с лицевого счета -->
							<xsl:if test="siteuser/transaction_amount/node() and siteuser/transaction_amount &gt; 0">
							<p>
								<label><input type="checkbox" name="partial_payment_by_personal_account" /> Частично оплатить с лицевого счета, на счету <strong><xsl:value-of select="siteuser/transaction_amount" /><xsl:text> </xsl:text><xsl:value-of select="shop_currency/name" /></strong></label>
							</p>
							</xsl:if>
						</div>

						<div class="col-sm-3">
							<div class="actions">
								<button class="btn btn-primary" type="submit" name="submit" value="submit">Далее</button>
							</div>
						</div>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</form>
	</xsl:template>

	<xsl:template match="shop_payment_system">
		<tr>
			<td width="40%">
				<label>
				<input type="radio" name="shop_payment_system_id" value="{@id}">
					<xsl:if test="position() = 1">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<xsl:text> </xsl:text><span class="caption"><xsl:value-of select="name"/></span>
				</label>
			</td>
			<td width="60%">
				<xsl:value-of disable-output-escaping="yes" select="description"/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>