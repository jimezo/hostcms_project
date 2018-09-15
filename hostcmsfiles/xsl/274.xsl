<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>
	
	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="/shop"/>
	</xsl:template>
	
	<xsl:variable name="n" select="number(3)"/>
	
	<xsl:template match="/shop">
		
		<!-- Store parent id in a variable -->
		<xsl:variable name="group" select="group"/>
		
		<xsl:choose>
			<xsl:when test="$group = 0">
				<h1><xsl:value-of select="name"/></h1>
				
				<!-- Description displays if there is no filtering by tags -->
				<xsl:if test="count(tag) = 0 and page = 0 and description != ''">
					<div hostcms:id="{@id}" hostcms:field="description" hostcms:entity="shop" hostcms:type="wysiwyg"><xsl:value-of disable-output-escaping="yes" select="description"/></div>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="currentGroup" select=".//shop_group[@id=$group]" />
				
				<!-- Breadcrumbs -->
				<!-- <div class="breadcrumbs" xmlns:v="http://rdf.data-vocabulary.org/#">
					<xsl:apply-templates select="$currentGroup" mode="breadCrumbs"/>
				</div> -->
				
				<!-- Название группы -->
				<div class="shop-group-title">
					<h1>
						<!-- <i class="fa fa-folder-open-o"></i> -->
						<xsl:value-of disable-output-escaping="yes" select="$currentGroup/name"/>
					</h1>
				</div>
				
				<!-- Описание группы -->
				<xsl:value-of disable-output-escaping="yes" select="$currentGroup/description"/>
				
			</xsl:otherwise>
		</xsl:choose>
		
		<!-- Processing of the selected tag -->
		<xsl:if test="count(tag)">
		<p class="h2">Метка — <strong><xsl:value-of select="tag/name"/></strong>.</p>
			<xsl:if test="tag/description != ''">
				<p><xsl:value-of select="tag/description" disable-output-escaping="yes" /></p>
			</xsl:if>
		</xsl:if>
		
		<xsl:variable name="count">1</xsl:variable>
		
		<!-- Show subgroups if there are subgroups and not processing of the selected tag -->
		<xsl:if test="count(tag) = 0 and count(shop_producer) = 0 and count(//shop_group[parent_id=$group]) &gt; 0">
			<div class="category-list">
				<xsl:apply-templates select=".//shop_group[parent_id=$group][position() mod $n = 1]"/>
			</div>
		</xsl:if>
		
		<xsl:if test="count(shop_item) &gt; 0 or /shop/filter = 1">
			<!-- дополнение пути для action, если выбрана метка -->
		<xsl:variable name="form_tag_url"><xsl:if test="count(tag) = 1">tag/<xsl:value-of select="tag/urlencode"/>/</xsl:if></xsl:variable>
			
			<xsl:variable name="path"><xsl:choose>
					<xsl:when test="/shop//shop_group[@id=$group]/node()"><xsl:value-of select="/shop//shop_group[@id=$group]/url"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="/shop/url"/><xsl:if test="/shop/shop_producer/node()">producer-<xsl:value-of select="/shop/shop_producer/@id" />/</xsl:if></xsl:otherwise>
			</xsl:choose></xsl:variable>
			
			<form method="get" action="{$path}{$form_tag_url}">
				<!-- Таблица с элементами для сравнения -->
				<xsl:if test="count(/shop/compare_items/compare_item) &gt; 0">
					<table cellpadding="5px" cellspacing="0" border="0">
						<tr>
							<td>
								<input type="checkbox" onclick="SelectAllItemsByPrefix(this.checked, 'del_compare_id_')" />
							</td>
							<td>
								<b>Сравниваемые элементы</b>
							</td>
						</tr>
						<xsl:apply-templates select="compare_items/compare_item"/>
					</table>
				</xsl:if>
				
				<!-- Выводим товары магазина -->
				<div class="row products-grid">
					<xsl:apply-templates select="shop_item" />
				</div>
				
				<a id="compareButton" class="btn btn-primary" href="{/shop/url}compare_items/">
					<xsl:if test="count(/shop/comparing/shop_item) = 0">
						<xsl:attribute name="style">display: none</xsl:attribute>
					</xsl:if>
					Сравнить товары
				</a>
				
				<xsl:if test="total &gt; 0 and limit &gt; 0 and ceiling(total div limit) &gt; 1">
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
				
				<!-- Filter String -->
	<xsl:variable name="filter"><xsl:if test="/shop/filter/node()">&amp;filter=1&amp;sorting=<xsl:value-of select="/shop/sorting"/>&amp;price_from=<xsl:value-of select="/shop/price_from"/>&amp;price_to=<xsl:value-of select="/shop/price_to"/><xsl:for-each select="/shop/*"><xsl:if test="starts-with(name(), 'property_')">&amp;<xsl:value-of select="name()"/>[]=<xsl:value-of select="."/></xsl:if></xsl:for-each></xsl:if></xsl:variable>
				
				<span class="on-page">Показать по:
				<a href="{$path}?on_page=20{$filter}">20</a><xsl:text> </xsl:text>
				<a href="{$path}?on_page=50{$filter}">50</a><xsl:text> </xsl:text>
					<a href="{$path}?on_page=100{$filter}">100</a>
				</span>
				
				<div style="clear: both"></div>
			</form>
		</xsl:if>
		
		<!-- Есть избранные товары -->
		<xsl:if test="favorite/shop_item">
			<h1>Избранные товары</h1>
			<!-- Выводим товары магазина -->
			<div class="row products-grid">
				<xsl:apply-templates select="favorite/shop_item" />
			</div>
		</xsl:if>
		
		<!-- Есть просмотренные товары -->
		<xsl:if test="viewed/shop_item">
			<h1>Просмотренные товары</h1>
			<!-- Выводим товары магазина -->
			<div class="row products-grid">
				<xsl:apply-templates select="viewed/shop_item[position() &lt; 4]" />
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
								<a class="shop-item-fast-order-link" href="#" onclick="return $.oneStepCheckout('{/shop/url}cart/', {@id}, 1)" title="Быстрый заказ" data-toggle="modal" data-target="#oneStepCheckout{@id}"><i class="fa fa-shopping-cart"></i></a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<!-- Шаблон для групп товара -->
	<xsl:template match="shop_group">
		<div class="row">
			<xsl:for-each select=". | following-sibling::shop_group[position() &lt; $n]">
				<div class="col-xs-12 col-md-4 text-align-center">
					<div class="category">
						<div class="category-image">
							<a href="{url}">
								<xsl:choose>
									<xsl:when test="image_small != ''">
										<img src="{dir}{image_small}"/>
									</xsl:when>
									<xsl:otherwise>
										<img src="/images/default-image.png"/>
									</xsl:otherwise>
								</xsl:choose>
							</a>
						</div>
						<a class="category-name" href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_group"><xsl:value-of select="name"/></a>
					</div>
				</div>
			</xsl:for-each>
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
	
	<!-- Шаблон для списка товаров для сравнения -->
	<xsl:template match="compare_items/compare_item">
		<xsl:variable name="var_compare_id" select="."/>
		<tr>
			<td>
				<input type="checkbox" name="del_compare_id_{compare_item_id}" id="id_del_compare_id_{compare_item_id}"/>
			</td>
			<td>
				<a href="{/shop/url}{compare_item_url}{compare_url}/">
					<xsl:value-of select="compare_name"/>
				</a>
			</td>
		</tr>
	</xsl:template>
	
	<!-- Шаблон для фильтра по дополнительным свойствам -->
	<xsl:template match="property" mode="propertyList">
		<xsl:variable name="nodename">property_<xsl:value-of select="@id"/></xsl:variable>
		<xsl:variable name="nodename_from">property_<xsl:value-of select="@id"/>_from</xsl:variable>
		<xsl:variable name="nodename_to">property_<xsl:value-of select="@id"/>_to</xsl:variable>
		
		<div class="filterField">
			
			<xsl:if test="filter != 5">
			<legend><xsl:value-of select="name"/><xsl:text> </xsl:text></legend>
			</xsl:if>
			
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
			<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
			<option value="{@id}">
			<xsl:if test="/shop/*[name()=$nodename] = @id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				<xsl:value-of disable-output-escaping="yes" select="value"/>
			</option>
		</xsl:if>
		<xsl:if test="../../filter = 3">
			<!-- Отображаем переключатели -->
			<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
			<br/>
			<input type="radio" name="property_{../../@id}" value="{@id}" id="id_property_{../../@id}_{@id}">
				<xsl:if test="/shop/*[name()=$nodename] = @id">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
			</input>
			<label for="id_property_{../../@id}_{@id}">
				<xsl:value-of disable-output-escaping="yes" select="value"/>
			</label>
		</xsl:if>
		<xsl:if test="../../filter = 4">
			<!-- Отображаем флажки -->
			<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
			<br/>
			<input type="checkbox" value="{@id}" name="property_{../../@id}[]" id="property_{../../@id}_{@id}">
				<xsl:if test="/shop/*[name()=$nodename] = @id">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				<label for="property_{../../@id}_{@id}">
					<xsl:value-of disable-output-escaping="yes" select="value"/>
				</label>
			</input>
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
	
	<!-- Метки для товаров -->
	<xsl:template match="tag">
		<a href="{/shop/url}tag/{urlencode}/" class="tag">
			<xsl:value-of select="tag_name"/>
		</a>
	<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
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
			<xsl:if test="$page != 0 and $i = $page">
				<xsl:variable name="prev_number_link">
					<xsl:if test="$page &gt; 1">page-<xsl:value-of select="$i"/>/</xsl:if>
				</xsl:variable>
				
				<a href="{$group_link}{$prev_number_link}{$tag_path}{$shop_producer_path}{$filter}{$on_page}" id="id_prev"></a>
			</xsl:if>
			
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
	
	<!-- Шаблон для фильтра производителей -->
	<xsl:template match="producers/shop_producer">
		<!-- Store in the variable $group ID of the current group -->
		<xsl:variable name="group" select="/shop/group"/>
		
		<!-- Choose Group Path -->
<xsl:variable name="group_link"><xsl:choose><xsl:when test="$group != 0"><xsl:value-of select="/shop//shop_group[@id=$group]/url"/></xsl:when><xsl:otherwise><xsl:value-of select="/shop/url"/></xsl:otherwise></xsl:choose></xsl:variable>
		
		<a href="{$group_link}?producer_id={@id}"><xsl:value-of select="name"/></a>
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