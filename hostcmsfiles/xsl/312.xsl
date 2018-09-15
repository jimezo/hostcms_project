<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>
	<xsl:variable name="n" select="number(3)"/>

	<!-- СписокОбъявлений -->

	<xsl:template match="/">
		<SCRIPT type="text/javascript">
			<xsl:comment>
				<xsl:text disable-output-escaping="yes">
					<![CDATA[
						function cloneRow(rowId)
						{
							var row = $('#'+rowId),
								newRow = row.clone();

							newRow.find('.caption').text('');
							newRow.find('input').attr('value', '');
							row.after(newRow);
						}

						$(function() {
							// Проверка формы
							$('.validate').validate({
								focusInvalid: true,
								errorClass: "input_error"
							});
						});
					]]>
				</xsl:text>
			</xsl:comment>
		</SCRIPT>

		<xsl:apply-templates select="/shop"/>
	</xsl:template>

	<!-- Шаблон для магазина -->
	<xsl:template match="/shop">
		<!-- Store parent id in a variable -->
		<xsl:variable name="group" select="group"/>

		<xsl:choose>
			<xsl:when test="$group = 0">
				<div class="page-title category-title">
					<h1>
						<i class="fa fa-bookmark-o"></i><xsl:value-of select="name"/>
					</h1>
				</div>

				<!-- Description displays if there is no filtering by tags -->
				<xsl:if test="count(tag) = 0 and page = 0 and description != ''">
					<div hostcms:id="{@id}" hostcms:field="description" hostcms:entity="shop" hostcms:type="wysiwyg"><xsl:value-of disable-output-escaping="yes" select="description"/></div>
				</xsl:if>
			</xsl:when>
		<xsl:otherwise>
			<!-- Breadcrumbs -->
			<div class="breadcrumbs" xmlns:v="http://rdf.data-vocabulary.org/#">
				<xsl:apply-templates select=".//shop_group[@id=$group]" mode="breadCrumbs"/>
			</div>

			<div class="page-title category-title">
				<h1><i class="fa fa-folder-open-o"></i><xsl:value-of select=".//shop_group[@id=$group]/name"/></h1>
			</div>
		</xsl:otherwise>
		</xsl:choose>

		<!-- Сообщения -->
		<xsl:for-each select="errors/error">
			<div class="alert alert-danger"><xsl:value-of select="."/></div>
		</xsl:for-each>

		<xsl:for-each select="messages/message">
			<div class="alert alert-success"><xsl:value-of select="."/></div>
		</xsl:for-each>

		<xsl:if test="$group != 0">
			<!--  Метка для перехода при выводе сообщения -->
			<a name="FocusAddItemMessage"></a>

			<div class="actions item-margin-left">
				<!-- <button class="button btn-cart" type="button" title="Add Comment" onclick="$('#AddItemForm').toggle('slow')">
					<i class="fa fa-comments bg-color5"></i>
					<span class="bg-color2">
						<span>Добавить объявление в этот раздел</span>
					</span>
				</button>-->
				<button class="btn btn-primary" type="button" title="Add Comment" onclick="$('#AddItemForm').toggle('slow')">Добавить объявление в этот раздел</button>
			</div>

			<form action="{//shop_group[@id = $group]/url}" method="post" enctype="multipart/form-data" class="validate">
				<div class="comment" style="display: none" id="AddItemForm">
					<div class="row">
						<div class="caption">Заголовок<sup><font color="red">*</font></sup></div>
						<div class="field"><input size="50" type="text" name="name" value="{add_item/name}" class="required" minlength="1" title="Заполните поле Заголовок" /></div>
					</div>
					<div class="row">
						<div class="caption">Цена</div>
						<div class="field"><input size="15" type="text" name="price" value="{add_item/price}" /></div>
					</div>
					<div class="row">
						<div class="caption">Текст объявления</div>
						<div class="field">
							<textarea name="text" cols="50" rows="5"><xsl:value-of select="add_item/text" /></textarea>
						</div>
					</div>
					<div class="row">
						<div class="caption">Фото</div>
						<div class="field"><input type="file" name="image" /></div>
					</div>
					<xsl:for-each select="shop_item_properties//property">
						<xsl:sort select="sorting" />
						<div class="row" id="property_{@id}">
							<div class="caption">
								<xsl:value-of select="name" />
								<xsl:if test="shop_measure/node()">(<xsl:value-of select="shop_measure/name" />)</xsl:if>
							</div>
							<div class="field">
								<xsl:variable name="property_id" select="@id" />
								<xsl:variable name="property_value" select="//add_item/property[id = $property_id]/value" />

								<xsl:choose>
									<!-- Текстовое поле -->
									<xsl:when test="type &lt; 3 or type &gt; 6 and type != 10">
										<input name="property_{@id}">
											<xsl:attribute name="type">
												<xsl:choose>
													<xsl:when test="type = 2">file</xsl:when>
													<xsl:when test="type = 7">checkbox</xsl:when>
													<xsl:otherwise>text</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>

											<xsl:if test="type = 2">
												<xsl:attribute name="name">property_<xsl:value-of select="@id" />[]</xsl:attribute>
											</xsl:if>

											<!-- Значение полей по умолчанию -->
											<xsl:choose>
												<xsl:when test="type = 7">
													<xsl:if test="default_value != 0 and not($property_value) or $property_value = 'on'">
														<xsl:attribute name="checked">checked</xsl:attribute>
													</xsl:if>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="value">
														<xsl:choose>
															<xsl:when test="$property_value"><xsl:value-of select="$property_value"/></xsl:when>
															<xsl:otherwise><xsl:value-of select="default_value"/></xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>

													<!-- Размер поля INPUT в зависимости от типа -->
													<xsl:choose>
														<xsl:when test="type = 1">
															<xsl:attribute name="size">50</xsl:attribute>
														</xsl:when>
														<xsl:when test="type = 0 or type = 8 or type = 9">
															<xsl:attribute name="size">15</xsl:attribute>
														</xsl:when>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</input>
									</xsl:when>

									<!-- Выпадающий список -->
									<xsl:when test="type = 3">
										<select name="property_{$property_id}">
											<option value="0">...</option>
											<xsl:for-each select="list/list_item">
												<option value="{@id}">
													<xsl:if test="@id = $property_value">
														<xsl:attribute name="selected">selected</xsl:attribute>
													</xsl:if>
													<xsl:value-of disable-output-escaping="no" select="value" /></option>
											</xsl:for-each>
										</select>
									</xsl:when>
									<xsl:otherwise>
										<textarea name="property_{@id}" cols="50" rows="5">
											<xsl:choose>
												<xsl:when test="not($property_value)">
													<xsl:value-of select="default_value" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$property_value" />
												</xsl:otherwise>
											</xsl:choose>
										</textarea>
									</xsl:otherwise>
								</xsl:choose>
							</div>
						</div>

						<xsl:if test="type = 2">
							<div class="row">
								<div class="caption"></div>
								<div class="field">
									<span class="btn margin-bottom-10" onclick="cloneRow('property_{@id}')" style="cursor:pointer">Ещё файл...</span>
								</div>
							</div>
						</xsl:if>
					</xsl:for-each>

					<!-- Код подтверждения -->
					<xsl:if test="captcha_id != 0 and siteuser_id/node() = 0">
						<div class="row">
							<div class="caption"></div>
							<div class="field">
								<img id="formCaptcha_{@id}_{captcha_id}" src="/captcha.php?id={captcha_id}&amp;height=30&amp;width=100" class="captcha" name="captcha" />
								<div class="captcha">
									<img src="/images/refresh.png" /> <span onclick="$('#formCaptcha_{@id}_{captcha_id}').updateCaptcha('{captcha_id}', 30); return false">Показать другое число</span>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="caption">
								Контрольное число<sup><font color="red">*</font></sup>
							</div>
							<div class="field">
								<input type="hidden" name="captcha_id" value="{captcha_id}"/>
								<input type="text" name="captcha" size="15" class="required" minlength="4" title="Введите число, которое указано выше."/>
							</div>
						</div>
					</xsl:if>

					<div class="row">
						<div class="caption"></div>
						<div class="field">
							<!-- <input value="Отправить" class="button" type="submit" name="send_ad" /> -->
							<button class="btn btn-primary" type="submit" name="send_ad" value="send_ad">Отправить</button>
						</div>
					</div>
				</div>
			</form>
		</xsl:if>

		<xsl:variable name="count">1</xsl:variable>

		<!-- Show subgroups if there are subgroups and not processing of the selected tag -->
		<xsl:if test="count(tag) = 0 and count(shop_producer) = 0 and count(//shop_group[parent_id=$group]) &gt; 0">
			<div class="group_list">
				<xsl:apply-templates select=".//shop_group[parent_id=$group][position() mod $n = 1]"/>
			</div>
		</xsl:if>

		<xsl:if test="count(shop_item) &gt; 0 or /shop/filter = 1">
			<xsl:variable name="path"><xsl:choose>
					<xsl:when test="/shop//shop_group[@id=$group]/node()"><xsl:value-of select="/shop//shop_group[@id=$group]/url"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="/shop/url"/></xsl:otherwise>
			</xsl:choose></xsl:variable>

			<div class="row products-grid">
				<!-- Выводим товары магазина -->
				<xsl:apply-templates select="shop_item" />
			</div>

			<p class="button" id="compareButton">
				<xsl:if test="count(/shop/comparing/shop_item) = 0">
					<xsl:attribute name="style">display: none</xsl:attribute>
				</xsl:if>
				<a href="{/shop/url}compare_items/">Сравнить товары</a>
			</p>

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

				<nav>
					<ul class="pagination">
						<xsl:call-template name="for">
							<xsl:with-param name="limit" select="limit"/>
							<xsl:with-param name="page" select="page"/>
							<xsl:with-param name="items_count" select="total"/>
							<xsl:with-param name="i" select="$i"/>
							<xsl:with-param name="post_count_page" select="$post_count_page"/>
							<xsl:with-param name="pre_count_page" select="$pre_count_page"/>
							<xsl:with-param name="visible_pages" select="$real_visible_pages"/>
						</xsl:call-template>
					</ul>
				</nav>
			</xsl:if>

				<span class="on-page">Показать по:
					<a href="{$path}?on_page=20">20</a><xsl:text> </xsl:text>
					<a href="{$path}?on_page=50">50</a><xsl:text> </xsl:text>
					<a href="{$path}?on_page=100">100</a>
				</span>
		</xsl:if>
	</xsl:template>

	<!-- Шаблон для фильтра производителей -->
	<xsl:template match="shop_producerslist/producer">
		<option value="{@id}">
			<xsl:if test="@id = /shop/producer_id">
				<xsl:attribute name="selected">
				</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="name"/>
		</option>
	</xsl:template>

	<!-- Шаблон для фильтра по дополнительным свойствам -->
	<xsl:template match="property" mode="propertyList">
		<xsl:variable name="nodename">property_<xsl:value-of select="@id"/></xsl:variable>
		<xsl:variable name="nodename_from">property_<xsl:value-of select="@id"/>_from</xsl:variable>
		<xsl:variable name="nodename_to">property_<xsl:value-of select="@id"/>_to</xsl:variable>

		<div class="filterField">
			<xsl:value-of select="name"/><xsl:text> </xsl:text>
			<xsl:choose>
			<!-- Отображаем поле ввода -->
			<xsl:when test="filter = 1">
				<br/>
				<input type="text" name="property_{@id}">
					<xsl:if test="/shop/*[name()=$nodename] != ''">
						<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
					</xsl:if>
				</input>
			</xsl:when>
			<!-- Отображаем список -->
			<xsl:when test="filter = 2">
				<br/>
				<select name="property_{@id}">
					<option value="0">...</option>
					<xsl:apply-templates select="list/list_item"/>
				</select>
			</xsl:when>
			<!-- Отображаем переключатели -->
			<xsl:when test="filter = 3">
				<br/>
				<div class="propertyInput">
					<input type="radio" name="property_{@id}" value="0" id="id_prop_radio_{@id}_0"></input>
					<label for="id_prop_radio_{@id}_0">Любой вариант</label>
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
				<br/>
				<input type="checkbox" name="property_{@id}" id="property_{@id}" style="padding-top:4px">
					<xsl:if test="/shop/*[name()=$nodename] != ''">
						<xsl:attribute name="checked"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
					</xsl:if>
				</input>
				<label for="property_{@id}">Да</label>
			</xsl:when>
			<!-- Отображение полей "от и до" -->
			<xsl:when test="filter = 6">
				<br/>
				от: <input type="text" name="property_{@id}_from" size="2" value="{/shop/*[name()=$nodename_from]}"/> до: <input type="text" name="property_{@id}_to" size="2" value="{/shop/*[name()=$nodename_to]}"/>
			</xsl:when>
			<!-- Отображаем список с множественным выбором-->
			<xsl:when test="filter = 7">
				<br/>
				<select name="property_{@id}[]" multiple="multiple">
					<xsl:apply-templates select="list/list_item"/>
				</select>
			</xsl:when>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="list/list_item">
		<xsl:if test="../../filter = 2">
			<!-- Отображаем список -->
			<xsl:variable name="nodename">property_id_<xsl:value-of select="../../@id"/></xsl:variable>
			<option value="{@id}">
				<xsl:if test="/shop/*[name()=$nodename] = @id">
					<xsl:attribute name="selected">
					</xsl:attribute>
				</xsl:if>
				<xsl:value-of disable-output-escaping="yes" select="value"/>
			</option>
		</xsl:if>
		<xsl:if test="../../filter = 3">
			<!-- Отображаем переключатели -->
			<xsl:variable name="nodename">property_id_<xsl:value-of select="../../@id"/></xsl:variable>
			<br/>
			<input type="radio" name="property_id_{../../@id}" value="{@id}" id="id_property_id_{../../@id}_{@id}">
				<xsl:if test="/shop/*[name()=$nodename] = @id">
					<!--<xsl:attribute name="checked"> </xsl:attribute>-->
				</xsl:if>
				<label for="id_property_id_{../../@id}_{@id}">
					<xsl:value-of disable-output-escaping="yes" select="value"/>
				</label>
			</input>
		</xsl:if>
		<xsl:if test="../../filter = 4">
			<!-- Отображаем флажки -->
			<xsl:variable name="nodename">property_id_<xsl:value-of select="../../@id"/>_item_id_<xsl:value-of select="@id"/></xsl:variable>
			<br/>
			<input type="checkbox" name="property_id_{../../@id}_item_id_{@id}" id="id_property_id_{../../@id}_{@id}">
				<xsl:if test="/shop/*[name()=$nodename] = @id">
					<xsl:attribute name="checked"> </xsl:attribute>
				</xsl:if>
				<label for="id_property_id_{../../@id}_{@id}">
					<xsl:value-of disable-output-escaping="yes" select="value"/>
				</label>
			</input>
		</xsl:if>
		<xsl:if test="../../filter = 7">
			<!-- Отображаем список -->
			<xsl:variable name="nodename">property_id_<xsl:value-of select="../../@id"/></xsl:variable>
			<option value="{@id}">
				<xsl:if test="/shop/*[name()=$nodename] = @id">
					<xsl:attribute name="selected">
					</xsl:attribute>
				</xsl:if>
				<xsl:value-of disable-output-escaping="yes" select="value"/>
			</option>
		</xsl:if>
	</xsl:template>

	<!-- Цикл с шагом 10 для select'a количества элементов на страницу -->
	<xsl:template name="for_on_page">
		<xsl:param name="i" select="0"/>
		<xsl:param name="n"/>

		<option value="{$i}">
			<xsl:if test="$i = /shop/on_page">
				<xsl:attribute name="selected">
				</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$i"/>
		</option>

		<xsl:if test="$n &gt; $i">
			<!-- Рекурсивный вызов шаблона -->
			<xsl:call-template name="for_on_page">
				<xsl:with-param name="i" select="$i + 10"/>
				<xsl:with-param name="n" select="$n"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Шаблон для групп товара -->
	<xsl:template match="shop_group">
		<div class="row">
			<xsl:for-each select=". | following-sibling::shop_group[position() &lt; $n]">
				<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
					<xsl:if test="image_small != ''">
						<a href="{url}">
							<div>
								<img src="{dir}{image_small}" class="item-image"/>
							</div>
						</a>
					</xsl:if>
					<a href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_group"><xsl:value-of select="name"/></a><xsl:text> </xsl:text><span class="shop_count"><xsl:value-of select="items_total_count"/></span>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!-- Шаблон для товара -->
	<xsl:template match="shop_item">
		<div class="col-xs-12 col-sm-12 col-md-6 col-lg-4 item">
			<div class="grid_wrap">
				<xsl:if test="discount != 0">
					<div class="ribbon-wrapper">
						<div class="ribbon bg-color2">HOT</div>
					</div>
				</xsl:if>

				<a class="product-image" href="{url}" title="{name}">
					<xsl:choose>
						<xsl:when test="image_small != ''">
							<img src="{dir}{image_small}" alt="{name}" />
						</xsl:when>
						<xsl:otherwise>
							<i class="fa fa-camera"></i>
						</xsl:otherwise>
					</xsl:choose>
				</a>

				<div class="price-box">
					<span id="product-price-12-new" class="regular-price">
						<xsl:choose>
							<xsl:when test="price != 0">
								<span class="price">
									<xsl:value-of select="format-number(price, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="currency"/><xsl:text> </xsl:text>
								</span>
								<xsl:if test="discount != 0">
									<br/>
									<span class="old-price">
										<xsl:value-of select="format-number(price+discount, '### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="currency"/><xsl:text> </xsl:text>
									</span>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise><span class="price">Бесплатно</span></xsl:otherwise>
						</xsl:choose>
					</span>
				</div>

				<div class="product-shop">
					<h3 class="product-name">
						<a href="{url}" title="{name}">
							<xsl:value-of select="name"/>
						</a>
					</h3>

					<div class="product-date">
						<xsl:value-of disable-output-escaping="yes" select="format-number(substring-before(datetime, '.'), '#')"/>
						<xsl:variable name="month_year" select="substring-after(datetime, '.')"/>
						<xsl:variable name="month" select="substring-before($month_year, '.')"/>
						<xsl:choose>
							<xsl:when test="$month = 1"> января </xsl:when>
							<xsl:when test="$month = 2"> февраля </xsl:when>
							<xsl:when test="$month = 3"> марта </xsl:when>
							<xsl:when test="$month = 4"> апреля </xsl:when>
							<xsl:when test="$month = 5"> мая </xsl:when>
							<xsl:when test="$month = 6"> июня </xsl:when>
							<xsl:when test="$month = 7"> июля </xsl:when>
							<xsl:when test="$month = 8"> августа </xsl:when>
							<xsl:when test="$month = 9"> сентября </xsl:when>
							<xsl:when test="$month = 10"> октября </xsl:when>
							<xsl:when test="$month = 11"> ноября </xsl:when>
							<xsl:otherwise> декабря </xsl:otherwise>
						</xsl:choose>
						в
						<!-- Время -->
						<xsl:variable name="full_time" select="substring-after($month_year, ' ')"/>
						<xsl:value-of select="substring($full_time, 1, 5)" /><xsl:text> </xsl:text>
					</div>

					<div class="product-city">
						<xsl:value-of disable-output-escaping="yes" select="description"/>

						<xsl:variable name="city_name" select="property_value[tag_name='city']/value"/>

						<xsl:if test="$city_name != ''">
							<xsl:value-of select="$city_name" />
						</xsl:if>
					</div>
				</div>
			</div>
		</div>

		<!-- <xsl:if test="position() mod 3 = 0 and position() != last()">
			<xsl:text disable-output-escaping="yes">
				&lt;/ul&gt;
				&lt;ul class="products-grid row"&gt;
			</xsl:text>
		</xsl:if>-->
	</xsl:template>

	<!-- Шаблон для модификаций -->
	<xsl:template match="modifications/shop_item">
		<tr>
			<td>
				<!-- Название модификации -->
				<a href="{url}">
					<xsl:value-of select="name"/>
				</a>
			</td>
			<td>
				<!-- Цена модификации -->
				<xsl:choose>
					<xsl:when test="price != 0">
						<xsl:value-of select="price"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="currency"/>
					</xsl:when>
					<xsl:otherwise>договорная</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

	<!-- Шаблон для скидки -->
	<xsl:template match="discount">
		<br/>
		<xsl:value-of select="name"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="value"/>%</xsl:template>

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
			<li>
				<span aria-hidden="true"><i class="fa fa-angle-double-left"></i></span>
			</li>
		</xsl:if>

		<xsl:if test="$i = ($page + $post_count_page + 1) and $n != ($page+1)">
			<li>
				<span aria-hidden="true"><i class="fa fa-angle-double-right"></i></span>
			</li>
		</xsl:if>

		<!-- Filter String -->
		<xsl:variable name="filter"><xsl:if test="/shop/filter/node()">?filter=1&amp;sorting=<xsl:value-of select="/shop/sorting"/>&amp;price_from=<xsl:value-of select="/shop/price_from"/>&amp;price_to=<xsl:value-of select="/shop/price_to"/><xsl:for-each select="/shop/*"><xsl:if test="starts-with(name(), 'property_')">&amp;<xsl:value-of select="name()"/>[]=<xsl:value-of select="."/></xsl:if></xsl:for-each></xsl:if></xsl:variable>

		<xsl:variable name="on_page"><xsl:if test="/shop/on_page/node() and /shop/on_page > 0"><xsl:choose><xsl:when test="/shop/filter/node()">&amp;</xsl:when><xsl:otherwise>?</xsl:otherwise></xsl:choose>on_page=<xsl:value-of select="/shop/on_page"/></xsl:if></xsl:variable>

		<xsl:if test="$items_count &gt; $limit and ($page + $post_count_page + 1) &gt; $i">
			<!-- Store in the variable $group ID of the current group -->
			<xsl:variable name="group" select="/shop/group"/>

			<!-- Tag Path -->
			<xsl:variable name="tag_path"><xsl:if test="count(/shop/tag) != 0">tag/<xsl:value-of select="/shop/tag/urlencode"/>/</xsl:if></xsl:variable>

			<!-- Compare Product Path -->
			<xsl:variable name="shop_producer_path"><xsl:if test="count(/shop/shop_producer)">producer-<xsl:value-of select="/shop/shop_producer/@id"/>/</xsl:if></xsl:variable>

			<!-- Choose Group Path -->
			<xsl:variable name="group_link"><xsl:choose><xsl:when test="$group != 0"><xsl:value-of select="/shop//shop_group[@id=$group]/url"/></xsl:when><xsl:otherwise><xsl:value-of select="/shop/url"/></xsl:otherwise></xsl:choose></xsl:variable>

			<!-- Set $link variable -->
			<xsl:variable name="number_link"><xsl:if test="$i != 0">page-<xsl:value-of select="$i + 1"/>/</xsl:if></xsl:variable>

			<!-- First pagination item -->
			<xsl:if test="$page - $pre_count_page &gt; 0 and $i = $start_page">
				<li>
					<a href="{$group_link}{$tag_path}{$shop_producer_path}{$filter}{$on_page}" class="page_link" style="text-decoration: none;">←</a>
				</li>
			</xsl:if>

			<!-- Pagination item -->
			<xsl:if test="$i != $page">
				<xsl:if test="($page - $pre_count_page) &lt;= $i and $i &lt; $n">
					<!-- Pagination item -->
					<li>
						<a href="{$group_link}{$number_link}{$tag_path}{$shop_producer_path}{$filter}{$on_page}" class="page_link">
							<xsl:value-of select="$i + 1"/>
						</a>
					</li>
				</xsl:if>

				<!-- Last pagination item -->
				<xsl:if test="$i+1 &gt;= ($page + $post_count_page + 1) and $n &gt; ($page + 1 + $post_count_page)">
					<!-- Last pagination item -->
					<li>
						<a href="{$group_link}page-{$n}/{$tag_path}{$shop_producer_path}{$filter}{$on_page}" class="page_link" style="text-decoration: none;">→</a>
					</li>
				</xsl:if>
			</xsl:if>

			<!-- Ctrl+left link -->
			<xsl:if test="$page != 0 and $i = $page"><xsl:variable name="prev_number_link"><xsl:if test="$page &gt; 1">page-<xsl:value-of select="$i"/>/</xsl:if></xsl:variable><a href="{$group_link}{$prev_number_link}{$tag_path}{$shop_producer_path}{$filter}{$on_page}" id="id_prev"></a></xsl:if>

			<!-- Ctrl+right link -->
			<xsl:if test="($n - 1) > $page and $i = $page">
				<a href="{$group_link}page-{$page+2}/{$tag_path}{$shop_producer_path}{$filter}{$on_page}" id="id_next"></a>
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
</xsl:stylesheet>