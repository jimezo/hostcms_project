<?php

if (!Core::moduleIsActive('siteuser'))
{
	?>
	<h1>Пользователи сайта</h1>
	<p>Функционал недоступен, приобретите более старшую редакцию.</p>
	<p>Модуль &laquo;<a href="http://www.hostcms.ru/hostcms/modules/users/">Пользователи сайта</a>&raquo; доступен в редакциях &laquo;<a href="http://www.hostcms.ru/hostcms/editions/corporation/">Корпорация</a>&raquo; и &laquo;<a href="http://www.hostcms.ru/hostcms/editions/business/">Бизнес</a>&raquo;.</p>
	<?php
	return ;
}

$xslRestorePasswordMailXsl = Core_Array::get(Core_Page::instance()->libParams, 'xslRestorePasswordMailXsl');

if (Core_Array::getPost('apply'))
{
	$login = strval(Core_Array::getPost('login'));
	$email = strval(Core_Array::getPost('email'));
	$oSiteuser = Core_Entity::factory('Site', CURRENT_SITE)->Siteusers->getByLoginAndEmail($login, $email);

	if (!is_null($oSiteuser) && $oSiteuser->active)
	{
		$Siteuser_Controller_Restore_Password = new Siteuser_Controller_Restore_Password(
			$oSiteuser
		);
		$Siteuser_Controller_Restore_Password
			->subject('Восстановление пароля')
			->xsl(
				Core_Entity::factory('Xsl')->getByName($xslRestorePasswordMailXsl)
			)
			->sendNewPassword();

		$path = '../';
		?>
		<h1 class="item_title">Восстановление пароля прошло успешно</h1>
		<p>В Ваш адрес отправлено письмо, содержащее Ваш новый пароль.</p>
		<p>Если Ваш браузер поддерживает автоматическое перенаправление через 3 секунды Вы перейдёте на страницу <a href="../">идентификации пользователя</a>. Если Вы не хотите ждать перейдите по соответствующей ссылке.</p>
		<script type="text/javascript">setTimeout(function(){ location = '<?php echo $path?>' }, 3000);</script>
		<?php

		return;
	}
	else
	{
		$error = 'Пользователь с такими параметрами не зарегистрирован или на указанный e-mail не может быть отправлено письмо.';
	}
}

?>
<h1 class="item_title">Восстановление пароля</h1>
<?php
if (!empty($error))
{
	?><div id="error"><?php echo $error?></div><?php
}
?>
<form class="form-horizontal" action="/users/restore_password/" method="post">
<div class="form-group">
	<label for="" class="col-xs-3 col-sm-3 col-md-3 col-lg-2 control-label">Пользователь:</label>
	<div class="col-xs-9 col-sm-9 col-md-9 col-lg-10">
		<input name="login" type="text" size="30" class="form-control">
	</div>
</div>
<div class="form-group">
	<label for="" class="col-xs-3 col-sm-3 col-md-3 col-lg-2 control-label">E-mail:</label>	
	<div class="col-xs-9 col-sm-9 col-md-9 col-lg-10">
		<input name="email" type="text" size="30" class="form-control">
	</div>
</div>

<!-- <p>
<input name="apply" type="submit" value="Восстановить" class="button" />
</p>-->

<div class="form-group">
	<label for="" class="col-xs-3 col-sm-3 col-md-3 col-lg-2 control-label"></label>
	<div class="col-xs-9 col-sm-9 col-md-9 col-lg-10">
		<div class="actions">
			<!-- <button class="button btn-cart" type="submit" name="apply" value="apply">
				<i class="fa fa-share bg-color5"></i>
				<span class="bg-color3">
					<span>Восстановить</span>
				</span>
			</button>-->
			<button class="hostcms-button hostcms-button-red" type="submit" name="apply" value="apply">Восстановить</button>
		</div>
	</div>
</div>
</form>