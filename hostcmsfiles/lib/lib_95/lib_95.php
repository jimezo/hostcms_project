<?php
// Опросы
if (Core::moduleIsActive('poll'))
{
	$poll_group_id = Core_Array::get(Core_Page::instance()->widgetParams, 'pollGroupId');
	$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');
	$limit = Core_Array::get(Core_Page::instance()->widgetParams, 'limit');	
	
	$Poll_Group_Controller_Show = new Poll_Group_Controller_Show(
		Core_Entity::factory('Poll_Group', $poll_group_id)
	);

	$Poll_Group_Controller_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName($xsl)
		)
		->limit($limit)
		->rand()
		->show();
}
?>