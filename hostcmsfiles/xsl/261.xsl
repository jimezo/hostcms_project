<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="no" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- ТемыФорума -->
	<xsl:template match="/forum">
		<h1 class="item_title">
			<xsl:value-of select="forum_category/name"/>
		</h1>
		<xsl:if test="forum_category/description != ''">
			<!-- Описание форума -->
			<p>
				<span class="forum-desc">
					<xsl:value-of select="forum_category/description"/>
				</span>
			</p>
		</xsl:if>

		<xsl:if test="error != ''">
			<div class="alert alert-danger">
				<xsl:value-of disable-output-escaping="yes" select="error"/>
			</div>
		</xsl:if>

		<span class="breadcrumbs">
			<a href="{url}">Список форумов</a>
			<i class="fa fa-angle-right"></i>
			<a href="{url}{forum_category/@id}/" class="current_page_link">
				<xsl:value-of select="forum_category/name"/>
			</a>
		</span>

		<xsl:variable name="current_siteuser_id"><xsl:choose><xsl:when test="siteuser/node()"><xsl:value-of select="siteuser/@id"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>

		<xsl:variable name="moderator">
		<xsl:choose><xsl:when test = "forum_category/moderators/siteuser/node()">
			<!-- Поле действий для модератора -->
			<xsl:choose><xsl:when test="forum_category/moderators//siteuser[@id = $current_siteuser_id]/node()">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>
		</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>

		<div class="row">
			<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 add-topic">
				<xsl:choose>
					<!-- Для закрытого форума появляется картинка - форум закрыт -->
					<xsl:when test="forum_category/closed = 1 and not($moderator = 1)">
						<span>
							Только модераторы могут создавать темы и оставлять сообщения.
						</span>
					</xsl:when>
					<xsl:when test="forum_category/closed = 0 and not(siteuser/login) and forum_category/allow_guest_posting = 0">
						<span>
							Только зарегистрированные пользователи могут создавать темы и оставлять сообщения.
						</span>
					</xsl:when>
					<!-- Для открытого форума или, если пользователь - модератор, появляется кнопка добавить тему -->
					<xsl:otherwise>
						<a href="{url}{forum_category/@id}/addTopic/">
							<div class="actions forum-button">
								<button class="btn btn-secondary" type="submit" name="addTopic" value="addTopic">Добавить новую тему</button>
							</div>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 add-topic">
				<xsl:if test = "siteuser/node()">
					<a href="{url}myPosts/">
						<div class="actions forum-button">
							<button class="btn btn-primary" title="myPosts" type="submit" name="myPosts" value="myPosts">Мои сообщения</button>
						</div>
					</a>
				</xsl:if>
			</div>
		</div>

		<form action="{url}" method="post">

			<div class="row forum-group-title height-48">
				<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1"></div>
				<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">Тема</div>
				<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">Автор</div>
				<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1">Ответов</div>
				<div class="col-xs-3">Последнее сообщение</div>
			</div>
			<!-- Если есть темы для форума -->
			<xsl:if test="count(forum_topics/forum_topic) > 0">
				<xsl:apply-templates select="forum_topics/forum_topic[($moderator = 1) or (visible = 1)]"/>
			</xsl:if>
		</form>

		<div class="clearing" style="margin-bottom: 10px"></div>

		<nav>
			<ul class="pagination">
			<!-- Pagination -->
			<xsl:call-template name="for">
				<xsl:with-param name="limit" select="limit"/>
				<xsl:with-param name="page" select="page"/>
				<xsl:with-param name="count_items" select="forum_category/count_topics"/>
				<xsl:with-param name="visible_pages" select="6"/>
			</xsl:call-template>
			<div style="clear: both"></div>
			</ul>
		</nav>

		<!-- Список модераторов -->
		<div class="row forum-group-title">
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 height-48">
				Модераторы
			</div>
		</div>
		<div class="row forum moderators">
			<xsl:choose>
				<xsl:when test="count(forum_category/moderators/siteuser) = 0">Нет</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="forum_category/moderators/siteuser"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>

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

	<!-- Строка ссылок в теме -->
	<xsl:template name="pages">
		<xsl:param name="i" select="0"/>
		<xsl:param name="n"/>
		<xsl:param name="current_page"/>
		<xsl:param name="theme_id"/>
		<xsl:if test="$n &gt; $i">
			<!-- Set $link variable -->
			<xsl:choose>
				<!-- Если число страниц меньше 7 и больше 1 -->
				<xsl:when test="7 &gt; $n">
					<xsl:variable name="number_link">
						<xsl:choose>

							<xsl:when test="$i != 0">page-<xsl:value-of select="$i + 1"/>/</xsl:when>

							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<!-- Pagination item -->
					<a href="{/forum/url}{/forum/forum_category/@id}/{$theme_id}/{$number_link}">
						<xsl:value-of select="$i + 1"/>
					</a>
					<xsl:if test="$n - 1 &gt; $i ">,</xsl:if>
					<!-- Recursive Template -->
					<xsl:call-template name="pages">
						<xsl:with-param name="i" select="$i + 1"/>
						<xsl:with-param name="n" select="$n"/>
						<xsl:with-param name="current_page" select="$current_page"/>
						<xsl:with-param name="theme_id" select="$theme_id"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<a href="{/forum/url}{/forum/forum_category/@id}/{$theme_id}/">1</a>,
					<a href="{/forum/url}{/forum/forum_category/@id}/{$theme_id}/page-2/">2</a>,
					<a href="{/forum/url}{/forum/forum_category/@id}/{$theme_id}/page-3/">3</a>...
					<a href="{/forum/url}{/forum/forum_category/@id}/{$theme_id}/page-{$n - 2}/">
						<xsl:value-of select="$n - 2"/>
					</a>,
					<a href="{/forum/url}{/forum/forum_category/@id}/{$theme_id}/page-{$n - 1}/">
						<xsl:value-of select="$n - 1"/>
					</a>,
					<a href="{/forum/url}{/forum/forum_category/@id}/{$theme_id}/page-{$n}/">
						<xsl:value-of select="$n"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<!-- Шаблон вывода модераторов через запятую -->
	<xsl:template match="forum_category/moderators/siteuser">
		<a href="/users/info/{login}/"><xsl:value-of select="login"/></a>
		<xsl:choose>
			<xsl:when test="position() != last()">, </xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Шаблон вывода строк тем -->
	<xsl:template match="forum_topics/forum_topic">
		<div class="row forum">
		<xsl:variable name="current_siteuser_id"><xsl:choose><xsl:when test="/forum/siteuser/node()"><xsl:value-of select="/forum/siteuser/@id"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>

		<xsl:variable name="moderator">
		<xsl:choose><xsl:when test = "/forum/forum_category/moderators/siteuser/node()">
			<!-- Поле действий для модератора -->
			<xsl:choose><xsl:when test="/forum/forum_category/moderators//siteuser[@id = $current_siteuser_id]/node()">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>
		</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>


		<xsl:if test="($moderator = 1) or (visible = 1)">
				<!-- Атрибуты темы -->
				<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1 padding-top-10 flag text-align-center">
					<xsl:if test="closed = 1 and announcement = 0 and new_posts = 1">
						<i class="fa fa-lock" title="Закрытая тема с непрочитанными сообщениями"></i>
					</xsl:if>
					<xsl:if test="closed = 1 and announcement = 0 and new_posts = 0">
						<i class="fa fa-lock" title="Закрытая тема без непрочитанных сообщений"></i>
					</xsl:if>
					<xsl:if test="closed = 0 and announcement = 1 and new_posts = 1">
						<i class="fa fa-volume-up" title="Открытое объявление с непрочитанными сообщениями"></i>
					</xsl:if>
					<xsl:if test="closed = 0 and announcement = 1 and new_posts = 0">
						<i class="fa fa-volume-off" title="Открытое объявление без непрочитанных сообщений"></i>
					</xsl:if>
					<xsl:if test="closed = 1 and announcement = 1 and new_posts = 1">
						<i class="fa fa-lock" title="Закрытое объявление с непрочитанными сообщениями"></i>
					</xsl:if>
					<xsl:if test="closed = 1 and announcement = 1 and new_posts = 0">
						<i class="fa fa-lock" title="Закрытое объявление без непрочитанных сообщений"></i>
					</xsl:if>
					<xsl:if test="closed = 0 and announcement = 0 and new_posts = 1">
						<i class="fa fa-file-text-o" title="Тема с непрочитанными сообщениями"></i>
					</xsl:if>
					<xsl:if test="closed = 0 and announcement = 0 and new_posts = 0">
						<i class="fa fa-file-o" title="Тема без непрочитанных сообщений"></i>
					</xsl:if>
				</div>

				<!-- Если тема - объявление, выводим жирным -->
				<xsl:variable name="style_theme_name">
					<xsl:choose>
						<xsl:when test="announcement = 1">font-weight: bold</xsl:when>
						<!-- Закрытая тема выводится зачеркнутым -->
						<xsl:when test="closed = 1">text-decoration: line-through</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- Topic Subject -->
				<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5" style="padding-top:10px;">
					<span class="forum-title">
						<a href="{/forum/url}{/forum/category}/{@id}/" style="{$style_theme_name}">
							<xsl:value-of select="forum_topic_post/subject"/>
						</a>
					</span>
				</div>

				<!-- Число страниц с ответами темы -->
				<xsl:variable name="count_message_page" select="ceiling((count_posts) div /forum/posts_on_page)"/>

				<xsl:choose>
					<!-- Если число больше 1 -->
					<xsl:when test="$count_message_page &gt; 1">(<xsl:call-template name="pages">
							<xsl:with-param name="n" select="$count_message_page"/>
							<xsl:with-param name="current_page" select="0"/>
						<xsl:with-param name="theme_id" select="@id"/></xsl:call-template>)</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>

				<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 text-align-center">
					<xsl:choose>
						<xsl:when test="forum_topic_post/siteuser/login/node()">
							<a href="/users/info/{forum_topic_post/siteuser/login}/"><xsl:value-of select="forum_topic_post/siteuser/login"/></a>
						</xsl:when>
						<xsl:otherwise>Гость</xsl:otherwise>
					</xsl:choose>

					<!-- Дата создания темы -->
					<br/>
					<span class="forum-date"><xsl:value-of select="forum_topic_post/datetime"/></span>
				</div>

				<!-- Количество ответов в теме -->
				<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1 text-align-center" style="padding-top:10px;">
					<xsl:value-of select="count_posts - 1"/>
				</div>

				<!-- Последнее сообщение в теме -->
				<div class="col-xs-3 text-align-center">
					<!-- Автор последнего сообщения -->
					<xsl:choose>
						<xsl:when test="last/forum_topic_post/siteuser/login/node()">
							<a href="/users/info/{last/forum_topic_post/siteuser/login}/"><xsl:value-of select="last/forum_topic_post/siteuser/login"/></a>
						</xsl:when>
						<xsl:otherwise>Гость</xsl:otherwise>
					</xsl:choose>

					<!-- Дата последнего сообщения -->
					<br/><span class="forum-date"><xsl:value-of select="last/forum_topic_post/datetime"/></span>
				</div>

				<xsl:if test="$moderator = 1">
					<div class="row forum-actions">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<span>Действия: </span>
							<!-- Действия над темой доступны лишь модераторам форума -->
							<xsl:choose>
								<!-- Видимость темы -->
								<xsl:when test="visible = 0"><a href="?visible_topic_id={@id}"><i class="fa fa-lightbulb-o" title="Сделать видимой"></i></a> </xsl:when>
								<xsl:otherwise><a href="?visible_topic_id={@id}"><i class="fa fa-lightbulb-o" title="Сделать невидимой"></i></a> </xsl:otherwise>
							</xsl:choose>

							<!-- Объявление -->
							<xsl:choose>
								<xsl:when test="announcement = 0"><a href="?notice_topic_id={@id}"><i class="fa fa-bell-o" title="Сделать объявлением"></i></a> </xsl:when>
								<xsl:otherwise><a href="?notice_topic_id={@id}"><i class="fa fa-bell-slash-o" title="Сделать обычной темой"></i></a> </xsl:otherwise>
							</xsl:choose>

							<!-- Закрыть/открыть -->
							<xsl:choose>
								<xsl:when test="closed = 0"><a href="?close_topic_id={@id}"><i class="fa fa-minus-circle" title="Закрыть"></i></a> </xsl:when>
								<xsl:otherwise><a href="?close_topic_id={@id}"><i class="fa fa-plus-circle" title="Открыть"></i></a> </xsl:otherwise>
							</xsl:choose>

							<xsl:variable name="current_page">
								<xsl:choose><xsl:when test="/forum/page > 0">page-<xsl:value-of select="/forum/page + 1" />/</xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose>
							</xsl:variable>

							<!-- Редактировать -->
							<a href="{/forum/url}{/forum/forum_category/@id}/editTopic-{@id}/{$current_page}"><i class="fa fa-pencil" title="Редактировать"></i></a> 

							<!-- Удалить -->
							<a href="?delete_topic_id={@id}" onclick="return confirm('Вы уверены, что хотите удалить тему?')"><i class="fa fa-times-circle" title="Удалить"></i></a>
						</div>
					</div>
				</xsl:if>
		</xsl:if>
		</div>
	</xsl:template>

	<!-- Pagination -->
	<xsl:template name="for">
		<xsl:param name="i" select="0"/>
		<xsl:param name="limit"/>
		<xsl:param name="page"/>
		<xsl:param name="count_items"/>
		<xsl:param name="visible_pages"/>

		<!-- <xsl:variable name="n" select="$count_items div $limit"/> -->
		<xsl:variable name="n" select="ceiling($count_items div $limit)"/>

		<!-- Current page link -->
		<xsl:variable name="link">
			<xsl:value-of select="/forum/url"/>
			<xsl:value-of select="/forum/forum_category/@id"/>/</xsl:variable>

		<!-- Links before current -->
		<xsl:variable name="pre_count_page">
			<xsl:choose>
				<xsl:when test="$page &gt; ($n - (round($visible_pages div 2) - 1))">
					<xsl:value-of select="$visible_pages - ($n - $page)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="round($visible_pages div 2) - 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Links after current -->
		<xsl:variable name="post_count_page">
			<xsl:choose>
				<xsl:when test="0 &gt; $page - (round($visible_pages div 2) - 1)">
					<xsl:value-of select="$visible_pages - $page - 1"/>
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

		<xsl:if test="$count_items &gt; $limit and $n &gt; $i">
			<!-- Pagination item -->
			<xsl:if test="$i != $page">

				<!-- Set $link variable -->
				<xsl:variable name="number_link">
					<xsl:choose>

						<xsl:when test="$i != 0">page-<xsl:value-of select="$i + 1"/>/</xsl:when>

						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- First pagination item -->
				<xsl:if test="$page - $pre_count_page &gt; 0 and $i = 0">
					<li>
						<a href="{$link}" class="page_link" style="text-decoration: none;">←</a>
					</li>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="$i &gt;= ($page - $pre_count_page) and ($page + $post_count_page) &gt;= $i">
						<li>
							<!-- Pagination item -->
							<a href="{$link}{$number_link}" class="page_link">
								<xsl:value-of select="$i + 1"/>
							</a>
						</li>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>

				<!-- Last pagination item -->
				<xsl:if test="$i+1 &gt;= $n and $n &gt; ($page + 1 + $post_count_page)">
					<xsl:choose>
						<xsl:when test="$n &gt; round($n)">
							<li>
								<!-- Last pagination item -->
								<a href="{$link}page-{round($n+1)}/" class="page_link" style="text-decoration: none;">→</a>
							</li>
						</xsl:when>
						<xsl:otherwise>
							<li>
								<a href="{$link}page-{round($n)}/" class="page_link" style="text-decoration: none;">→</a>
							</li>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
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
				<xsl:with-param name="count_items" select="$count_items"/>
				<xsl:with-param name="visible_pages" select="$visible_pages"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>