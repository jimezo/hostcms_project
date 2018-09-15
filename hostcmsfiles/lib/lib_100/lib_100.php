<?php
	$address = htmlspecialchars(Core_Array::get(Core_Page::instance()->widgetParams, 'address'));
	$phone = htmlspecialchars(Core_Array::get(Core_Page::instance()->widgetParams, 'phone'));
?>

<div class="row top-block">
	<div class="top-block-left col-xs-12 col-sm-4 hidden-xs">
	</div>
	<div class="top-block-center col-xs-12 col-sm-4 hidden-xs">
		<i class="fa fa-phone"></i>
		<?php echo $phone?>
		<i class="fa fa-map-marker"></i>
		<?php echo $address?>
	</div>
	<div class="top-block-right col-xs-12 col-sm-4">
		<div class="quick-access">
			<ul class="links">
				<li class="first">
					<?php
						if (Core::moduleIsActive('siteuser'))
						{
							$oSiteuser = Core_Entity::factory('Siteuser')->getCurrent();

							?><a title="Войти" href="/users/"><?php
							if (is_null($oSiteuser))
							{
								?>Войти<?php
							}
							else
							{
								?>Здравствуйте, <?php echo htmlspecialchars($oSiteuser->login);
							}
							?></a><?php
						}
					?>
				</li>
				<li>
					<a title="Карта сайта" href="/map/">Карта сайта</a>
				</li>
				<li class="last">
					<a title="Контакты" href="/contacts/">Контакты</a>
				</li>
			</ul>
		</div>
	</div>
</div>