<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:include href="import://179" />

	<xsl:template match="/">
		<div class="row">
			<xsl:apply-templates select="helpdesk"/>
		</div>
	</xsl:template>

	<!-- ВыводСпискаТикетов -->

	<xsl:template match="helpdesk">
		<SCRIPT type="text/javascript" language="JavaScript">
			<xsl:comment>
				<xsl:text disable-output-escaping="yes">
					<![CDATA[
					$(function() {
						$('#addFile').click(function(){
							r = $(this).parents('.form-group');
							r2 = r.clone();
							r2.find('.caption').text('');
							r2.find('a').remove();
							r.after(r2);
							return false;
						});
					});
					]]>
				</xsl:text>
			</xsl:comment>
		</SCRIPT>

		<div class="col-xs-12">
			<div class="box-user-content">
				<div class="user-tickets">

					<xsl:if test="message/node()">
						<div class="alert alert-info">
							<xsl:value-of disable-output-escaping="yes" select="message"/>
						</div>
					</xsl:if>

					<div class="row margin-bottom-20">
						<div class="col-xs-12 col-md-6">
							<h2>Служба поддержки <xsl:value-of select="name"/></h2>
						</div>
						<div class="col-xs-12 col-md-6 text-align-right">
							<a class="btn btn-primary btn-white-text" href="#" onclick="$('#AddTicket').toggle('slow'); return false">Направить запрос</a>
						</div>
					</div>

					<div id="AddTicket" style="display: none" class="margin-bottom-20">
						<xsl:call-template name="AddTicketForm"></xsl:call-template>
					</div>

					<xsl:choose>
						<xsl:when test="helpdesk_ticket/node()">
							<div class="row table-header">
								<div class="col-xs-2">
									Номер
								</div>
								<div class="col-xs-6">
									Тема
								</div>
								<div class="col-xs-1">

								</div>
								<div class="col-xs-3">
									Дата
								</div>
							</div>

							<xsl:apply-templates select="helpdesk_ticket"/>
						</xsl:when>
						<xsl:otherwise>
							<p><span style="color: #777">Обращений не найдено.</span></p>
						</xsl:otherwise>
					</xsl:choose>

					<div class="row">
						<div class="col-md-8 col-md-offset-2 text-align-center">
							<nav>
								<ul class="pagination">
									<xsl:call-template name="for">
										<xsl:with-param name="link" select="/helpdesk/url"/>
										<xsl:with-param name="ticket_on_page" select="/helpdesk/limit"/>
										<xsl:with-param name="current_page" select="/helpdesk/page"/>
										<xsl:with-param name="ticket_count" select="/helpdesk/total"/>
										<xsl:with-param name="visible_pages" select="5"/>
									</xsl:call-template>
								</ul>
							</nav>
						</div>
					</div>

					<div class="row">
						<div class="col-xs-12 text-align-right">
							<a class="btn btn-secondary btn-white-text margin-bottom-20" href="{url}worktime/">Режим работы</a>
						</div>
					</div>
				</div>

				<!-- Right panel -->
				<xsl:apply-templates select="siteuser" mode="right-panel" />
			</div>
		</div>
	</xsl:template>

	<xsl:template match="helpdesk_ticket">
		<div class="row table-row">
			<div class="col-xs-2">
				<span><a href="/users/helpdesk/ticket-{@id}/"><xsl:value-of select="number"/></a></span>
			</div>
			<div class="col-xs-6">
				<span>
					<xsl:if test="open = 0">
						<xsl:attribute name="class">ticket-closed</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="helpdesk_ticket_subject != ''">
							<xsl:value-of select="helpdesk_ticket_subject"/>
						</xsl:when>
						<xsl:otherwise><xsl:text>[Без темы]</xsl:text></xsl:otherwise>
					</xsl:choose>
				</span>

				<xsl:choose>
					<xsl:when test="open = 0">
						<a href="./?open_ticket={@id}"><i class="fa fa-lock" title="Открыть запрос"></i></a>
					</xsl:when>
					<xsl:otherwise>
						<a href="./?close_ticket={@id}"><i class="fa fa-unlock" title="Закрыть запрос"></i></a>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:if test="open = 1">
				<div class="row">
					<div class="col-xs-12 margin-top-10">
						<span class="hostcms-label blue white">
							<xsl:choose>
								<xsl:when test="processed_messages_count = messages_count">
									<span>Ожидаем Ваш ответ.</span>
								</xsl:when>
								<xsl:otherwise>
									<!-- Возможные состояния
									1 - Ответ не дан вовремя
									2 - Ожидание ответа пользователя-->
									<xsl:choose>
										<xsl:when test="expire > 0">
										<xsl:if test="expire = 1"><span>Скоро ответим …</span></xsl:if>
										<xsl:if test="expire = 2"><span>Ожидаем Ваш ответ.</span></xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:if test="expire_after_days/node() or expire_after_hours/node() or expire_after_minutes/node()">
												<span>Ответим в течение<xsl:choose>
														<xsl:when test="expire_after_days/node()">
														<xsl:if test="expire_after_days/node()"><xsl:text> </xsl:text><xsl:value-of select="expire_after_days"/><xsl:text> </xsl:text>
																<xsl:variable name="nominative">дня</xsl:variable>
																<xsl:variable name="genitive_singular">дней</xsl:variable>
																<xsl:variable name="genitive_plural">дней</xsl:variable>

																<xsl:call-template name="declension">
																	<xsl:with-param name="number" select="expire_after_days"/>
																	<xsl:with-param name="nominative" select="$nominative"/>
																	<xsl:with-param name="genitive_singular" select="$genitive_singular"/>
																	<xsl:with-param name="genitive_plural" select="$genitive_plural"/>
																</xsl:call-template>
															</xsl:if>
														</xsl:when>
														<xsl:otherwise>
														<xsl:if test="expire_after_hours/node()"><xsl:text> </xsl:text><xsl:value-of select="expire_after_hours"/><xsl:text> </xsl:text>
																<xsl:variable name="nominative">часа</xsl:variable>
																<xsl:variable name="genitive_singular">часов</xsl:variable>
																<xsl:variable name="genitive_plural">часов</xsl:variable>

																<xsl:call-template name="declension">
																	<xsl:with-param name="number" select="expire_after_hours"/>
																	<xsl:with-param name="nominative" select="$nominative"/>
																	<xsl:with-param name="genitive_singular" select="$genitive_singular"/>
																	<xsl:with-param name="genitive_plural" select="$genitive_plural"/>
																</xsl:call-template>
															</xsl:if>
													<xsl:if test="expire_after_minutes/node()"><xsl:text> </xsl:text><xsl:value-of select="expire_after_minutes"/><xsl:text> </xsl:text><xsl:variable name="nominative">минуты</xsl:variable>
																<xsl:variable name="genitive_singular">минут</xsl:variable>
																<xsl:variable name="genitive_plural">минут</xsl:variable>

																<xsl:call-template name="declension">
																	<xsl:with-param name="number" select="expire_after_minutes"/>
																	<xsl:with-param name="nominative" select="$nominative"/>
																	<xsl:with-param name="genitive_singular" select="$genitive_singular"/>
																	<xsl:with-param name="genitive_plural" select="$genitive_plural"/>
																</xsl:call-template>
															</xsl:if>.
														</xsl:otherwise>
													</xsl:choose>
												</span>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</span>
				</div>
				</div>
				</xsl:if>
			</div>
			<div class="col-xs-1">
				<span class="hostcms-label gray"><xsl:value-of select="processed_messages_count"/><xsl:text>/</xsl:text><xsl:value-of select="messages_count"/></span>
			</div>
			<div class="col-xs-3">
				<xsl:value-of select="datetime"/>
			</div>
		</div>
	</xsl:template>

	<!-- Шаблон для уровней критичности -->
	<xsl:template match="helpdesk_criticality_level">
		<option value="{@id}">
			<xsl:if test="@id = /helpdesk/helpdesk_criticality_level_id">
				<xsl:attribute name="selected"></xsl:attribute>
			</xsl:if>
			<xsl:value-of select="name"/>
		</option>
	</xsl:template>

	<!-- Шаблон для категорий тикетов -->
	<xsl:template match="helpdesk_category">
		<xsl:variable name="i" select="count(ancestor::helpdesk_category)" />
		<option value="{@id}">
			<xsl:if test="@id = /helpdesk/helpdesk_category_id">
				<xsl:attribute name="selected"></xsl:attribute>
			</xsl:if>
			<xsl:call-template name="for_criticality_level_name">
				<xsl:with-param name="i" select="$i"/>
			</xsl:call-template>
			<xsl:value-of select="name"/>
		</option>
		<xsl:apply-templates select="helpdesk_category" />
	</xsl:template>

	<!-- Цикл для вывода пробелов перед категориями -->
	<xsl:template name="for_criticality_level_name">
		<xsl:param name="i" select="0" />
		<xsl:if test="$i > 0">
			<xsl:text> </xsl:text>
			<xsl:call-template name="for_criticality_level_name">
				<xsl:with-param name="i" select="$i - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Цикл для вывода строк ссылок -->
	<xsl:template name="for">
		<xsl:param name="i" select="0"/>
		<xsl:param name="prefix">page</xsl:param>
		<xsl:param name="link"/>
		<xsl:param name="ticket_on_page"/>
		<xsl:param name="current_page"/>
		<xsl:param name="ticket_count"/>
		<xsl:param name="visible_pages"/>

		<xsl:variable name="n" select="$ticket_count div $ticket_on_page"/>

		<!-- Считаем количество выводимых ссылок перед текущим элементом -->
		<xsl:variable name="pre_count_page">
			<xsl:choose>
				<xsl:when test="$current_page &gt; ($n - (round($visible_pages div 2) - 1))">
					<xsl:value-of select="$visible_pages - ($n - $current_page)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="round($visible_pages div 2) - 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Считаем количество выводимых ссылок после текущего элемента -->
		<xsl:variable name="post_count_page">
			<xsl:choose>
				<xsl:when test="0 &gt; $current_page - (round($visible_pages div 2) - 1)">
					<xsl:value-of select="$visible_pages - $current_page - 1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="round($visible_pages div 2) = ($visible_pages div 2)">
							<xsl:value-of select="$visible_pages div 2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="round($visible_pages div 2) - 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- <xsl:if test="$i = 0 and $current_page != 0">
			<span class="ctrl">
				← Ctrl
			</span>
		</xsl:if>

		<xsl:if test="$i >= $n and ($n - 1) > $current_page">
			<span class="ctrl">
				Ctrl →
			</span>
		</xsl:if> -->

		<xsl:if test="$ticket_count &gt; $ticket_on_page and $n &gt; $i">

			<!-- Определяем адрес ссылки -->
			<xsl:variable name="number_link">
				<xsl:choose>
					<!-- Если не нулевой уровень -->
					<xsl:when test="$i != 0">
						<xsl:value-of select="$prefix"/>-<xsl:value-of select="$i + 1"/>/</xsl:when>
					<!-- Иначе если нулевой уровень - просто ссылка на страницу со списком элементов -->
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!-- Передаем фильтр -->
			<xsl:variable name="filter">
				<xsl:choose>
					<xsl:when test="/helpdesk/apply_filter/node()">?action=apply_filter&amp;status=<xsl:value-of select="/helpdesk/apply_filter"/>
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!-- Определяем первый символ вопрос или амперсанд -->
			<xsl:variable name="first_symbol">
				<xsl:choose>
					<xsl:when test="$filter != ''">&amp;</xsl:when>
					<xsl:otherwise>?</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!-- Ставим ссылку на страницу-->
			<xsl:if test="$i != $current_page">
				<!-- Выводим ссылку на первую страницу -->
				<xsl:if test="$current_page - $pre_count_page &gt; 0 and $i = 0">
					<li><a href="{$link}{$filter}" class="page_link" style="text-decoration: none;">←</a></li>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="$i &gt;= ($current_page - $pre_count_page) and ($current_page + $post_count_page) &gt;= $i">
						<!-- Выводим ссылки на видимые страницы -->
						<li><a href="{$link}{$number_link}{$filter}">
							<xsl:value-of select="$i + 1"/>
						</a></li>
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>

				<!-- Выводим ссылку на последнюю страницу -->
				<xsl:if test="$i+1 &gt;= $n and $n &gt; ($current_page + 1 + $post_count_page)">
					<xsl:choose>
						<xsl:when test="$n &gt; round($n)">
							<!-- Выводим ссылку на последнюю страницу -->
							<li><a href="{$link}{$filter}{$prefix}-{round($n+1)}/" style="text-decoration: none;">→</a></li>
						</xsl:when>
						<xsl:otherwise>
							<li><a href="{$link}{$filter}{$prefix}-{round($n)}/" style="text-decoration: none;">→</a></li>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:if>

			<!-- Ссылка на предыдущую страницу для Ctrl + влево -->
			<xsl:if test="$current_page != 0 and $i = $current_page">
				<xsl:variable name="prev_number_link">
					<xsl:choose>
						<!-- Если не нулевой уровень -->
						<xsl:when test="($current_page - 1) != 0">page-<xsl:value-of select="$i"/>/</xsl:when>
						<!-- Иначе если нулевой уровень - просто ссылка на страницу со списком элементов -->
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<li class="hidden"><a href="{$link}{$prev_number_link}{$filter}" id="id_prev"></a></li>
			</xsl:if>

			<!-- Ссылка на следующую страницу для Ctrl + вправо -->
			<xsl:if test="($n - 1) > $current_page and $i = $current_page">
				<li class="hidden"><a href="{$link}{$filter}page-{$current_page+2}/" id="id_next"></a></li>
			</xsl:if>

			<!-- Не ставим ссылку на страницу-->
			<xsl:if test="$i = $current_page">
				<li class="active">
					<a href="#"><xsl:value-of select="$i+1"/></a>
				</li>
			</xsl:if>

			<!-- Рекурсивный вызов шаблона. НЕОБХОДИМО ПЕРЕДАВАТЬ ВСЕ НЕОБХОДИМЫЕ ПАРАМЕТРЫ! -->
			<xsl:call-template name="for">
				<xsl:with-param name="i" select="$i + 1"/>
				<xsl:with-param name="prefix" select="$prefix"/>
				<xsl:with-param name="link" select="$link"/>
				<xsl:with-param name="ticket_on_page" select="$ticket_on_page"/>
				<xsl:with-param name="current_page" select="$current_page"/>
				<xsl:with-param name="ticket_count" select="$ticket_count"/>
				<xsl:with-param name="visible_pages" select="$visible_pages"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<!-- Шаблон вывода добавления сообщения-->
	<xsl:template name="AddTicketForm">
		<!--Отображение формы добавления запроса в службу техподдержки-->
		<form action="{/helpdesk/url}" class="show form" method="post" enctype="multipart/form-data">
			<div class="form-group">
				<label for="subject">Тема</label>
				<input class="form-control" type="text" size="62" name="subject" value=""/>
			</div>

			<xsl:if test="helpdesk_criticality_level/node()">
				<div class="form-group">
					<label for="criticality_level_id">Уровень критичности</label>
					<select name="criticality_level_id" class="form-control">
						<xsl:apply-templates select="helpdesk_criticality_level"/>
					</select>
				</div>
			</xsl:if>

			<xsl:if test="helpdesk_category/node()">
				<div class="form-group">
					<label for="helpdesk_category_id">Категория</label>
					<select name="helpdesk_category_id" class="form-control">
						<option value="0">…</option>
						<xsl:apply-templates select="helpdesk_category" />
					</select>
				</div>
			</xsl:if>

			<div class="form-group">
				<label for="text">Текст сообщения</label>
				<xsl:choose>
					<xsl:when test="/helpdesk/messages_type = 0">
						<textarea name="text" rows="10" class="form-control mceEditor"></textarea>
					</xsl:when>
					<xsl:otherwise>
						<textarea name="text" rows="10" class="form-control"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>

			<div class="form-group">
				<div class="checkbox">
					<label>
						<input type="checkbox" checked="checked" name="send_email" />
						Отсылать ответы на e-mail
					</label>
				</div>
			</div>

			<div class="form-group">
				<div class="field">
					<div class="input-group">
						<input class="no-padding-left pull-left" name="attachment[]" type="file" title="Прикрепить файл" />
						<a class="input-group-addon green-text add-file" href="#" id="addFile">
							<i class="fa fa-fw fa-plus"></i>
						</a>
					</div>
				</div>
			</div>

			<button type="submit" class="btn btn-primary btn-white-text full-width margin-top-10" name="add_ticket" value="add_ticket">Отправить</button>
		</form>
	</xsl:template>

	<!-- Склонение после числительных -->
	<xsl:template name="declension">

		<xsl:param name="number" select="number"/>
		<!-- Именительный падеж -->
		<xsl:param name="nominative" select="nominative"/>
		<!-- Родительный падеж, единственное число -->
		<xsl:param name="genitive_singular" select="genitive_singular"/>
		<!-- Родительный падеж, множественное число -->
		<xsl:param name="genitive_plural" select="genitive_plural"/>

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
			<xsl:when test="$last_digit = 2 and $last_two_digits != 12 or $last_digit = 3 and $last_two_digits != 13 or $last_digit = 4 and $last_two_digits != 14">
				<xsl:value-of select="$genitive_singular"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$genitive_plural"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>