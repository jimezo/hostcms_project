<?php

$shop_id = Core_Array::get(Core_Page::instance()->widgetParams, 'shopId');
$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');
$limit = Core_Array::get(Core_Page::instance()->widgetParams, 'limit');	

// Последний заказ
$oShop = Core_Entity::factory('Shop', $shop_id);

$Shop_Controller_Show = new Shop_Controller_Show(
	$oShop
);

$Shop_Controller_Show
	->xsl(
		Core_Entity::factory('Xsl')->getByName($xsl)
	)
	->groupsMode('none')
	->viewed(FALSE)
	->limit(0);

$oShop_Orders = $oShop->Shop_Orders;
$oShop_Orders
	->queryBuilder()
	->where('shop_orders.paid', '=', 1)
	->clearOrderBy()
	->orderBy('shop_orders.id', 'DESC')
	->limit($limit);

$aShop_Orders = $oShop_Orders->findAll();

if (count($aShop_Orders))
{
	foreach ($aShop_Orders as $oShop_Order)
	{
		$aShop_Order_Items = $oShop_Order->Shop_Order_Items->findAll();

		foreach ($aShop_Order_Items as $oShop_Order_Item)
		{
			if ($oShop_Order_Item->shop_item_id)
			{
				$oShop_Item = Core_Entity::factory('Shop_Item')->find($oShop_Order_Item->shop_item_id);

				!is_null($oShop_Item->id) && $Shop_Controller_Show->addEntity(
					$oShop_Item
						->addForbiddenTag('text')
						->addForbiddenTag('description')
						->addForbiddenTag('shop_producer')
						->showXmlComments(FALSE)
						->showXmlAssociatedItems(FALSE)
						->showXmlModifications(FALSE)
						->showXmlSpecialprices(FALSE)
						->showXmlTags(FALSE)
						->showXmlWarehousesItems(FALSE)
						->showXmlSiteuser(FALSE)
						->showXmlProperties(FALSE)
				);
			}
		}

		$Shop_Controller_Show->addEntity(
			$oShop_Order->clearEntities()
		);
	}

	$Shop_Controller_Show
		->itemsForbiddenTags(array('text'))
		->show();
}
?>