<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- ЛентаЛичныхСообщений -->
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="siteuser/ajax/node() and siteuser/ajax = 1">
				<xsl:apply-templates select="siteuser" mode="messages" />
			</xsl:when>
			<xsl:otherwise>
				<script type="text/javascript">
					<xsl:comment>
						<xsl:text disable-output-escaping="yes">
							<![CDATA[
							$( function () {
								$('.siteuser-messages').messagesHostCMS();
							})
							]]>
						</xsl:text>
					</xsl:comment>
				</script>

				<div class="siteuser-messages">
					<xsl:apply-templates select="siteuser"/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="current_siteuser_id" select="siteuser/@id" />

	<!-- Пользователи сайта -->
	<xsl:variable name="siteusers" select="//siteuser" />

	<xsl:template match="siteuser">
		<div style="display: none">
			<div id="url"><xsl:value-of select="url" /></div>
			<div id="limit"><xsl:value-of select="limit" /></div>
			<div id="total"><xsl:value-of select="total" /></div>
			<div id="topic_id"><xsl:value-of select="message_topic/@id" /></div>
		</div>

		<h1>
			<xsl:choose>
				<xsl:when test="message_topic/subject != ''"><xsl:value-of select="message_topic/subject" /></xsl:when>
				<xsl:otherwise>No subject</xsl:otherwise>
			</xsl:choose>
		</h1>

		<xsl:for-each select="errors/error">
			<div class="alert alert-danger"><xsl:value-of select="."/></div>
		</xsl:for-each>

		<xsl:for-each select="messages/message">
			<div class="alert alert-success"><xsl:value-of select="."/></div>
		</xsl:for-each>

		<xsl:if test="message_topic">
			<!-- Показаны не все сообщения -->
			<div id="load_messages" class="right">
				<xsl:if test="total &lt; (page + 1) * limit">
					<xsl:attribute name="style">display: none</xsl:attribute>
				</xsl:if>
				Предыдущие сообщения
			</div>

			<div id="chat_window">
				<xsl:apply-templates select="." mode="messages" />
			</div>

			<div class="comment no-background comment-width">
				<form action="{url}{message_topic/@id}/" id="send_message" method="post">
					<div class="row">
						<div class="caption">Сообщение</div>
						<div class="field">
							<textarea name="text" cols="68" rows="5" class="form-control mceEditor"></textarea>
						</div>
					</div>

					<div class="row">
						<div class="caption"></div>
						<div class="actions item-margin-left">
							<button class="btn btn-primary" type="submit" name="add_message" value="add_message">Ответить</button>
						</div>
					</div>
				</form>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="siteuser" mode="messages">
		<div id="messages">
			<ul class="media-list messages-data">
				<xsl:apply-templates select="message_topic/message" />
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="message">
		<li id="msg_{@id}" class="media">
			<xsl:variable name="user_from_id" select="site_users_mail_from_id" />
			<xsl:variable name="user_to_id" select="site_users_mail_to_id" />

			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="$current_siteuser_id = siteuser_id">media out </xsl:when>
					<xsl:otherwise>media in </xsl:otherwise>
				</xsl:choose>

				<xsl:if test="read = 0">unread </xsl:if>
			</xsl:attribute>

			<div class="media-body">
				<p><xsl:value-of disable-output-escaping="yes" select="text" /></p>

				<div class="review-info">
					<span>
						<xsl:value-of disable-output-escaping="yes" select="datetime"/>
					</span>

					<xsl:variable name="new_user" >
						<xsl:choose>
							<xsl:when test="preceding::message[1]/siteuser_id != siteuser_id or not(preceding::message[1]/siteuser_id)">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<!-- Пользователь -->
					<xsl:if test="$new_user = 1">
						<xsl:variable name="siteuser_id" select="siteuser_id" />
						<xsl:variable name="siteuser" select="$siteusers[@id = $siteuser_id]" />

						<i class="fa fa-user"></i>
						<span>
							<a href="/users/info/{$siteuser/login}/">
								<xsl:if test="$siteuser/name != ''"><xsl:value-of select="$siteuser/name"/><xsl:text> </xsl:text></xsl:if>
								<xsl:value-of select="$siteuser/surname" />
							</a>
						</span>
					</xsl:if>
				</div>
			</div>

			<xsl:if test="1=0">
			<div class="attr">
				<xsl:variable name="new_user" >
					<xsl:choose>
						<xsl:when test="preceding::message[1]/siteuser_id != siteuser_id or not(preceding::message[1]/siteuser_id)">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- Пользователь -->
				<xsl:if test="$new_user = 1">
					<xsl:variable name="siteuser_id" select="siteuser_id" />
					<xsl:variable name="siteuser" select="$siteusers[@id = $siteuser_id]" />
					<b><a href="/users/info/{$siteuser/login}/">
							<xsl:if test="$siteuser/name != ''"><xsl:value-of select="$siteuser/name"/><xsl:text> </xsl:text></xsl:if>
							<xsl:value-of select="$siteuser/surname" />
					</a></b><br/>
				</xsl:if>

				<!-- Дата -->
				<xsl:if test="(substring(preceding::message[1]/datetime, 1, 10) != substring(datetime, 1, 10)	or position() = 1) or $new_user = 1">
					<b><xsl:value-of disable-output-escaping="yes" select="format-number(substring(datetime, 1, 2), '#')"/></b>

					<xsl:variable name="month" select="substring(datetime, 4, 2)" />

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
				</xsl:if>

				<!-- Время -->
				<xsl:value-of select="substring(datetime, 12, 5)" />
			</div>

			<div class="text" >
				<xsl:value-of select="text" disable-output-escaping="yes"/>
			</div>
			</xsl:if>
		</li>
	</xsl:template>
</xsl:stylesheet>