<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- ЛичныеСообщения -->
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="siteuser/ajax/node() and siteuser/ajax = 1">
				<xsl:apply-templates select="siteuser" mode="messages-data" />
			</xsl:when>
			<xsl:otherwise>
				<script type="text/javascript">
				<xsl:comment>
					<xsl:text disable-output-escaping="yes">
						<![CDATA[
						$( function () {
							$('.siteuser-messages').messageTopicsHostCMS();
						})
						]]>
					</xsl:text>
				</xsl:comment>
				</script>

				<xsl:apply-templates select="siteuser"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- Пользователи сайта -->
	<xsl:variable name="siteusers" select="//siteuser" />
	<xsl:variable name="siteuser_id" select="/siteuser/@id" />

	<xsl:template match="siteuser">
		<h1>Мои диалоги</h1>

		<div class="siteuser-messages">
			<div style="display: none">
				<div id="url"><xsl:value-of select="url" /></div>
				<div id="page"><xsl:value-of select="page" /></div>
			</div>

			<button class="btn btn-primary" onclick="$('.message-form').toggle('fast')" type="button">Написать сообщение</button>

			<div class="message-form comment no-background comment-width" style="display:none;">
				<form method="post" action="{url}">
					<div class="row">
						<div class="caption">Получатель</div>
						<div class="field">
							<input type="text" size="70" name="login" class="form-control"/>
						</div>
					</div>

					<div class="row">
						<div class="caption">Тема</div>
						<div class="field">
							<input type="text" size="70" name="subject" class="form-control"/>
						</div>
					</div>

					<div class="row">
						<div class="caption">Сообщение</div>
						<div class="field">
							<textarea name="text" cols="68" rows="5" class="form-control mceEditor"></textarea>
						</div>
					</div>

					<div class="row">
						<div class="caption"></div>
						<div class="actions item-margin-left">
							<button class="btn btn-primary" type="submit" name="add_message" value="add_message">Отправить</button>
						</div>
					</div>
				</form>
			</div>

			<div class="messages-data">
				<xsl:apply-templates select="." mode="messages-data" />
			</div>
		</div>
	</xsl:template>

	<xsl:template match="siteuser" mode="messages-data">
		<xsl:for-each select="errors/error">
			<div class="alert alert-danger"><xsl:value-of select="."/></div>
		</xsl:for-each>

		<xsl:for-each select="messages/message">
			<div class="alert alert-success"><xsl:value-of select="."/></div>
		</xsl:for-each>

		<xsl:choose>
			<xsl:when test="count(message_topic) = 0">
				<h2 id="message">У Вас нет сообщений!</h2>
			</xsl:when>
			<xsl:otherwise>
				<div class="message-topics">
					<ul class="media-list">
						<xsl:apply-templates select="message_topic" />
					</ul>
				</div>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test="total &gt; 0 and limit &gt; 0">
			<xsl:variable name="count_pages" select="ceiling(total div limit)"/>

			<xsl:variable name="visible_pages" select="5"/>

			<xsl:variable name="real_visible_pages"><xsl:choose>
				<xsl:when test="$count_pages &lt; $visible_pages"><xsl:value-of select="$count_pages"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$visible_pages"/></xsl:otherwise>
			</xsl:choose></xsl:variable>

			<!-- Links before current -->
			<xsl:variable name="pre_count_page"><xsl:choose>
				<xsl:when test="page  - (floor($real_visible_pages div 2)) &lt; 0">
					<xsl:value-of select="page"/>
				</xsl:when>
				<xsl:when test="($count_pages  - page - 1) &lt; floor($real_visible_pages div 2)">
					<xsl:value-of select="$real_visible_pages - ($count_pages  - page - 1) - 1"/>
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
				<xsl:when test="($count_pages  - page - 1) &lt; floor($real_visible_pages div 2)">
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

			<p>
				<xsl:call-template name="for">
					<xsl:with-param name="limit" select="limit"/>
					<xsl:with-param name="page" select="page"/>
					<xsl:with-param name="items_count" select="total"/>
					<xsl:with-param name="i" select="$i"/>
					<xsl:with-param name="post_count_page" select="$post_count_page"/>
					<xsl:with-param name="pre_count_page" select="$pre_count_page"/>
					<xsl:with-param name="visible_pages" select="$real_visible_pages"/>
				</xsl:call-template>
			</p>
			<div style="clear: both"></div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="message_topic">
		<li class="media">
			<xsl:attribute name="class">
				<xsl:if test="count_sender_unread > 0 or count_recipient_unread > 0">
					<xsl:choose>
						<xsl:when test="recipient_siteuser_id = $siteuser_id">media in_unread</xsl:when>
						<xsl:otherwise>media out_unread</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:attribute>

			<xsl:variable name="sender_siteuser_id" select="sender_siteuser_id" />
			<xsl:variable name="recipient_siteuser_id" select="recipient_siteuser_id" />
			<xsl:variable name="siteuser" select="$siteusers[@id=$sender_siteuser_id or @id=$recipient_siteuser_id][@id!=$siteuser_id or $sender_siteuser_id=$siteuser_id and $recipient_siteuser_id=$siteuser_id]"/>

			<div class="media-left">
				<xsl:variable name="avatarPath">
					<xsl:choose>
						<xsl:when test="$siteuser/property_value[tag_name='avatar']/file != ''">
							{$siteuser/dir}{$siteuser/property_value[tag_name='avatar']/file}
						</xsl:when>
						<xsl:otherwise>/hostcmsfiles/forum/avatar.gif</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<a href="/users/info/{$siteuser/login}/">
					<img class="media-object" src="{$avatarPath}" alt="" />
				</a>
			</div>
			<div class="media-body">
				<h4 class="media-heading">
					<xsl:choose>
						<xsl:when test="subject != ''">
							<strong><xsl:value-of select="subject" /></strong>
						</xsl:when>
						<xsl:otherwise>Без темы</xsl:otherwise>
					</xsl:choose>
				</h4>

				<xsl:if test="message/text != ''">
					<p><xsl:value-of disable-output-escaping="yes" select="message/text" /></p>
				</xsl:if>

				<div class="review-info">
					<span>
						<xsl:value-of disable-output-escaping="yes" select="datetime"/>
					</span>

					<i class="fa fa-user"></i>
					<span>
						<a href="/users/info/{$siteuser/login}/" target="_blank"><xsl:value-of select="$siteuser/name" /><xsl:text> </xsl:text><b><xsl:value-of select="$siteuser/login" /></b><xsl:text> </xsl:text><xsl:value-of select="$siteuser/surname" /></a>
					</span>

					<span><a href="{/siteuser/url}{@id}/" id="reply"><i class="fa fa-comment" title="Ответить"></i></a></span>

					<span><a onclick="res = confirm('Вы уверены, что хотите Удалить?'); if (!res) return false;" href="{/siteuser/url}{@id}/delete/" class="delete"><i class="fa fa-times" title="Удалить"></i></a></span>
				</div>
			</div>
		</li>
	</xsl:template>

	<!-- Declension of the numerals -->
	<xsl:template name="declension">
		<xsl:param name="number" />

		<!-- Nominative case / Именительный падеж -->
		<xsl:variable name="nominative">
			<xsl:text>сообщение</xsl:text>
		</xsl:variable>

		<!-- Genitive singular / Родительный падеж, единственное число -->
		<xsl:variable name="genitive_singular">
			<xsl:text>сообщения</xsl:text>
		</xsl:variable>

		<!-- Родительный падеж, множественное число -->
		<xsl:variable name="genitive_plural">
			<xsl:text>сообщений</xsl:text>
		</xsl:variable>

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
			<xsl:when test="$last_digit = 2 and $last_two_digits != 12
				or $last_digit = 3 and $last_two_digits != 13
				or $last_digit = 4 and $last_two_digits != 14">
				<xsl:value-of select="$genitive_singular"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$genitive_plural"/>
			</xsl:otherwise>
		</xsl:choose>
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
			<span class="ctrl">
				← Ctrl
			</span>
		</xsl:if>

		<xsl:if test="$i = ($page + $post_count_page + 1) and $n != ($page+1)">
			<span class="ctrl">
				Ctrl →
			</span>
		</xsl:if>

		<xsl:if test="$items_count &gt; $limit and ($page + $post_count_page + 1) &gt; $i">
			<!-- Store in the variable $group ID of the current group -->
			<xsl:variable name="group" select="/informationsystem/group"/>

			<!-- Set $link variable -->
			<xsl:variable name="number_link">
				<xsl:choose>

					<xsl:when test="$i != 0">page-<xsl:value-of select="$i + 1"/>/</xsl:when>

					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!-- First pagination item -->
			<xsl:if test="$page - $pre_count_page &gt; 0 and $i = $start_page">
				<a href="{/siteuser/url}" class="page_link" style="text-decoration: none;">←</a>
				<a href="{/siteuser/url}" class="page_link" style="text-decoration: none;">←</a>
			</xsl:if>

			<!-- Pagination item -->
			<xsl:if test="$i != $page">
				<xsl:if test="($page - $pre_count_page) &lt;= $i and $i &lt; $n">
					<!-- Pagination item -->
					<a href="{/siteuser/url}{$number_link}" class="page_link">
						<xsl:value-of select="$i + 1"/>
					</a>
				</xsl:if>

				<!-- Last pagination item -->
				<xsl:if test="$i+1 &gt;= ($page + $post_count_page + 1) and $n &gt; ($page + 1 + $post_count_page)">
					<!-- Last pagination item -->
					<a href="{/siteuser/url}page-{$n}/" class="page_link" style="text-decoration: none;">→</a>
				</xsl:if>
			</xsl:if>

			<!-- Ctrl+left link -->
			<xsl:if test="$page != 0 and $i = $page">
				<xsl:variable name="prev_number_link">
					<xsl:choose>

						<xsl:when test="$page &gt; 1">page-<xsl:value-of select="$i"/>/</xsl:when>

						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<a href="{/siteuser/url}{$prev_number_link}" id="id_prev"></a>
			</xsl:if>

			<!-- Ctrl+right link -->
			<xsl:if test="($n - 1) > $page and $i = $page">
				<a href="{/siteuser/url}page-{$page+2}/" id="id_next"></a>
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
</xsl:stylesheet>