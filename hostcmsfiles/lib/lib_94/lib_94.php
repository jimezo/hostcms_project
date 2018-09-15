<?php
if (Core::moduleIsActive('advertisement'))
{
	$advertisement_group_id = Core_Array::get(Core_Page::instance()->widgetParams, 'advertisementGroupId');
	$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');	
	
	$Advertisement_Group_Controller_Show = new Advertisement_Group_Controller_Show(
		Core_Entity::factory('Advertisement_Group', $advertisement_group_id)
	);

	$Advertisement_Group_Controller_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName($xsl)
		)
		->show();
}
?>