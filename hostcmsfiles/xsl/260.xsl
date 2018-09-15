<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8"
		indent="yes" method="html" omit-xml-declaration="no" version="1.0"
		media-type="text/xml" />
	
	<xsl:template match="/forum">
		<h1>Форумы</h1>
		<xsl:if test="error != ''">
			<div class="alert alert-danger">
				<xsl:value-of disable-output-escaping="yes" select="error" />
			</div>
		</xsl:if>
		
		<xsl:if test = "siteuser/node()">
			<div class="row">
				<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" style="float: right">
					<a href="{url}myPosts/">
						<div class="actions forum-button">
							<button class="btn btn-primary" title="myPosts" type="submit" name="myPosts" value="myPosts">Мои сообщения</button>
						</div>
					</a>
				</div>
			</div>
		</xsl:if>
		
		<xsl:apply-templates select="forum_group" />
		
		<xsl:if test="last_siteuser/siteuser/node()">
			<div class="row forum-group-title">
				<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 height-48">
					Статистика
				</div>
			</div>
			<div class="row forum stat">
				<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<span>
						<xsl:text>Всего тем: </xsl:text>
						<xsl:value-of select="total_topics" />
						<xsl:text> • </xsl:text>
					</span>
					<span>
						<xsl:text>Всего сообщений: </xsl:text>
						<xsl:value-of select="total_topic_posts" />
						<xsl:text> • </xsl:text>
					</span>
					<span>
						<xsl:text>Всего пользователей: </xsl:text>
						<xsl:value-of select="total_siteusers" />
						<xsl:text> • </xsl:text>
					</span>
					<span>
						<xsl:text>Последний зарегистрированный пользователь: </xsl:text>
						<a href="/users/info/{last_siteuser/siteuser/login}/">
							<xsl:value-of select="last_siteuser/siteuser/login" />
						</a>
					</span>
				</div>
			</div>
		</xsl:if>
		
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
												<button class="btn btn-primary" type="submit" name="apply" value="apply">Зарегистрироваться</button>
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
	
	<!-- Форумы -->
	<xsl:template match="forum_category">
		<!-- Шаблон для вывода строки форума -->
		<xsl:param name="group_id" select="0" />
		<div class="row forum">
			<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1 padding-top-10 flag">
				<!-- Атрибуты форума -->
				<xsl:if test="closed=1 and new_posts=1">
					<!-- <img src="/hostcmsfiles/forum/forum_locked_new.gif" title="Закрытый форум с новыми сообщениями"
					alt="X+"></img>-->
					<i class="fa fa-lock" title="Закрытый форум с новыми сообщениями"></i>
				</xsl:if>
				<xsl:if test="closed=1 and new_posts=0">
					<!-- <img src="/hostcmsfiles/forum/forum_locked.gif" title="Закрытый форум без новых сообщений"
					alt="X-"></img>-->
					<i class="fa fa-lock" title="Закрытый форум без новых сообщений"></i>
				</xsl:if>
				<xsl:if test="closed=0 and new_posts=1">
					<!-- <img src="/hostcmsfiles/forum/forum_new.gif" title="Открытый форум с новыми сообщениями"
					alt="O+"></img> -->
					<i class="fa fa-file-text-o" title="Открытый форум с новыми сообщениями"></i>
				</xsl:if>
				<xsl:if test="closed=0 and new_posts=0">
					<!-- <img src="/hostcmsfiles/forum/forum.gif" title="Открытый форум без новых сообщений"
					alt="O-"></img>-->
					<i class="fa fa-file-o" title="Открытый форум без новых сообщений"></i>
				</xsl:if>
			</div>
			
			<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
				<!-- Название и описание форума -->
				<span class="forum-title">
					<a href="{/forum/url}{@id}/">
						<xsl:value-of select="name" />
					</a>
				</span>
				<br />
				<span class="forum-desc">
					<xsl:value-of select="description" />
				</span>
			</div>
			
			<div class="col-xs-3 padding-top-10">
				<xsl:choose>
					<xsl:when test="forum_topic/node()">
						<!-- Длина названия темы -->
						<xsl:variable name="lenght_theme_name" select="string-length(forum_topic/last/forum_topic_post/subject)"/>
						
						<!-- Формируем название темы -->
						<xsl:variable name="total_theme_name"><xsl:choose>
								<!-- Длина названия темы больше 30 символов -->
								<xsl:when test="$lenght_theme_name > 50">
									<!-- Получаем первые 30 символов названия темы -->
									<xsl:variable name="theme_name_30" select="substring(forum_topic/last/forum_topic_post/subject, 1, 30)" />
									
									<!-- Получаем подстроку из названия темы начиная с 30 символа до первого пробела -->
									<xsl:variable name="theme_name_appendix" select="substring-before(substring(forum_topic/last/forum_topic_post/subject, 31), ' ')" />
									
									<!-- После 30 символа в названиии темы отсутствуют пробелы -->
									<xsl:choose>
										<xsl:when test="string-length($theme_name_appendix) = 0">
											<xsl:value-of select="substring(forum_topic/last/forum_topic_post/subject, 0, 50)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$theme_name_30"/> <xsl:value-of select="$theme_name_appendix"/>
										</xsl:otherwise>
									</xsl:choose>
									
									<xsl:if test="$lenght_theme_name > 50">...</xsl:if>
									
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="forum_topic/last/forum_topic_post/subject"/></xsl:otherwise>
						</xsl:choose></xsl:variable>
						
						
					<!-- <strong><a href="{/forum/url}{@id}/{forum_topic/@id}/"><xsl:value-of select="$total_theme_name" /></a></strong>
						<br />-->
				от<xsl:text> </xsl:text><!-- <img src="/hostcmsfiles/images/user.gif" style="margin: 0px 5px -4px 0px;"/><i class="fa fa-user"></i>-->
						
						<!-- Автор последнего сообщения -->
						<xsl:choose>
							<xsl:when test="not(forum_topic/last/forum_topic_post/siteuser/login/node())">
								Гость
							</xsl:when>
							<xsl:otherwise>
								<a href="/users/info/{forum_topic/last/forum_topic_post/siteuser/login}/"><xsl:value-of select="forum_topic/last/forum_topic_post/siteuser/login" /></a>
							</xsl:otherwise>
						</xsl:choose>
						
				<xsl:text> </xsl:text><a href="{/forum/url}{@id}/{forum_topic/@id}/"><i class="fa fa-chevron-circle-right"></i></a>
						
						<!-- Дата последнего сообщения -->
						<br /><span class="forum-date"><xsl:value-of select="forum_topic/last/forum_topic_post/datetime" /></span>
					</xsl:when>
					<xsl:otherwise>Нет сообщений</xsl:otherwise>
				</xsl:choose>
			</div>
			
			<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1 padding-top-10">
				<xsl:value-of select="count_topics" />
			</div>
			
			<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 padding-top-10">
				<!-- Количество тем и сообщений в форуме -->
				<xsl:value-of select="count_topic_posts" />
			</div>
		</div>
	</xsl:template>
	
	<!-- Конец шаблона вывода строк форумов -->
	<xsl:template match="forum_group">
		<div class="row forum-group-title">
			<!-- Скрываем/открываем форумы текущей группы -->
			<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1"></div>
			<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
				<!-- Шапка группы форумов -->
				<xsl:value-of select="name" />
				<xsl:if test="description != ''">
					<br />
					<span class="desc-group-forums">
						<xsl:value-of select="description" />
					</span>
				</xsl:if>
			</div>
			<div class="col-xs-3">Последнее сообщение</div>
			<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1">Тем</div>
			<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">Сообщений</div>
		</div>
		<xsl:apply-templates select="forum_category">
			<xsl:with-param name="group_id" select="@id" />
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>