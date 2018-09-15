<?php
if (Core::moduleIsActive('informationsystem'))
{
	$informationsystem_id = Core_Array::get(Core_Page::instance()->widgetParams, 'informationsystemId');
	$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');
	$limit = Core_Array::get(Core_Page::instance()->widgetParams, 'limit');
	$rand = Core_Array::get(Core_Page::instance()->widgetParams, 'rand');
	$itemsProperties = Core_Array::get(Core_Page::instance()->widgetParams, 'properties');

	// Новости
	$Informationsystem_Controller_Show = new Informationsystem_Controller_Show(
		Core_Entity::factory('Informationsystem', $informationsystem_id)
	);

	$rand && $Informationsystem_Controller_Show
		->informationsystemItems()
		->queryBuilder()
		->clearOrderBy()
		->orderBy('RAND()');

	$Informationsystem_Controller_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName($xsl)
		)
		->groupsMode('none')
		->itemsForbiddenTags(array('text'))
		->group(FALSE)
		->limit($limit)
		->itemsProperties($itemsProperties)
		->calculateTotal(FALSE)		
		->show();
}