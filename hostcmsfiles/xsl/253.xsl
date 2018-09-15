<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml" />
	
	<!-- ОтобразитьФорму -->
	
	<xsl:template match="/">
		<xsl:apply-templates select="/form" />
	</xsl:template>
	
	<xsl:template match="/form">
		
		<!-- Проверка формы -->
		<SCRIPT type="text/javascript">
			$(document).ready(function() {
			$("#form<xsl:value-of select="@id" />").validate({
			focusInvalid: true,
			errorClass: "input_error"
			})
			});
		</SCRIPT>
		
		<h1><xsl:value-of select="name" /></h1>
		
		<xsl:choose>
			<xsl:when test="success/node() and success = 1">
				<p>Спасибо! Запрос получен, в ближайшее время Вам будет дан ответ.</p>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<!-- Выводим ошибку (error), если она была передана через внешний параметр -->
					<xsl:when test="error != ''">
						<div class="alert alert-danger">
							<xsl:value-of disable-output-escaping="yes" select="error" />
						</div>
					</xsl:when>
					<xsl:when test="errorId/node()">
						<div class="alert alert-danger">
							<xsl:choose>
								<xsl:when test="errorId = 0">
									Вы неверно ввели число подтверждения отправки формы!
								</xsl:when>
								<xsl:when test="errorId = 1">
									Заполните все обязательные поля!
								</xsl:when>
								<xsl:when test="errorId = 2">
									Прошло слишком мало времени с момента последней отправки Вами формы!
								</xsl:when>
							</xsl:choose>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="description" />
					</xsl:otherwise>
				</xsl:choose>
				
				<div class="comment no-background">
					<!-- Параметр action формы должен быть "./", если обработчик на этой же странице, либо "./form/", если обработчик на другой странице, например ./form/ -->
					<form name="form{@id}" id="form{@id}" class="form-horizontal validate" action="./" method="post" enctype="multipart/form-data" role="form">
						
						<!-- Вывод разделов формы 0-го уровня -->
						<xsl:apply-templates select="form_field_dir" />
						
						<!-- Вывод списка полей формы 0-го уровня -->
						<xsl:apply-templates select="form_field" />
						
						<!-- Код подтверждения -->
						<xsl:if test="captcha_id != 0">
							<div class="form-group">
						<label for="captcha" class="col-xs-12 col-sm-3 control-label">Контрольное число<sup><font color="red">*</font></sup></label>
								<div class="col-xs-12 col-sm-3">
									<input type="hidden" name="captcha_id" value="{/form/captcha_id}"/>
									<input id="captcha" type="text" name="captcha" size="15" class="form-control required" minlength="4" title="Введите число, которое указано выше."/>
								</div>
								<div class="col-xs-12 col-sm-3">
									<img id="formCaptcha_{/form/@id}_{/form/captcha_id}" src="/captcha.php?id={captcha_id}&amp;height=30&amp;width=100" class="captcha" name="captcha" />
									
									<div class="captcha">
										<img src="/images/refresh.png" /> <span onclick="$('#formCaptcha_{/form/@id}_{/form/captcha_id}').updateCaptcha('{/form/captcha_id}', 30); return false">Показать другое число</span>
									</div>
								</div>
							</div>
						</xsl:if>
						
						<div class="form-group">
							<label for="" class="col-xs-3 control-label"></label>
							<div class="col-xs-9">
								<div class="actions">
									<button class="btn btn-primary" type="submit" name="{button_name}" value="{button_value}">Опубликовать</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="form_field_dir">
		<fieldset class="maillist_fieldset">
			<legend><xsl:value-of select="name" /></legend>
			
			<!-- Вывод списка полей формы -->
			<xsl:apply-templates select="form_field" />
			
			<!-- Вывод разделов формы -->
			<xsl:apply-templates select="form_field_dir" />
		</fieldset>
	</xsl:template>
	
	<xsl:template match="form_field">
		<!-- Не скрытое поле и не надпись -->
		<xsl:if test="type != 7 and type != 8">
			<div class="form-group">
				<label for="{name}" class="col-sm-3 control-label"><xsl:value-of select="caption" />
					<xsl:if test="obligatory = 1">
						<sup>
							<font color="red">*</font>
						</sup>
					</xsl:if>
				</label>
				<div class="col-sm-9">
					<!-- Текстовые поля -->
					<xsl:if test="type = 0 or type = 1 or type = 2 or type = 10 or type = 11 or type = 12 or type = 13 or type = 14 or type = 15 or type = 16 or type = 17 or type = 18 or type = 19">
						<input id="{name}" type="text" name="{name}" value="{value}" size="{size}">
							<xsl:choose>
								<!-- Поле для ввода пароля -->
								<xsl:when test="type = 1">
									<xsl:attribute name="type">password</xsl:attribute>
									<xsl:attribute name="class">form-control</xsl:attribute>
								</xsl:when>
								<!-- Поле загрузки файла -->
								<xsl:when test="type = 2">
									<xsl:attribute name="type">file</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Дата -->
								<xsl:when test="type = 10">
									<xsl:attribute name="type">date</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Цвет -->
								<xsl:when test="type = 11">
									<xsl:attribute name="type">color</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Месяц -->
								<xsl:when test="type = 12">
									<xsl:attribute name="type">month</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Неделя -->
								<xsl:when test="type = 13">
									<xsl:attribute name="type">week</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Время -->
								<xsl:when test="type = 14">
									<xsl:attribute name="type">time</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Дата-Время -->
								<xsl:when test="type = 15">
									<xsl:attribute name="type">datetime</xsl:attribute>
								</xsl:when>
								<!-- HTML5: E-mail -->
								<xsl:when test="type = 16">
									<xsl:attribute name="type">email</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Поиск -->
								<xsl:when test="type = 17">
									<xsl:attribute name="type">search</xsl:attribute>
								</xsl:when>
								<!-- HTML5: Телефон -->
								<xsl:when test="type = 18">
									<xsl:attribute name="type">tel</xsl:attribute>
								</xsl:when>
								<!-- HTML5: URL -->
								<xsl:when test="type = 19">
									<xsl:attribute name="type">url</xsl:attribute>
								</xsl:when>
								<!-- Текстовое поле -->
								<xsl:otherwise>
									<xsl:attribute name="type">text</xsl:attribute>
									<xsl:attribute name="class">form-control</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="obligatory = 1">
								<xsl:attribute name="class">form-control required</xsl:attribute>
								<xsl:attribute name="minlength">1</xsl:attribute>
								<xsl:attribute name="title">Заполните поле <xsl:value-of select="caption" /></xsl:attribute>
							</xsl:if>
						</input>
					</xsl:if>
					
					<!-- Радиокнопки -->
					<xsl:if test="type = 3 or type = 9">
						<xsl:apply-templates select="list/list_item" />
						<label class="input_error" for="{name}" style="display: none">Выберите, пожалуйста, значение.</label>
					</xsl:if>
					
					<!-- Checkbox -->
					<xsl:if test="type = 4">
						<input type="checkbox" name="{name}">
							<xsl:if test="checked = 1 or value = 1">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
					</xsl:if>
					
					<!-- Textarea -->
					<xsl:if test="type = 5">
						<textarea name="{name}" cols="{cols}" rows="{rows}" wrap="soft" class="form-control">
							<xsl:if test="obligatory = 1">
								<xsl:attribute name="class">form-control required</xsl:attribute>
								<xsl:attribute name="minlength">1</xsl:attribute>
								<xsl:attribute name="title">Заполните поле <xsl:value-of select="caption" /></xsl:attribute>
							</xsl:if>
							<xsl:value-of select="value" />
						</textarea>
					</xsl:if>
					
					<!-- Список -->
					<xsl:if test="type = 6">
						<select name="{name}" class="form-control">
							<xsl:if test="obligatory = 1">
								<xsl:attribute name="class">required</xsl:attribute>
								<xsl:attribute name="title">Заполните поле <xsl:value-of select="caption" /></xsl:attribute>
							</xsl:if>
							<option value="">...</option>
							<xsl:apply-templates select="list/list_item" />
						</select>
					</xsl:if>
				</div>
			</div>
		</xsl:if>
		
		<!-- скрытое поле -->
		<xsl:if test="type = 7">
			<input type="hidden" name="{name}" value="{value}" />
		</xsl:if>
		
		<!-- Надпись -->
		<xsl:if test="type = 8">
			<div class="row">
				<div class="caption"></div>
				<div class="field">
					<strong><xsl:value-of select="caption" /></strong>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- Формируем радиогруппу или выпадающий список -->
	<xsl:template match="list/list_item">
		<xsl:choose>
			<xsl:when test="../../type = 3">
				<input id="{../../name}_{@id}" type="radio" name="{../../name}" value="{value}">
					<xsl:if test="value = ../../value">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
					<xsl:if test="../../obligatory = 1">
						<xsl:attribute name="class">required</xsl:attribute>
						<xsl:attribute name="minlength">1</xsl:attribute>
						<xsl:attribute name="title">Заполните поле <xsl:value-of select="caption" /></xsl:attribute>
					</xsl:if>
			</input><xsl:text> </xsl:text>
				<label for="{../../name}_{@id}"><xsl:value-of disable-output-escaping="yes" select="value" /></label>
				<br/>
			</xsl:when>
			<xsl:when test="../../type = 6">
				<option value="{value}">
					<xsl:if test="value = ../../value">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of disable-output-escaping="yes" select="value" />
				</option>
			</xsl:when>
			<xsl:when test="../../type = 9">
				<xsl:variable name="currentValue" select="@id" />
				<input id="{../../name}_{@id}" type="checkbox" name="{../../name}_{@id}" value="{value}">
					<xsl:if test="../../values[value=$currentValue]/node()">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
			</input><xsl:text> </xsl:text>
				<label for="{../../name}_{@id}"><xsl:value-of disable-output-escaping="yes" select="value" /></label>
				<br/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>