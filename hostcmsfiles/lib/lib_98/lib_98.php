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
		->join('shop_item_discounts', 'shop_item_discounts.shop_item_id', '=', 'shop_items.id')
		->join('shop_discounts', 'shop_discounts.id', '=', 'shop_item_discounts.shop_discount_id')
		->where('shop_discounts.active', '=', 1)
		->where('shop_discounts.start_datetime', '<', Core_Date::timestamp2sql(time()))
		->where('shop_discounts.end_datetime', '>', Core_Date::timestamp2sql(time()))
		->where('shop_discounts.deleted', '=', 0)
		->where('shop_items.modification_id', '=', 0)
		->groupBy('shop_items.id')
		->clearOrderBy()
		->orderBy('RAND()');

	$Shop_Controller_Show->show();
}
?>