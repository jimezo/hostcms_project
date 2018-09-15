<?php
$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');

// Вывод строки навигации
$Structure_Controller_Breadcrumbs = new Structure_Controller_Breadcrumbs(
		Core_Entity::factory('Site', CURRENT_SITE)
	);
$Structure_Controller_Breadcrumbs
	->xsl(
		Core_Entity::factory('Xsl')->getByName($xsl)
	)
	->show();
?>