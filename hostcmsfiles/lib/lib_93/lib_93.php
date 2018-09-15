<?php
if (Core::moduleIsActive('shop') && Core::moduleIsActive('tag') && isset(Core_Page::instance()->libParams['shopId']))
{			
	$shop_id = Core_Array::get(Core_Page::instance()->widgetParams, 'shopId');
	$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');
	
	$Shop_Controller_Tag_Show = new Shop_Controller_Tag_Show(
		Core_Entity::factory('Shop', $shop_id)
	);
	$Shop_Controller_Tag_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName($xsl)
		);

	if (is_object(Core_Page::instance()->object)
	&& get_class(Core_Page::instance()->object) == 'Shop_Controller_Show'
	&& Core_Page::instance()->object->group)
	{
		$Shop_Controller_Tag_Show->group(Core_Page::instance()->object->group);
	}

	if (is_object(Core_Page::instance()->object)
	&& get_class(Core_Page::instance()->object) == 'Shop_Controller_Show')
	{
		$Shop_Controller_Tag_Show->show();
	}
}
?>