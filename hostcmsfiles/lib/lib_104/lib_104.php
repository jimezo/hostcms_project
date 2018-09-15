<div class="little-cart">
	<?php
	if (Core::moduleIsActive('shop'))
	{
		$shopId = Core_Array::get(Core_Page::instance()->widgetParams, 'shopId');
		$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');
		
		$Shop_Cart_Controller_Show = new Shop_Cart_Controller_Show(
			Core_Entity::factory('Shop', $shopId)
		);
		$Shop_Cart_Controller_Show
			->xsl(
				Core_Entity::factory('Xsl')->getByName($xsl)
			)
			->couponText(isset($_SESSION) ? Core_Array::get($_SESSION, 'coupon_text') : '')
			->itemsPropertiesList(FALSE)
			->show();
	}
	?>
</div>