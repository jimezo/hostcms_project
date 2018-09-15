<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:template match="/siteuser">

		<!-- Быстрая регистрация в магазине -->
		<xsl:if test="fastRegistration/node()">
			<div id="fastRegistrationDescription" style="float: left">
				<h1 class="item_title">Быстрая регистрация</h1>
				<b>Какие преимущества дает регистрация на сайте?</b>

				<ul class="ul1">
					<li id="message">Вы получаете возможность оформлять заказы прямо на сайте.</li>
					<li id="message">Вы будете получать информацию о специальных акциях магазина, доступных только зарегистрированным пользователям.</li>
				</ul>

				<p>
					<a class="user-button user-button-red" href="/users/registration/" onclick="$('#fastRegistrationDescription').hide('slow'); $('#fastRegistration').show('slow'); return false">
						Заполнить форму регистрации
						<!-- <div class="actions item-margin-left">
							<button class="button btn-cart" type="submit" name="add_comment">
								<i class="fa fa-share bg-color5"></i>
								<span class="bg-color3">
									<span>Заполнить форму регистрации</span>
								</span>
							</button>
						</div>-->
					</a>
				</p>
			</div>
		</xsl:if>

		<div>
			<xsl:if test="fastRegistration/node()">
				<xsl:attribute name="id">fastRegistration</xsl:attribute>
			</xsl:if>

			<h1 class="item_title"><xsl:choose>
					<xsl:when test="@id > 0">Анкетные данные</xsl:when>
					<xsl:otherwise>Регистрация нового пользователя</xsl:otherwise>
			</xsl:choose></h1>

			<!-- Show Error -->
			<xsl:if test="error/node()">
				<div class="alert alert-danger">
					<xsl:value-of select="error"/>
				</div>
			</xsl:if>

			<p id="message">Обратите внимание, введенные контактные данные будут доступны на странице пользователя
				неограниченному кругу лиц.
				<br />Обязательные поля отмечены *.</p>

			<div class="comment no-background">
				<form action="/users/registration/" method="post" class="form-horizontal" enctype="multipart/form-data">
					<div class="form-group">
						<label for="captcha" class="col-xs-12 col-sm-3 control-label">Логин<sup><font color="red">*</font></sup></label>
						<div class="col-xs-12 col-sm-9">
							<input name="login" type="text" class="form-control" value="{login}" size="35"/>
						</div>
					</div>

					<div class="form-group">
						<label for="captcha" class="col-xs-12 col-sm-3 control-label">Пароль<xsl:if test="@id = 0"><sup><font color="red">*</font></sup></xsl:if></label>
						<div class="col-xs-12 col-sm-9">
							<input name="password" type="password" class="form-control" value="" size="35"/>
						</div>
					</div>
					<div class="form-group">
						<label for="captcha" class="col-xs-12 col-sm-3 control-label">E-mail<sup><font color="red">*</font></sup></label>
						<div class="col-xs-12 col-sm-9">
							<input name="email" type="text" class="form-control" value="{email}" size="35"/>
						</div>
					</div>
					<div class="form-group">
						<label for="captcha" class="col-xs-12 col-sm-3 control-label">Имя</label>
						<div class="col-xs-12 col-sm-9">
							<input name="name" type="text" class="form-control" value="{name}" size="35"/>
						</div>
					</div>
					<div class="form-group">
						<label for="captcha" class="col-xs-12 col-sm-3 control-label">Фамилия</label>
						<div class="col-xs-12 col-sm-9">
							<input name="surname" type="text" class="form-control" value="{surname}" size="35"/>
						</div>
					</div>

					<xsl:if test="not(/siteuser/@id > 0)">
						<div class="form-group">
							<label for="captcha" class="col-xs-12 col-sm-3 control-label">Контрольное число<sup><font color="red">*</font></sup></label>
							<div class="col-xs-12 col-sm-3">
								<input type="hidden" name="captcha_id" value="{/siteuser/captcha_id}"/>
								<input id="captcha" type="text" name="captcha" size="15" class="form-control required" minlength="4" title="Введите число, которое указано выше."/>
							</div>
							<div class="col-xs-12 col-sm-3">
								<img id="registerUser" class="captcha" src="/captcha.php?id={/siteuser/captcha_id}&amp;height=30&amp;width=100" title="Контрольное число" name="captcha"/>

								<div class="captcha">
									<img src="/images/refresh.png" /> <span onclick="$('#registerUser').updateCaptcha('{/siteuser/captcha_id}', 30); return false">Показать другое число</span>
								</div>
							</div>
						</div>
					</xsl:if>

					<!-- Page Redirect after login -->
					<xsl:if test="location/node()">
						<input name="location" type="hidden" value="{location}" />
					</xsl:if>

					<!-- Определяем имя кнопки -->
					<xsl:variable name="buttonName"><xsl:choose>
							<xsl:when test="@id > 0">Изменить</xsl:when>
							<xsl:otherwise>Зарегистрироваться</xsl:otherwise>
					</xsl:choose></xsl:variable>

					<div class="form-group">
						<label for="captcha" class="col-xs-12 col-sm-3 control-label"></label>
						<div class="col-xs-12 col-sm-9">
							<button class="user-button" type="submit" name="apply" value="apply"><xsl:value-of select="$buttonName"/></button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>