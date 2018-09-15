<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- СозданиеТемы -->

	<xsl:template match="/forum">

		<script type="text/javascript">
			<xsl:comment>
				<xsl:text disable-output-escaping="yes">
					<![CDATA[
					$(document).ready(function() {
						$("#new_message").bbedit({lang: 'ru'});

						$("#form_add_topic").validate({
							focusInvalid: true,
							errorClass: "input_error"
						});
					});
					]]>
				</xsl:text>
			</xsl:comment>
		</script>

		<h1 class="item_title"><xsl:choose><xsl:when test="not(forum_topic/node())">Создание</xsl:when><xsl:otherwise>Редактирование</xsl:otherwise></xsl:choose> темы</h1>

		<xsl:if test="error != ''">
			<div class="alert alert-danger">
				<xsl:value-of disable-output-escaping="yes" select="error"/>
			</div>
		</xsl:if>

		<!-- Хлебные крошки -->
		<span class="breadcrumbs">
			<a href="{url}">Список форумов</a>
			<i class="fa fa-angle-right"></i>
			<a href="{url}{forum_category/@id}/" class="current_page_link">
				<xsl:value-of select="forum_category/name"/>
			</a>
		</span>

		<xsl:variable name="current_siteuser_id"><xsl:choose><xsl:when test="/forum/siteuser/node()"><xsl:value-of select="/forum/siteuser/@id"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>

		<xsl:variable name="moderator">
		<xsl:choose><xsl:when test = "/forum/forum_category/moderators/siteuser/node()">
			<xsl:choose><xsl:when test="/forum/forum_category/moderators//siteuser[@id = $current_siteuser_id]/node()">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>
		</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>

		<xsl:variable name="current_page"><xsl:choose><xsl:when test="page > 0">/page-<xsl:value-of select="page + 1" />/</xsl:when><xsl:otherwise>/</xsl:otherwise></xsl:choose></xsl:variable>

		<form id="form_add_topic" action="./" method="post" class="form-horizontal validate">
			<xsl:variable name="topic_title"><xsl:choose><xsl:when test="error_topic_title/node()"><xsl:value-of select="error_topic_title"/></xsl:when><xsl:otherwise><xsl:value-of select="forum_topic/forum_topic_post/subject"/></xsl:otherwise></xsl:choose></xsl:variable>

			<xsl:variable name="topic_text"><xsl:choose><xsl:when test="error_topic_text/node()"><xsl:value-of select="error_topic_text"/></xsl:when><xsl:otherwise><xsl:value-of select="forum_topic/forum_topic_post/original_text"/></xsl:otherwise></xsl:choose></xsl:variable>

			<div class="add_message_table">
				<div class="form-group">
					<!-- Заголовок темы-->
					<div class="col-xs-3 control-label">Тема:</div>
					<div class="col-xs-9"><input id="topic_title" type="text" class="form-control" name="topic_subject" value="{$topic_title}"/></div>
				</div>

				<!-- Модератор может редактировать атрибуты темы -->
				<xsl:choose>
					<xsl:when test="$moderator = 1">
						<div class="form-group">
							<div class="col-xs-3 control-label"></div>
							<!-- Объявление -->
							<div class="col-xs-3">
								<xsl:variable name="announcement"><xsl:choose><xsl:when test="error_topic_announcement/node()"><xsl:value-of select="error_topic_announcement" /></xsl:when><xsl:otherwise><xsl:value-of select="forum_topic/announcement" /></xsl:otherwise></xsl:choose></xsl:variable>
								<input id="announcement" type="checkbox" name="announcement" value="1">
									<xsl:if test="$announcement = 1">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<label for="announcement">Объявление</label>
							</div>

							<!-- Открытость -->
							<div class="col-xs-3">
								<xsl:variable name="closed"><xsl:choose><xsl:when test="error_topic_closed/node()"><xsl:value-of select="error_topic_closed" /></xsl:when><xsl:otherwise><xsl:value-of select="forum_topic/closed" /></xsl:otherwise></xsl:choose></xsl:variable>
								<input id="closed" type="checkbox" name="closed" value="1">
									<xsl:if test="$closed = 1">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<label for="closed">Закрытая</label>
							</div>

							<!-- Видимость -->
							<div class="col-xs-3">
								<input id="visible" type="checkbox" name="visible" value="1">
									<xsl:if test="not(error_topic_visible/node()) and (forum_topic/visible = 1 or not(forum_topic/node()))
									or error_topic_visible/node() and error_topic_visible = 1">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>

								</input>
								<label for="visible">Видимая</label>
							</div>
							<div style="clear: both"></div>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<input type="hidden" name="theme_visible" value="1"/>
					</xsl:otherwise>
				</xsl:choose>

				<div class="form-group">
					<div class="col-xs-3 control-label"></div>
					<div class="col-xs-9">
						<textarea id="new_message" rows="9" name="topic_text" class="form-control">
							<xsl:value-of select="$topic_text"/>
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
						<div class="col-xs-5 col-sm-5 col-md-5 col-lg-3">
							<div class="captcha" style="margin: 5px 0 5px 125px">
								<img id="addForumPost" class="captcha" src="/captcha.php?id={forum_category/captcha_id}&amp;height=30&amp;width=100" title="Контрольное число" name="captcha"/>
								<div><img src="/images/refresh.png" /> <span onclick="$('#addForumPost').updateCaptcha('{forum_category/captcha_id}', 30); return false">Показать другое число</span></div>
							</div>
						</div>
					</div>
				</xsl:if>

				<div class="form-group">
					<label for="" class="col-xs-3 control-label"></label>
					<div class="col-xs-9">
						<div class="actions">
							<button class="btn btn-primary" type="submit" name="add_edit_topic" value="add_edit_topic">Добавить</button>
						</div>
					</div>
				</div>

				<input type="hidden" name="current_page" value="{page + 1}" />
				<input type="hidden" name="forum_topic_id" value="{forum_topic/@id}" />

				<xsl:if test="not(forum_topic/node())">
					<input type="hidden" name="subscribe" value="1" />
				</xsl:if>
			</div>
		</form>
	</xsl:template>
</xsl:stylesheet>