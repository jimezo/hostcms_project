<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- СообщенияТемы -->
	<xsl:template match="/forum">
		<!-- Topic Subject -->
		<h1 class="item_title">
			<xsl:value-of select="forum_topic/forum_topic_post/subject"/>
		</h1>

		<!-- Вывод сообщения о событии, если оно есть -->
		<xsl:if test="error/node()">
			<div class="alert alert-danger">
				<xsl:value-of disable-output-escaping="yes" select="error"/>
			</div>
		</xsl:if>

		<script type="text/javascript">
			<xsl:comment>
				<xsl:text disable-output-escaping="yes">
					<![CDATA[
					$(document).ready(function() {
					$("#new_message").bbedit({lang: 'ru'});

					$("#form_add_post").validate({
					focusInvalid: true,
					errorClass: "input_error"
					});
					});

					function Reply(title)
					{
					$("#post_title")
					.val("Re: "+title.replace("&amp;quot;","\""))
					.focus();
					}

					function GetSelection()
					{
					if (window.getSelection)
					{
					selectedtext = window.getSelection().toString();
					}
					else if (document.getSelection)
					{
					selectedtext = document.getSelection();
					}
					else if (document.selection)
					{
					selectedtext = document.selection.createRange().text;
					}
					}

					function Quote(author,text)
					{
					$("#new_message")
					.focus()
					.val($("#new_message").val() + "[quote=" + author + "]" + text + "[/quote]");
					}
					]]>
				</xsl:text>
			</xsl:comment>
		</script>

		<span class="breadcrumbs">
			<a href="{url}">Список форумов</a>
			<i class="fa fa-angle-right"></i>
			<a href="{url}{forum_category/@id}/" class="current_page_link">
				<xsl:value-of select="forum_category/name"/>
			</a>
		</span>

		<div style="clear: both; height: 10px"></div>
			<xsl:variable name="path_page"><xsl:choose><xsl:when test="page != 0">/page-<xsl:value-of select="page + 1"/></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable>
		<form id="form_add_post" class="form-horizontal" name="mainform" action="{url}{forum_category/@id}/{forum_topic/@id}{$path_page}/" method="post">
				<!-- Выводим сообщения темы -->
				<xsl:apply-templates select="forum_topic_post"/>

			<!-- Если тема и форум не закрыты -->
			<!--<xsl:if test="$moderator = 1 or not(forum_topic/closed = 1 or forum_category/closed = 1)">-->
				<xsl:if test="forum_topic/allow_add_post = 1">

					<!-- Строка добавления нового сообщения -->
					<div class="add_message_table">
						<div class="form-group">
							<!-- Заголовок темы-->
							<div class="col-xs-3 control-label">Тема:</div>

							<xsl:variable name="post_title"><xsl:choose><xsl:when test="error_post_title/node()"><xsl:value-of select="error_post_title"/></xsl:when><xsl:otherwise>Re: <xsl:value-of select="forum_topic/forum_topic_post/subject" /></xsl:otherwise></xsl:choose></xsl:variable>

							<div class="col-xs-9">
								<input id="post_title" class="form-control" name="post_title" value="{$post_title}" type="text"/>
							</div>
						</div>

						<!-- Якорь -->
						<a name="answer"/>
						<div class="form-group">
							<div class="col-xs-3 control-label"></div>
							<div class="col-xs-9 col-sm-9 col-md-9 col-sm-9">
								<textarea id="new_message" rows="9" name="post_text" class="form-control">
									<xsl:if test="error_post_text/node()"><xsl:value-of select="error_post_text"/></xsl:if>
								</textarea>
							</div>
						</div>

						<!-- Если показывать CAPTCHA -->
						<xsl:if test="not(siteuser/node()) and forum_category/use_captcha = 1">
							<div class="form-group">
								<label for="captcha" class="col-xs-3 control-label">Контрольное число<sup><font color="red">*</font></sup></label>
								<div class="col-xs-3">
									<input type="hidden" name="captcha_id" value="{forum_category/captcha_id}"/>
									<input id="captcha" type="text" name="captcha" size="15" class="form-control required" minlength="4" title="Введите число, которое указано выше."/>
								</div>
								<div class="col-xs-3">
									<div class="captcha">
										<img id="addForumPost" class="captcha" src="/captcha.php?id={forum_category/captcha_id}&amp;height=30&amp;width=100" title="Контрольное число" name="captcha"/>
										<div><img src="/images/refresh.png" /> <span onclick="$('#addForumPost').updateCaptcha('{forum_category/captcha_id}', 30); return false">Показать другое число</span></div>
									</div>
								</div>
							</div>
						</xsl:if>

						<div class="form-group">
							<label for="" class="col-xs-3 control-label"></label>
							<div class="col-xs-9 col-sm-9 col-md-9 col-sm-9">
								<div class="actions">
									<!-- <button class="button btn-cart" type="submit" name="add_post" value="add_post">
										<i class="fa fa-plus-square-o bg-color5"></i>
										<span class="bg-color3">
											<span>Добавить сообщение</span>
										</span>
									</button>-->
									<button class="btn btn-primary" type="submit" name="add_post" value="add_post">Добавить сообщение</button>
								</div>
							</div>
						</div>
					</div>
				</xsl:if>

				<p>
					<!-- Pagination -->
					<xsl:call-template name="for">
						<xsl:with-param name="items_on_page" select="limit"/>
						<xsl:with-param name="current_page" select="page"/>
						<xsl:with-param name="count_items" select="forum_topic/count_posts"/>
						<xsl:with-param name="visible_pages" select="6"/>
					</xsl:call-template>
				</p>
				<div style="clear: both"></div>

				<input type="hidden" name="page_theme" value="{current_page_theme}"/>
				<input type="hidden" name="page_message" value="{current_page_message}"/>
			</form>

		<!--
		Форма идентификации пользователя на сайте или приветствия
		залогинившегося пользователя
		-->
		<xsl:choose>
			<xsl:when test="not(siteuser/node())">
				<div class="row forum-group-title">
					<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 height-48">
						Авторизация
					</div>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="row forum-group-title">
					<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 height-48">
						Добро пожаловать,
						<span class="name_users">
							<xsl:value-of select="siteuser/login" />
						</span>!
					</div>
				</div>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test="error_reg != ''">
			<div class="alert alert-danger">
				<xsl:choose>
					<xsl:when test="error_reg = -1">
						Введен некорректный электронный адрес
					</xsl:when>
					<xsl:when test="error_reg = -2">
						Пользователь с указанным электронным адресом зарегистрирован
						ранее
					</xsl:when>
					<xsl:when test="error_reg = -3">
						Пользователь с указанным логином зарегистрирован ранее
					</xsl:when>
					<xsl:when test="error_reg = -4">
						Заполните, пожалуйста, все обязательные параметры
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>

		<div id="div_form" class="row forum">
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<xsl:choose>
					<xsl:when test="not(siteuser/node())">
						<div class="row forum-autorization">
							<div class="col-xs-12 col-sm-7 col-md-6 col-lg-5">
								<input id="rad1" type="radio" name="autoriz" value="reg_user" onclick="HideShow('new', 'auto')">
									<xsl:if test="not(/forum/quick/node() and /forum/quick='quick')">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<label for="rad1" id="lab1">Зарегистрированный пользователь</label>
							</div>
							<div class="col-xs-12 col-sm-5 col-md-6 col-lg-4">
								<input id="rad2" type="radio" name="autoriz" value="new_user" onclick="HideShow('auto', 'new')">
									<xsl:if test="/forum/quick/node() and /forum/quick='quick'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<label for="rad2" id="lab2">Новый пользователь</label>
							</div>
						</div>

						<div id="auto">
							<form class="form-inline" name="mainform" action="/users/" method="post">
								<div class="row">
									<div class="col-xs-12 col-sm-6 col-md-4 col-lg-4">
										Логин:
										<input name="login" type="text" size="12" value="" class="form-control" placeholder="Логин"/>
									</div>
									<div class="col-xs-12 col-sm-6 col-md-4 col-lg-4">
										Пароль:
										<input name="password" type="password" size="12" value="" class="form-control" placeholder="Пароль"/><xsl:text> </xsl:text>
									</div>
									<div class="col-xs-12 col-sm-12 col-md-4 col-lg-4">
										<div class="actions forum-button">
											<button class="btn btn-primary" title="Enter" type="submit" name="apply" value="apply">Войти</button>
										</div>

										<input type="hidden" name="location" value="{url}" />
									</div>
								</div>
							</form>
						</div>

						<div id="new" style="display: none; margin-left: 0px">
							<div class="comment no-background">
								<form class="form-horizontal" name="mainform1" action="/users/registration/" method="post">
									<div class="form-group">
										<div class="col-xs-3 control-label">Логин<sup><font color="red">*</font></sup></div>
										<div class="col-xs-9"><input class="form-control" type="text" size="40" value="" name="login" /></div>
									</div>
									<div class="form-group">
										<div class="col-xs-3 control-label">Пароль<sup><font color="red">*</font></sup></div>
										<div class="col-xs-9"><input class="form-control" type="password" size="40" value="" name="password"/></div>
									</div>
									<div class="form-group">
										<div class="col-xs-3 control-label">E-mail<sup><font color="red">*</font></sup></div>
										<div class="col-xs-9"><input class="form-control" type="text" size="40" value="" name="email" /></div>
									</div>


									<div class="form-group">
										<label for="captcha" class="col-xs-3 control-label">Контрольное число<sup><font color="red">*</font></sup></label>
										<div class="col-xs-3">
											<input type="hidden" name="captcha_id" value="{captcha_id}"/>
											<input id="captcha" type="text" name="captcha" size="15" class="form-control required" minlength="4" title="Введите число, которое указано выше."/>
										</div>
										<div class="col-xs-3">
											<img name="captcha" title="Контрольное число" src="/captcha.php?id={captcha_id}&amp;height=30&amp;width=100" class="captcha" id="registerUser"/>
											<div class="captcha">
												<img src="/images/refresh.png" />
												<span onclick="$('#registerUser').updateCaptcha('{captcha_id}', 30); return false">Показать другое число</span>
											</div>
										</div>
									</div>

									<div class="form-group">
										<label for="" class="col-xs-12 col-sm-12 col-md-3 col-sm-3 control-label"></label>
										<div class="col-xs-12 col-sm-12 col-md-9 col-sm-9">
											<div class="actions forum-button">
												<button class="button btn-cart" type="submit" name="apply" value="apply">
													<i class="fa fa-plus-square-o bg-color5"></i>
													<span class="bg-color3">
														<span>Зарегистрироваться</span>
													</span>
												</button>
											</div>
										</div>
									</div>
								</form>
							</div>
						</div>
						<xsl:choose>
							<xsl:when test="/forum/quick/node() and /forum/quick='quick'">
								<SCRIPT>
									<xsl:comment>
										<xsl:text disable-output-escaping="yes">
											<![CDATA[
											HideShow('auto', 'new');
											]]>
										</xsl:text>
									</xsl:comment>
								</SCRIPT>
							</xsl:when>
							<xsl:otherwise>
								<SCRIPT>
									<xsl:comment>
										<xsl:text disable-output-escaping="yes">
											<![CDATA[
											HideShow('new', 'auto');
											]]>
										</xsl:text>
									</xsl:comment>
								</SCRIPT>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<div align="center">
							<a href="/users/">Кабинет пользователя</a>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
		</xsl:template>

		<!-- Post Template -->
		<xsl:template match="forum_topic_post">
			<xsl:variable name="current_siteuser_id"><xsl:choose><xsl:when test="/forum/siteuser/node()"><xsl:value-of select="/forum/siteuser/@id"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>

			<xsl:variable name="moderator">
				<xsl:choose><xsl:when test = "/forum/forum_category/moderators/siteuser/node()">
						<!-- Поле действий для модератора -->
				<xsl:choose><xsl:when test="/forum/forum_category/moderators//siteuser[@id = $current_siteuser_id]/node()">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>
				</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>

				<xsl:variable name="current_page" select="/forum/page + 1"/>
				<div class="row forum-message">
					<!-- Аватар с правой стороны -->
					<div class="col-xs-3">
						<xsl:text> </xsl:text>

						<!-- Действия с открытым форумом -->
						<xsl:if test="$moderator = 1 or not(../forum_topic/closed = 1 or ../forum_category/closed = 1)">
							<div class="row forum-actions">
							<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<a href="#{@id}">#</a><xsl:text>	</xsl:text>
							<!-- Для модераторов -->
							<xsl:if test="allow_edit = 1">
								<a href="{/forum/url}{/forum/forum_category/@id}/{/forum/forum_topic/@id}/editPost-{@id}/page-{$current_page}/"><i class="fa fa-pencil" title="Редактировать"></i></a>
							</xsl:if>

							<xsl:if test="allow_delete = 1">
								<!-- Если это первое сообщение темы, то при его удалении удаляется вся тема целиком -->
								<xsl:choose>
									<xsl:when test="../forum_topic/forum_topic_post/@id = @id">
										<a href="{/forum/url}{/forum/category}/?delete_topic_id={../forum_topic/@id}" onclick="return confirm('Вы уверены, что хотите удалить тему?')"><i class="fa fa-times-circle" title="Удалить"></i></a>
									</xsl:when>
									<xsl:otherwise>
										<a href="?del_post_id={@id}" onclick="return confirm('Вы уверены, что хотите удалить сообщение?')"><i class="fa fa-times-circle" title="Удалить"></i></a>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>

							<!-- Кнопка ответить формирует тему для создаваемого сообщения -->
							<xsl:if test="../forum_topic/allow_add_post = 1">
								<a href="#answer"><i class="fa fa-reply" title="Ответить"></i></a>
							</xsl:if>

							<xsl:if test="position() = 1 and $current_siteuser_id != 0">
								<!-- Кнопка подписки на рассылку сообщений темы -->
								<xsl:choose>
									<xsl:when test="../forum_topic/subscribed/node() and ../forum_topic/subscribed = 1">
										<a href="./?action=topic_unsubscribe"><i class="fa fa-check-square-o" title="Отменить подписку"></i></a>
									</xsl:when>
									<xsl:otherwise>
										<a href="./?action=topic_subscribe"><i class="fa fa-share-square-o" title="Подписаться"></i></a>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							</div>
							</div>
						</xsl:if>

					<xsl:choose>
						<xsl:when test="siteuser/login/node()">
							<!-- Аватар автора -->
							<div class="avatar">
								<xsl:choose>
									<xsl:when test="siteuser/property_value[tag_name = 'avatar']/file != '' ">
										<!-- Аватр есть, выводим его -->
										<img src="{siteuser/dir}{siteuser/property_value[tag_name = 'avatar']/file}" />
									</xsl:when>
									<xsl:otherwise>
										<!-- Аватара нет, выводим заглушку -->
										<img src="/hostcmsfiles/forum/avatar.gif" />
									</xsl:otherwise>
								</xsl:choose>
							</div>

							<!-- Имя автора -->
							<span class="author_name">
								<xsl:value-of select="siteuser/login"/>
							</span>
							<br/>
							<!-- Идентификатор автора поста -->
							<xsl:variable name="post_author_id"><xsl:value-of select="siteuser_id"/></xsl:variable>

							<xsl:variable name="post_author_is_moderator"><xsl:choose><xsl:when test = "/forum/forum_category/moderators/siteuser/node()"><xsl:choose><xsl:when test="/forum/forum_category/moderators//siteuser[@id = $post_author_id]/node()">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>

							<!-- Звание автора -->
							<xsl:if test="$post_author_is_moderator = 1">
								<span class="message_author_status">Модератор</span>
							</xsl:if>

							<!-- Дата регистрации -->
							<br/>
							<span class="forum-date">
								Сообщений: <span><xsl:value-of select="siteuser/property_value[tag_name = 'count_message']/value"/></span>
								<br/>
								Регистрация: <span><xsl:value-of select="siteuser/date"/></span>
							</span>

						</xsl:when>
						<xsl:otherwise>
							<!-- Если автор не был дерегистрирован на сайте,
							то сообщение помечается как созданное гостем -->
							<!-- Аватара нет, выводим заглушку -->
							<div class="avatar">
								<img src="/hostcmsfiles/forum/avatar.gif"/>
							</div>

							<span class="author_name">
								Гость
							</span>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="not(../forum_topic/closed = 1 or ../forum_category/closed = 1)">
						<xsl:variable name="quote_login">
							<xsl:choose>
								<xsl:when test="siteuser/login/node()"><xsl:value-of select="siteuser/login"/></xsl:when>
								<xsl:otherwise>Гость</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<span class="forum-date">
							<br/>
							<span class="selectedquote" onmouseover="GetSelection()" onclick="Quote('{$quote_login}',selectedtext)">[Цитировать выделенное]</span>
						</span>
					</xsl:if>
					</div>

				<!-- Если вдруг автор сообщения дерегистрирован, то выравниваем высоту строки сообщения -->
				<div class="col-xs-9">
					<div class="row">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<!-- Тема сообщения -->							
							<div class="title-messages">
								<a name="{@id}"></a>
								<xsl:value-of select="subject"/>
							</div>
						</div>
					</div>
					<div class="row" style="padding-top: 15px;">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<span class="text-messages"><xsl:value-of disable-output-escaping="yes" select="text"/></span>
						</div>
					</div>
					<div class="row">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<xsl:if test="siteuser/property_value[tag_name = 'signature']/value/node()
								and siteuser/property_value[tag_name = 'signature']/value != ''">
								<div class="forum_message_signature">
									<hr width="100%"/>
									<span><xsl:value-of select="siteuser/property_value[tag_name = 'signature']/value"/></span>
								</div>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</xsl:template>

		<!-- Pagination -->
		<xsl:template name="for">
			<xsl:param name="i" select="0"/>
			<xsl:param name="items_on_page"/>
			<xsl:param name="current_page"/>
			<xsl:param name="count_items"/>
			<xsl:param name="visible_pages"/>

			<xsl:variable name="n" select="$count_items div $items_on_page"/>

			<!-- Current page link -->
			<xsl:variable name="link">
				<xsl:value-of select="/forum/url"/>
				<xsl:value-of select="/forum/forum_category/@id"/>/<xsl:value-of select="/forum/forum_topic/@id"/>/</xsl:variable>

			<!-- Links before current -->
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

			<!-- Links after current -->
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


			<xsl:if test="$count_items &gt; $items_on_page and $n &gt; $i">

				<!-- Pagination item -->
				<xsl:if test="$i != $current_page">

					<!-- Set $link variable -->
					<xsl:variable name="number_link">
						<xsl:choose>

							<xsl:when test="$i != 0">page-<xsl:value-of select="$i + 1"/>/</xsl:when>

							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<!-- First pagination item -->
					<xsl:if test="$current_page - $pre_count_page &gt; 0 and $i = 0">
						<a href="{$link}" class="page_link" style="text-decoration: none;">←</a>
					</xsl:if>

					<xsl:choose>
						<xsl:when test="$i &gt;= ($current_page - $pre_count_page) and ($current_page + $post_count_page) &gt;= $i">
							<!-- Pagination item -->
							<a href="{$link}{$number_link}" class="page_link">
								<xsl:value-of select="$i + 1"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>

					<!-- Last pagination item -->
					<xsl:if test="$i+1 &gt;= $n and $n &gt; ($current_page + 1 + $post_count_page)">
						<xsl:choose>
							<xsl:when test="$n &gt; round($n)">
								<!-- Last pagination item -->
								<a href="{$link}page-{round($n+1)}/" class="page_link" style="text-decoration: none;">→</a>
							</xsl:when>
							<xsl:otherwise>
								<a href="{$link}page-{round($n)}/" class="page_link" style="text-decoration: none;">→</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>

				<!-- Current pagination item -->
				<xsl:if test="$i = $current_page">
					<span class="current">
						<xsl:value-of select="$i+1"/>
					</span>
				</xsl:if>

				<!-- Recursive Template -->
				<xsl:call-template name="for">
					<xsl:with-param name="i" select="$i + 1"/>
					<xsl:with-param name="items_on_page" select="$items_on_page"/>
					<xsl:with-param name="current_page" select="$current_page"/>
					<xsl:with-param name="count_items" select="$count_items"/>
					<xsl:with-param name="visible_pages" select="$visible_pages"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:template>

	</xsl:stylesheet>