<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/siteuser">

		<xsl:choose>
			<!-- Authorized User -->
			<xsl:when test="@id > 0">
				<div class="container">
					<xsl:variable name="username">
						<xsl:choose>
							<xsl:when test="name != ''">
								<xsl:value-of select="name"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="login"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<div class="row">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-10">
							<h1>Здравствуйте, <span class="highlight"><xsl:value-of select="$username"/></span>, добро пожаловать в личный кабинет.</h1>
						</div>
					</div>

					<!-- Personal Data -->
					<div class="row user-data margin-bottom-30">
						<div class="col-xs-12 col-md-6">
							<div class="row user-data">
								<div class="col-xs-12">
									<h2 class="social-title">Личные данные</h2>
									<hr/>
								</div>
								<div class="col-xs-12">
									<div class="row">
										<div class="col-xs-12 col-md-3 col-lg-6 text-align-center">
											<xsl:if test="property_value[tag_name='avatar']/file !=''">
												<img src="{dir}{property_value[tag_name='avatar']/file}" />
											</xsl:if>
										</div>
										<div class="col-xs-12 col-md-9 col-lg-6">
											<div class="row text-align-right">
												<div class="col-xs-12 margin-bottom-20">
													<xsl:if test="name != '' and surname != ''">
														<xsl:value-of select="name"/><xsl:text> </xsl:text><xsl:value-of select="surname"/><br/>
													</xsl:if>
													<xsl:if test="email != ''">
														<xsl:value-of select="email"/><br/>
													</xsl:if>
													<xsl:if test="phone != ''">
														<xsl:value-of select="phone"/><br/>
													</xsl:if>
												</div>
												<div class="col-xs-12">
													<a class="btn btn-secondary" href="/users/registration/">Изменить данные</a>
													<a class="btn btn-primary" href="/users/?action=exit">Выход</a>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>

						<!-- Personal Account -->
						<xsl:if test="account/shop/node()">
							<div class="col-xs-12 col-md-6">
								<div class="row user-data">
									<div class="col-xs-12">
										<h2 class="social-title">Лицевой счет</h2>
										<hr/>
									</div>
									<div class="col-xs-12">
										<xsl:apply-templates select="account/shop"/>
									</div>
								</div>
							</div>
						</xsl:if>
					</div>
					<div class="row user-data margin-bottom-30">
						<div class="col-xs-12 col-md-6">
						<!-- История заказов -->
							<div class="row margin-bottom-30">
								<div class="col-xs-12">
									<h2 class="social-title">История заказов</h2>
									<hr/>

									<xsl:if test="shop_order/node()">
										<xsl:apply-templates select="shop_order"/>
									</xsl:if>

									<div class="row">
										<div class="col-xs-12 text-align-right">
											<a href="/users/order/" class="btn btn-secondary">Показать все заказы</a>

											<xsl:if test="not(shop_order/node())">
												<a href="/shop/" class="btn btn-primary">Купить</a>
											</xsl:if>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-xs-12 col-md-6">
							<div class="row user-data margin-bottom-30">
								<div class="col-xs-12">
									<h2 class="social-title">Службы поддержки</h2>
									<hr/>
								</div>
								<div class="col-xs-12">
									<xsl:if test="helpdesk_tickets/helpdesk_ticket/node()">
										<div class="row margin-bottom-20">
											<xsl:apply-templates select="helpdesk_tickets/helpdesk_ticket"/>
										</div>
									</xsl:if>
								</div>
								<div class="col-xs-12">
									<a class="btn btn-primary" href="/users/helpdesk/">Направить запрос</a>
								</div>
							</div>
						</div>
					</div>

					<div class="row user-data margin-bottom-30">
						<div class="col-xs-12 col-md-6">
							<xsl:if test="maillists/maillist/node()">
								<div class="row">
									<div class="col-xs-12">
										<h2 class="social-title">Почтовые рассылки</h2>
										<hr/>
									</div>
									<div class="col-xs-12">
										<div class="row margin-bottom-30">
											<xsl:apply-templates select="maillists/maillist"/>
										</div>
									</div>
									<div class="col-xs-12">
										<a class="btn btn-primary" href="/users/maillist/">Настроить рассылку новостей</a>
									</div>
								</div>
							</xsl:if>
						</div>
						<div class="col-xs-12 col-md-6">
							<div class="row">
								<div class="col-xs-12">
									<h2 class="social-title">Личные сообщения</h2>
									<hr/>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-12">
									<div class="row margin-bottom-30">
										<xsl:apply-templates select="message_topic"/>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row user-data margin-bottom-30">
						<div class="col-xs-12 col-md-6">
							<div class="row">
								<div class="col-xs-12">
									<h2 class="social-title">Мои объявления</h2>
									<hr/>
								</div>
							</div>

							<div class="row" style="vertical-align:middle">
								<div class="col-xs-12">
									<a class="btn btn-primary" href="/users/my_advertisement/">Просмотреть объявления</a>
									<span class="user-helpdesk-count"><xsl:value-of select="siteuser_advertisement_count"/></span>
								</div>
							</div>
						</div>
						<div class="col-xs-12 col-md-6">
							<div class="row">
								<div class="col-xs-12">
									<h2 class="social-title">Партнерские программы</h2>
									<hr/>
								</div>
								<div class="col-xs-12">
									<a class="btn btn-primary" href="/users/affiliats/">Просмотреть информацию о программах</a>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<!-- Favorite Products -->
						<xsl:if test="favorite/shop_item/node()">
							<div class="col-xs-12">
								<div class="row margin-top-20">
									<div class="col-xs-12">
										<h2 class="social-title">Избранные товары</h2>
										<hr/>
									</div>
									<div class="col-xs-12">
										<div class="row user-data">
											<div class="col-xs-12">
												<div class="row text-align-center">
													<div class="col-xs-12">
														<div class="row margin-bottom-10">
															<xsl:apply-templates select="favorite/shop_item" mode="image"/>
														</div>
														<div class="row margin-bottom-30">
															<xsl:apply-templates select="favorite/shop_item" mode="name"/>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</xsl:if>
					</div>
					<div class="row">
						<!-- Viewed items -->
						<xsl:if test="viewed/shop_item/node()">
							<div class="col-xs-12">
								<div class="row">
									<div class="col-xs-12">
										<h2 class="social-title">Просмотренные товары</h2>
										<hr/>
									</div>
									<div class="col-xs-12">
										<div class="row user-data">
											<div class="col-xs-12">
												<div class="row text-align-center">
													<div class="col-xs-12">
														<div class="row margin-bottom-10">
															<xsl:apply-templates select="viewed/shop_item" mode="image"/>
														</div>
														<div class="row margin-bottom-30">
															<xsl:apply-templates select="viewed/shop_item" mode="name"/>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</xsl:if>
					</div>
				</div>
			</xsl:when>
			<!-- Unauthorized user -->
			<xsl:otherwise>
				<div class="row authorization">
					<div class="col-xs-12 col-md-6 separator-right">
						<h1>Личный кабинет</h1>

						<!-- Show Error -->
						<xsl:if test="error/node()">
							<div class="alert alert-danger">
								<xsl:value-of select="error"/>
							</div>
						</xsl:if>

						<form action="/users/" method="post" class="form-horizontal">
							<div class="form-group">
								<label for="" class="col-xs-12 col-md-3 control-label">Пользователь:</label>
								<div class="col-xs-12 col-md-9">
									<input name="login" type="text" size="30" class="form-control" />
								</div>
							</div>
							<div class="form-group">
								<label for="" class="col-xs-12 col-md-3 control-label">Пароль:</label>
								<div class="col-xs-12 col-md-9">
									<input name="password" type="password" size="30" class="form-control" />
								</div>
							</div>
							<div class="form-group">
								<div class="hidden-xs col-md-3"></div>
								<div class="col-xs-12 col-md-9">
									<label class="control-label"><input name="remember" type="checkbox" /> Запомнить меня на сайте.</label>
								</div>
							</div>
							<div class="form-group">
								<label for="" class="hidden-xs col-md-3 control-label"></label>
								<div class="col-xs-12 col-md-9">
									<button class="btn btn-secondary" type="submit" name="apply" value="apply">Войти</button>
								</div>
							</div>

							<!-- Page Redirect after login -->
							<xsl:if test="location/node()">
								<input name="location" type="hidden" value="{location}" />
							</xsl:if>
						</form>

						<p>Забыли пароль? Мы можем его <a href="/users/restore_password/">восстановить</a>.</p>
					</div>

					<div class="col-xs-12 col-md-6 separator-left">
						<h1>Регистрация нового пользователя</h1>

						<div id="fastRegistrationDescription">
							<span class="h3">Быстрая и простая регистрация:</span>

							<ul class="account">
								<li>История заказов.</li>
								<li>Обращения в службу поддержки.</li>
								<li>Бонусные баллы.</li>
							</ul>

							 <p>
								<button class="btn btn-primary" onclick="$('#fastRegistrationDescription').hide('slow'); $('#fastRegistration').show('slow'); return false">Зарегистрироваться</button>
							</p>

							 <!-- <p>
								<a class="btn btn-primary" href="/users/registration/">Зарегистрироваться</a>
							 </p> -->
						</div>
						<!-- Форма быстрой регистрации -->
						<div id="fastRegistration">
							<form action="/users/registration/" method="post" class="validate show form" enctype="multipart/form-data">
								<input name="fast" value="1" type="hidden" />

								<div class="form-group">
									<label class="required control-label">Логин</label>
									<input name="login" value="{login}" type="text" class="form-control required" />
								</div>

								<div class="form-group">
									<label class="required control-label">Пароль</label>
									<input name="password" type="password" class="form-control"></input>
								</div>

								<div class="form-group">
									<label class="required control-label">E-mail</label>
									<input name="email" value="{email}" type="email" class="form-control required" />
								</div>

								<div class="form-group">
									<div class="col-xs-12 no-padding-left">
										<label for="captcha-input" class="required control-label">Контрольное число</label>
									</div>
									<div class="col-sm-6 no-padding-left">

										<input type="hidden" name="captcha_id" value="{captcha_id}"/>

										<input id="captcha-input" type="text" name="captcha" size="15" class="form-control required" minlength="4" title="Введите контрольное число"/>
									</div>
									<div class="col-sm-6 no-padding-left">
										<img id="registerUser" src="/captcha.php?id={captcha_id}&amp;height=30&amp;width=100" class="captcha" name="captcha" />

										<div class="captcha">
											<img src="/images/refresh.png" /> <span onclick="$('#registerUser').updateCaptcha('{captcha_id}', 30); return false">Показать другое число</span>
										</div>
									</div>
								</div>

								<!-- Страница редиректа после авторизации -->
								<xsl:if test="location/node()">
									<input name="location" type="hidden" value="{location}" />
								</xsl:if>

								<button type="submit" value="Зарегистрироваться" class="btn btn-primary" name="apply">Зарегистрироваться</button>
							</form>
						</div>
					</div>
				</div>

				<xsl:if test="count(site/siteuser_identity_provider[image != '' and type = 1])">
					<div class="row">
						<div class="col-xs-12">
							<div class="social-authorization">
								<h1>Войти через социальную сеть</h1>
								<xsl:for-each select="site/siteuser_identity_provider[image != '' and type = 1]">
									<a class="social-icon">
										<xsl:attribute name="href">/users/?oauth_provider=<xsl:value-of select="@id"/><xsl:if test="/siteuser/location/node()">&amp;location=<xsl:value-of select="/siteuser/location"/></xsl:if></xsl:attribute>
										<img src="{dir}{image}" alt="{name}" title="{name}" />
									</a><xsl:text> </xsl:text>
								</xsl:for-each>
							</div>
						</div>
					</div>
				</xsl:if>

				<!-- <xsl:if test="count(site/siteuser_identity_provider[image != '' and type = 1])">
					<div class="row social-authorization text-align-center">
						<h1>Войти через социальную сеть</h1>
						<xsl:for-each select="site/siteuser_identity_provider[image != '' and type = 1]">
							<div class="col-xs-6 col-sm-4 col-md-2 margin-top-10 margin-bottom-10">
								<xsl:element name="a">
									<xsl:attribute name="href">/users/?oauth_provider=<xsl:value-of select="@id"/><xsl:if test="/siteuser/location/node()">&amp;location=<xsl:value-of select="/siteuser/location"/></xsl:if></xsl:attribute>
									<xsl:attribute name="class">social-icon</xsl:attribute>
									<img src="{dir}{image}" alt="{name}" title="{name}" />
								</xsl:element><xsl:text> </xsl:text>
							</div>
						</xsl:for-each>
					</div>
				</xsl:if> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="shop_order">
		<div class="row user-last-order">
			<div class="col-xs-3 col-sm-1 col-md-1 col-lg-1">
				<xsl:choose>
					<xsl:when test="paid = 0 and canceled = 0">
						<i class="fa fa-exclamation-circle fa-3x" title="Не оплачен"></i>
					</xsl:when>
					<xsl:when test="paid = 1">
						<i class="fa fa-check-circle fa-3x" title="Оплачен"></i>
					</xsl:when>
					<xsl:when test="canceled = 1">
						<i class="fa fa-times-circle fa-3x" title="Отменен"></i>
					</xsl:when>
				</xsl:choose>
			</div>
			<div class="col-xs-9 col-sm-3 col-md-3 col-lg-3">
				<xsl:text>Заказ № </xsl:text><xsl:choose><xsl:when test="invoice != ''"><xsl:value-of select="invoice"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="@id"/></xsl:otherwise></xsl:choose>
			</div>
			<div class="col-xs-3 col-sm-3 col-md-2 col-lg-2">
				<xsl:value-of select="date"/>
			</div>
			<div class="col-xs-5 col-sm-3 col-md-3 col-lg-3">
				<xsl:value-of select="sum"/>
			</div>
			<div class="col-xs-4 col-sm-2 col-md-3 col-lg-3">
				<a class="btn btn-primary" href="#" data-toggle="modal" data-target="#modal_{@id}">Подробнее</a>
			</div>
		</div>

		<!-- Modal -->
		<div class="modal fade" id="modal_{@id}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><i class="fa fa-times"></i></span></button>
						<h2 class="modal-title social-title" id="myModalLabel"><xsl:text>Заказ № </xsl:text><xsl:choose><xsl:when test="invoice != ''"><xsl:value-of select="invoice"/></xsl:when><xsl:otherwise><xsl:value-of select="@id"/></xsl:otherwise></xsl:choose><xsl:text> от </xsl:text><xsl:value-of select="date"/><xsl:text> г.</xsl:text> </h2>
					</div>

					<div class="modal-body">
						<xsl:if test="shop_order_status/node()">
							Статус:&#xA0;<b><xsl:value-of select="shop_order_status/name"/></b><xsl:if test="status_datetime != '0000-00-00 00:00:00'">, <xsl:value-of select="status_datetime"/></xsl:if>.
						</xsl:if>

						<xsl:if test="phone != ''">
							<br />Телефон:&#xA0;<strong><xsl:value-of select="phone"/></strong>
						</xsl:if>

						<xsl:if test="shop_delivery/node()">
							<br />Доставка:&#xA0;<strong><xsl:value-of select="shop_delivery/name"/></strong>
						</xsl:if>

						<xsl:if test="delivery_information != ''">
							<br />Информация об отправлении:&#xA0;<strong><xsl:value-of select="delivery_information"/></strong>
						</xsl:if>

						<div class="row user-order-modal margin-bottom-5">
							<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
							Название
							</div>
							<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
							Цена
							</div>
							<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
							Количество
							</div>
							<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
							Сумма
							</div>
						</div>

						<div class="row">
							<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
								<xsl:apply-templates select="shop_order_item" mode="shop_order"/>
							</div>
						</div>

						<div class="row margin-top-10">
							<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
								<b>Итого:</b><xsl:text> </xsl:text><xsl:value-of select="sum"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="shop_order_item" mode="shop_order">
		<div class="row margin-bottom-5">
			<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
				<xsl:value-of select="name"/>
			</div>
			<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
				<xsl:value-of select="format-number(price,'### ##0,00', 'my')"/>
				<!-- If show currency -->
				<xsl:if test="../shop_currency/name != ''"><xsl:text> </xsl:text><xsl:value-of select="../shop_currency/name" disable-output-escaping="yes"/></xsl:if>
			</div>
			<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
				<xsl:value-of select="quantity"/>
			</div>
			<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
				<xsl:value-of select="format-number(price * quantity,'### ##0,00', 'my')"/><xsl:text> </xsl:text><xsl:value-of select="../shop_currency/name" disable-output-escaping="yes"/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="shop_item" mode="image">
		<div class="col-xs-6 col-sm-6 col-md-2 col-lg-2">
			<img class="user-img" src="{dir}{image_small}"/>
		</div>
	</xsl:template>

	<xsl:template match="shop_item" mode="name">
		<div class="col-xs-6 col-sm-6 col-md-2 col-lg-2">
			<a href="{url}"><xsl:value-of select="name"/></a>
		</div>
	</xsl:template>

	<xsl:template match="maillist">
		<div class="col-xs-12 col-sm-4 col-md-4 col-lg-4 padding-top-5">
			<xsl:value-of select="name"/>
		</div>
		<div class="col-xs-12 col-sm-4 col-md-4 col-lg-4">
			<select name="type_{@id}" id="type_{@id}" class="form-control">
				<xsl:if test="maillist_siteuser/node()">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
				</xsl:if>

				<option value="0">
					<xsl:if test="maillist_siteuser/node() and maillist_siteuser/type = 0">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					Текст
				</option>
				<option value="1">
					<xsl:if test="maillist_siteuser/node() and maillist_siteuser/type = 1">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					HTML
				</option>
			</select>
		</div>
		<div class="col-xs-12 col-sm-4 col-md-4 col-lg-4 text-align-right margin-top-5">
			<xsl:choose>
				<xsl:when test="maillist_siteuser/node()">
					<span class="btn btn-secondary">Подписан</span>
				</xsl:when>
				<xsl:otherwise>
					<span id="subscribed_{@id}" class="btn hidden">Подписан</span>

					<a id="subscribe_{@id}" class="btn btn-primary" onclick="$.subscribeMaillist('maillist/', '{@id}', $('#type_{@id}').val())">Подписаться</a>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="message_topic">
		<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 margin-bottom-20">
			<a class="btn btn-secondary" href="/users/my_messages/"><xsl:value-of select="subject"/></a>
			<span class="user-helpdesk-count"><xsl:value-of select="count_recipient_unread"/></span>
		</div>
	</xsl:template>

	<xsl:template match="helpdesk_tickets/helpdesk_ticket">
		<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 margin-bottom-10">
			<a href="/users/helpdesk/ticket-{@id}/">Запрос № <xsl:value-of select="number"/></a>
			<span class="user-helpdesk-count"><xsl:value-of select="messages_count - processed_messages_count"/></span>
		</div>
	</xsl:template>

	<xsl:template match="shop">
		<div class="row margin-bottom-30">
			<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
				<a href="{url}"><xsl:value-of select="name"/></a>
			</div>
			<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
				<xsl:value-of select="transaction_amount"/><xsl:text> </xsl:text><xsl:value-of select="shop_currency/name"/>
			</div>
			<div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 text-align-right">
				<a class="btn btn-primary" href="/users/account/pay/{@id}/">Пополнить</a>
				<a class="btn btn-secondary" href="/users/account/shop-{@id}/">История</a>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>