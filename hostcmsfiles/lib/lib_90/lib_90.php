<?php
if (Core::moduleIsActive('shop') && isset(Core_Page::instance()->libParams['shopId']))
{
	$shop_id = Core_Array::get(Core_Page::instance()->widgetParams, 'shopId');
	$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');	

	$oShop = Core_Entity::factory('Shop', $shop_id);
	$Shop_Controller_Show = new Shop_Controller_Show($oShop);
	$Shop_Controller_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName($xsl)
		);

	if (is_object(Core_Page::instance()->object)
	&& get_class(Core_Page::instance()->object) == 'Shop_Controller_Show')
	{
		$Shop_Controller_Show->group(Core_Page::instance()->object->group);
		$iCurrentShopGroup = Core_Page::instance()->object->group;
	}
	else
	{
		$iCurrentShopGroup = 0;
	}

	$price_from = intval(Core_Array::getGet('price_from'));
	$price_to = intval(Core_Array::getGet('price_to'));

	if ($price_from)
	{
		$Shop_Controller_Show->addEntity(
			Core::factory('Core_Xml_Entity')
				->name('price_from')->value($price_from)
		);
		$Shop_Controller_Show->addCacheSignature('price_from=' . $price_from);
	}

	if ($price_to)
	{
		$Shop_Controller_Show->addEntity(
			Core::factory('Core_Xml_Entity')
				->name('price_to')->value($price_to)
		);
		$Shop_Controller_Show->addCacheSignature('price_to=' . $price_to);
	}

	// Sorting
	if (Core_Array::getGet('sorting'))
	{
		$sorting = intval(Core_Array::getGet('sorting'));
		$Shop_Controller_Show->addEntity(
			Core::factory('Core_Xml_Entity')
				->name('sorting')->value($sorting)
		);
		$Shop_Controller_Show->addCacheSignature('sorting=' . $sorting);
	}

	// Producers
	if (Core_Array::getGet('producer_id'))
	{
		$iProducerId = intval(Core_Array::getGet('producer_id'));
		$Shop_Controller_Show->addEntity(
			Core::factory('Core_Xml_Entity')
				->name('producer_id')->value($iProducerId)
		);
		$Shop_Controller_Show->addCacheSignature('producer_id=' . $iProducerId);
	}

	// Additional properties
	$oShop_Item_Property_List = Core_Entity::factory('Shop_Item_Property_List', $oShop->id);

	$aProperties = $oShop_Item_Property_List->Properties->findAll();

	$aTmpProperties = array();

	foreach ($aProperties as $oProperty)
	{
		// Several options
		$aPropertiesValue = Core_Array::getGet('property_' . $oProperty->id);
		if ($aPropertiesValue)
		{
			!is_array($aPropertiesValue) && $aPropertiesValue = array($aPropertiesValue);
			foreach ($aPropertiesValue as $sPropertyValue)
			{
				$aTmpProperties[] = array($oProperty, strval($sPropertyValue));
			}
		}
		elseif (!is_null(Core_Array::getGet('property_' . $oProperty->id . '_from')))
		{
			$tmpFrom = Core_Array::getGet('property_' . $oProperty->id . '_from');
			$tmpTo = Core_Array::getGet('property_' . $oProperty->id . '_to');

			!is_array($tmpFrom) && $tmpFrom = array($tmpFrom);
			!is_array($tmpTo) && $tmpTo = array($tmpTo);

			// From ... to ...
			foreach ($tmpFrom as $iKey => $sValue)
			{
				$to = Core_Array::get($tmpTo, $iKey);

				$aTmpProperties[] = array($oProperty, array(
					'from' => $sValue != ''
						? ($oProperty->type == 11 ? floatval($sValue) : intval($sValue))
						: '',
					'to' => $to != ''
						? ($oProperty->type == 11 ? floatval($to) : intval($to))
						: ''
				));
			}
		}
	}

	if (count($aTmpProperties))
	{
		foreach ($aTmpProperties as $aTmpProperty)
		{
			list($oProperty, $propertyValue) = $aTmpProperty;
			$tableName = $oProperty->createNewValue(0)->getTableName();

			if (!is_array($propertyValue))
			{
				$Shop_Controller_Show->addEntity(
					Core::factory('Core_Xml_Entity')
						->name('property_' . $oProperty->id)->value($propertyValue)
				);
				$Shop_Controller_Show->addCacheSignature("property{$oProperty->id}={$propertyValue}");
			}
			else
			{
				$from = trim(Core_Array::get($propertyValue, 'from'));
				$to = trim(Core_Array::get($propertyValue, 'to'));

				$Shop_Controller_Show->addEntity(
					Core::factory('Core_Xml_Entity')
						->name('property_' . $oProperty->id . '_from')->value($from)
				)->addEntity(
					Core::factory('Core_Xml_Entity')
						->name('property_' . $oProperty->id . '_to')->value($to)
				);

				$Shop_Controller_Show
					->addCacheSignature("property{$oProperty->id}_from={$from}")
					->addCacheSignature("property{$oProperty->id}_to={$to}");
			}
		}
	}

	$Shop_Controller_Show
		->group($iCurrentShopGroup)
		->addMinMaxPrice()
		->calculateTotal(FALSE)
		->viewed(FALSE)
		->groupsMode('tree')
		->limit(0)
		->itemsProperties(TRUE)		
		->show();
}
?>