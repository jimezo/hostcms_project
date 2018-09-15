<?php
$shop_id = Core_Array::get(Core_Page::instance()->widgetParams, 'shopId');
$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');
$limit = Core_Array::get(Core_Page::instance()->widgetParams, 'limit');	

if (Core::moduleIsActive('shop'))
{
	$Shop_Controller_Show = new Shop_Controller_Show(
		Core_Entity::factory('Shop', $shop_id)
	);
	$Shop_Controller_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName($xsl)
		)
		->groupsMode('none')
		->group(FALSE)
		->cache(FALSE)
		->viewed(FALSE)
		->limit($limit);

	$Shop_Controller_Show
		->shopItems()
		->queryBuilder()
		->where('shop_items.modification_id', '=', 0)
		->where('shop_items.shortcut_id', '=', 0)
		->clearOrderBy()
		->orderBy('shop_items.id', 'DESC');

	$Shop_Controller_Show->show();
}
?>