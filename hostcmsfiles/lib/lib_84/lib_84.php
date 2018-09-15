<?php

$Comment_Shop_Controller_Show = Core_Page::instance()->object;

$xslName = Core_Array::get(Core_Page::instance()->libParams, 'commentXsl');

$Comment_Shop_Controller_Show
	->xsl(
		Core_Entity::factory('Xsl')->getByName($xslName)
	);

// observer
class HostCMS_Shop_Comment_Observer
{
	static public function onBeforeGetXml($object, $args)
	{
		$oShop_Item = $object->Shop_Item;

		// shop item name
		$object->addXmlTag('shop_item_name', $oShop_Item->name);

		$oSiteAlias = $oShop_Item->Shop->Site->getCurrentAlias();
		if ($oSiteAlias)
		{
			$url = 'http://' . $oSiteAlias->name
				. $oShop_Item->Shop->Structure->getPath()
				. $oShop_Item->getPath();

			// shop item url
			$object->addXmlTag('shop_item_url', $url);
		}
	}
}

// Add comment observer
Core_Event::attach('comment.onBeforeGetXml', array('HostCMS_Shop_Comment_Observer', 'onBeforeGetXml'));

$Comment_Shop_Controller_Show->show();