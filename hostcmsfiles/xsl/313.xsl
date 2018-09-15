<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/shop">
		<div class="row">
			<xsl:apply-templates select="shop_item"/>
		</div>
	</xsl:template>

	<xsl:template match="shop_item">
		<!-- Store parent id in a variable -->
		<xsl:variable name="group" select="/shop/group"/>

		<!-- Breadcrumbs -->
		<div class="breadcrumbs" xmlns:v="http://rdf.data-vocabulary.org/#">

			<xsl:if test="$group = 0">
				<span typeof="v:Breadcrumb">
					<a title="{/shop/name}" href="{/shop/url}" hostcms:id="{/shop/@id}" hostcms:field="name" hostcms:entity="shop" property="v:title" rel="v:url">
						<xsl:value-of select="/shop/name"/>
					</a>
				</span>
			</xsl:if>

			<xsl:apply-templates select="/shop//shop_group[@id=$group]" mode="breadCrumbs"/>

			<!-- Если модификация, выводим в пути родительский товар -->
			<xsl:if test="shop_item/node()">
				<i class="fa fa-angle-right"></i>

				<span typeof="v:Breadcrumb">
					<a title="{shop_item/name}" href="{shop_item/url}" property="v:title" rel="v:url">
						<xsl:value-of disable-output-escaping="yes" select="shop_item/name"/>
					</a>
				</span>
			</xsl:if>

			<i class="fa fa-angle-right"></i>

			<span typeof="v:Breadcrumb">
				<a title="{name}" href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item" property="v:title" rel="v:url"><xsl:value-of select="name"/></a>
			</span>
		</div>

		<h1 class="item_title" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item"><xsl:value-of select="name"/></h1>

		<div class="col-xs-6 col-sm-6 col-md-5 col-lg-5">
			<!-- Изображение для товара, если есть -->
			<xsl:choose>
				<xsl:when test="image_small != ''">
					<img id="zoom" src="{dir}{image_small}" data-zoom-image="{dir}{image_large}"/>

					<div id="gallery">
						<a href="#" data-image="{dir}{image_small}" data-zoom-image="{dir}{image_large}">
							<img id="zoom" src="{dir}{image_small}" height="100" />
						</a>

						<xsl:for-each select="property_value[tag_name='img'][file !='']">
							<a href="#" data-image="{../dir}{file_small}" data-zoom-image="{../dir}{file}">
								<img id="zoom" src="{../dir}{file_small}" height="100" />
							</a>
						</xsl:for-each>
					</div>
				</xsl:when>
				<xsl:otherwise><img class="news_img" src="/images/no_image.png" /></xsl:otherwise>
			</xsl:choose>
		</div>

		<!-- Информация об ошибках -->
		<xsl:variable name="error_code" select="/shop/error"/>

		<div class="col-xs-6 col-sm-6 col-md-7 col-lg-7">
			<!-- Цена товара -->
			<xsl:if test="price != 0">
				<div class="item-price">
				<xsl:value-of select="format-number(price, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="currency"/><xsl:text> </xsl:text>

					<!-- Если цена со скидкой - выводим ее -->
					<xsl:if test="discount != 0">
						<span class="item-old-price">
							<xsl:value-of select="format-number(price + discount, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="currency" />
					</span><xsl:text> </xsl:text>
					</xsl:if>
				</div>
			</xsl:if>

			<div class="row">
				<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="shop_property">
						<xsl:for-each select="/shop/shop_item_properties//property[type!=2][type!=5][type!=10]">
							<xsl:sort select="sorting" />
							<div class="caption">
								<xsl:value-of select="name" />:
								<xsl:if test="shop_measure/node()">(<xsl:value-of select="shop_measure/name" />)</xsl:if>
							</div>
							<div class="field">
								<xsl:variable name="property_id" select="@id" />
								<xsl:variable name="property_value" select="//shop_item/property_value[property_id = $property_id]/value" />

								<xsl:choose>
									<xsl:when test="type = 7">
										<xsl:choose>
											<xsl:when test="$property_value = 1">Есть</xsl:when>
											<xsl:otherwise>Нет</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of disable-output-escaping="no" select="$property_value" />
									</xsl:otherwise>
								</xsl:choose>
							</div>
						</xsl:for-each>
					</div>
				</div>
			</div>

			<hr/>

			<!-- <div class="row">
				<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<a class="item-wishlist" onclick="return $.addFavorite('{/shop/url}', {@id}, this)"><i class="fa fa-heart-o"></i>Избранное</a>
				<a class="item-compare" onclick="return $.addCompare('{/shop/url}', {@id}, this)"><i class="fa fa-bar-chart"></i>Сравнить</a>
				</div>
			</div>

			<hr/>-->

			<div class="shop_property item-float-left">
				<div>
					<i class="fa fa-eye"></i>
				</div>
				<xsl:value-of disable-output-escaping="yes" select="showed"/>
			</div>

			<xsl:if test="siteuser_id != 0">
				<div class="shop_property item-float-left">
					<div>
						<i class="fa fa-user"></i>
					</div>
					<a href="/users/info/{siteuser/login}/"><xsl:value-of select="siteuser/login"/></a>
				</div>
			</xsl:if>

			<div class="shop_property item-float-left">
				<div>
					<i class="fa fa-calendar"></i>
				</div>
				<xsl:value-of disable-output-escaping="yes" select="date"/><xsl:text> г.</xsl:text>
			</div>

			<div class="shop_property item-float-left">
				<xsl:if test="rate/node()">
					<span id="shop_item_id_{@id}" class="thumbs">
						<xsl:choose>
							<xsl:when test="/shop/siteuser_id > 0">
								<xsl:choose>
									<xsl:when test="vote/value = 1">
										<xsl:attribute name="class">thumbs up</xsl:attribute>
									</xsl:when>
									<xsl:when test="vote/value = -1">
										<xsl:attribute name="class">thumbs down</xsl:attribute>
									</xsl:when>
								</xsl:choose>
								<span id="shop_item_likes_{@id}"><xsl:value-of select="rate/@likes" /></span>
								<span class="inner_thumbs">
								<a onclick="return $.sendVote({@id}, 1, 'shop_item')" href="{/shop/url}?id={@id}&amp;vote=1&amp;entity_type=shop_item" alt="Нравится"><i class="fa fa-thumbs-o-up"></i></a>
									<span class="rate" id="shop_item_rate_{@id}"><xsl:value-of select="rate" /></span>
								<a onclick="return $.sendVote({@id}, 0, 'shop_item')" href="{/shop/url}?id={@id}&amp;vote=0&amp;entity_type=shop_item" alt="Не нравится"><i class="fa fa-thumbs-o-down"></i></a>
								</span>
								<span id="shop_item_dislikes_{@id}"><xsl:value-of select="rate/@dislikes" /></span>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">thumbs inactive</xsl:attribute>
								<span id="shop_item_likes_{@id}"><xsl:value-of select="rate/@likes" /></span>
								<span class="inner_thumbs">
								<a alt="Нравится"><i class="fa fa-thumbs-o-up"></i></a>
									<span class="rate" id="shop_item_rate_{@id}"><xsl:value-of select="rate" /></span>
								<a alt="Не нравится"><i class="fa fa-thumbs-o-down"></i></a>
								</span>
								<span id="shop_item_dislikes_{@id}"><xsl:value-of select="rate/@dislikes" /></span>
							</xsl:otherwise>
						</xsl:choose>
					</span>
				</xsl:if>
			</div>

			<div class="rating">
				<!-- Average Grade -->
				<xsl:if test="comments_average_grade/node() and comments_average_grade != 0">
					<span><xsl:call-template name="show_average_grade">
							<xsl:with-param name="grade" select="comments_average_grade"/>
						<xsl:with-param name="const_grade" select="5"/></xsl:call-template></span>
				</xsl:if>
				<xsl:if test="comments_average_grade/node() and comments_average_grade = 0">
					<div style="clear:both"></div>
				</xsl:if>
			</div>

			<hr/>

		</div>

		<div class="row">
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<!-- Текст товара -->
				<xsl:if test="text != ''">
					<div class="item-text" hostcms:id="{@id}" hostcms:field="text" hostcms:entity="shop_item" hostcms:type="wysiwyg"><xsl:value-of disable-output-escaping="yes" select="text"/></div>
				</xsl:if>
			</div>
		</div>

		<div style="margin-top: 10px;">
			<!-- Выводим список дополнительных свойств -->
			<table border="0">
				<xsl:apply-templates select="property[type!=1]"/>
			</table>
		</div>
	</xsl:template>

	<!-- Шаблон изображений из дополнительных свойств -->
	<!-- <xsl:template match="property_value" mode="property_image">
		<div>
			<xsl:choose>
				<xsl:when test="file/node()">
					<a href="{../dir}{file}"><img src="{../dir}{file_small}" /></a>
				</xsl:when>
				<xsl:otherwise>
					<img src="{../dir}{file_small}" />
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>-->

	<!-- Шаблон для скидки -->
	<xsl:template match="discount">
		<br/>
	<xsl:value-of select="name"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="value"/>%</xsl:template>

	<!-- Шаблон вывода дополнительных свойств не являющихся файлами -->
	<xsl:template match="property">
		<!-- Не отображаем дату добавления объявления, идентификатор автора и e-mail -->
		<xsl:if test="@id!=61 and @id!=6 and  value != ''">

			<xsl:choose>
				<!-- Тип свойства - флажок -->
				<xsl:when test="type=7">
					<xsl:if test="value!=0">
						<tr>
							<td class="shop_block" style="border: none;">
								<center>
									<img src="/images/check.gif"/>
								</center>
							</td>
							<td style="padding: 5px;">
								<strong>
									<xsl:value-of select="name"/>
								</strong>
							</td>
						</tr>
					</xsl:if>
					<!--
					<xsl:text> </xsl:text><xsl:choose>
						<xsl:when test="value=0">Нет</xsl:when>
						<xsl:otherwise>Да</xsl:otherwise>
					</xsl:choose>
					-->
				</xsl:when>
				<xsl:when test="@id=213">
					<tr>
						<td class="shop_block" style="border: none;">
							<xsl:value-of select="name"/>:</td>
						<td style="padding: 5px;">
							<strong>
								<a href="/users/info/{/shop/autor_login}/">
									<xsl:value-of select="/shop/autor_login"/>
								</a>
							</strong>
						</td>
					</tr>

				</xsl:when>
				<!-- Остальные типы доп. свойств -->
				<xsl:otherwise>
					<tr>
						<td class="shop_block" style="border: none;">
							<xsl:value-of select="name"/>:</td>
						<td style="padding: 5px;">
							<strong>
								<xsl:value-of disable-output-escaping="yes" select="value"/>
							</strong>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tying/shop_item">

		<div style="clear: both">
			<p>
				<a href="/shop/{url}">
					<xsl:value-of select="name"/>
				</a>
			</p>

			<!-- Изображение для товара, если есть -->
			<xsl:if test="image_small != ''">
				<a href="{url}">
					<img src="{dir}{image_small}" align="left" style="border: 1px solid #000000; margin: 0px 5px 5px 0px"/>
				</a>
			</xsl:if>

			<div>
				<xsl:value-of disable-output-escaping="yes" select="description"/>
			</div>

			<!-- Если указан вес товара -->
			<xsl:if test="weight != 0">
				<br/>Вес товара: <xsl:value-of select="weight"/> <xsl:value-of select="/shop/shop_measure/name"/></xsl:if>

			<!-- Показываем скидки -->
			<xsl:if test="count(discount) &gt; 0">
				<xsl:apply-templates select="discount"/>
			</xsl:if>

			<!-- Показываем количество на складе, если больше нуля -->
			<xsl:if test="rest &gt; 0">
				<br/>В наличии: <xsl:value-of select="rest"/></xsl:if>

			<xsl:if test="shop_producer/name != ''">
				<br/>Производитель: <xsl:value-of select="shop_producer/name"/></xsl:if>
		</div>
	</xsl:template>

	<!-- Шаблон выводит рекурсивно ссылки на группы магазина -->
	<xsl:template match="shop_group" mode="breadCrumbs">
		<xsl:param name="parent_id" select="parent_id"/>

		<!-- Store parent id in a variable -->
		<xsl:param name="group" select="/shop/shop_group"/>

		<xsl:apply-templates select="//shop_group[@id=$parent_id]" mode="breadCrumbs"/>

		<xsl:if test="parent_id=0">
			<span typeof="v:Breadcrumb">
				<a title="{/shop/name}" href="{/shop/url}" hostcms:id="{/shop/@id}" hostcms:field="name" hostcms:entity="shop" class="root" property="v:title" rel="v:url">
					<xsl:value-of select="/shop/name"/>
				</a>
			</span>
		</xsl:if>

		<i class="fa fa-angle-right"></i>

		<span typeof="v:Breadcrumb">
			<a title="{name}" href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_group" property="v:title" rel="v:url">
				<xsl:value-of select="name"/>
			</a>
		</span>
	</xsl:template>

	<!-- Declension of the numerals -->
	<xsl:template name="declension">

		<xsl:param name="number" select="number"/>

		<!-- Nominative case / Именительный падеж -->
	<xsl:variable name="nominative"><xsl:text>просмотр</xsl:text></xsl:variable>

		<!-- Genitive singular / Родительный падеж, единственное число -->
	<xsl:variable name="genitive_singular"><xsl:text>просмотра</xsl:text></xsl:variable>

	<xsl:variable name="genitive_plural"><xsl:text>просмотров</xsl:text></xsl:variable>
		<xsl:variable name="last_digit"><xsl:value-of select="$number mod 10"/></xsl:variable>
		<xsl:variable name="last_two_digits"><xsl:value-of select="$number mod 100"/></xsl:variable>

		<xsl:choose>
			<xsl:when test="$last_digit = 1 and $last_two_digits != 11">
				<xsl:value-of select="$nominative"/>
			</xsl:when>
			<xsl:when test="$last_digit = 2 and $last_two_digits != 12
				or $last_digit = 3 and $last_two_digits != 13
				or $last_digit = 4 and $last_two_digits != 14">
				<xsl:value-of select="$genitive_singular"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$genitive_plural"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>