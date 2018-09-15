<?php
$menu_id = Core_Array::get(Core_Page::instance()->widgetParams, 'menuId');
$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');

// Menu
$Structure_Controller_Show = new Structure_Controller_Show(
	Core_Entity::factory('Site', CURRENT_SITE));

$Structure_Controller_Show->xsl(
	Core_Entity::factory('Xsl')->getByName($xsl)
)
->menu($menu_id)
->show();
?>