<?php
if (Core::moduleIsActive('shop'))
{
	$shop_id = Core_Array::get(Core_Page::instance()->widgetParams, 'shopId');
	$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');
	$limit = Core_Array::get(Core_Page::instance()->widgetParams, 'limit');	

	$oShop_Producer_Controller_Show = new Shop_Producer_Controller_Show(
		Core_Entity::factory('Shop', $shop_id)
	);

	$oShop_Producer_Controller_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName($xsl)
		)
		->limit($limit)
		->show();
}