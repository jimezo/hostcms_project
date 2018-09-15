<?php
if (Core::moduleIsActive('informationsystem') && Core::moduleIsActive('tag') && isset(Core_Page::instance()->libParams['informationsystemId']))
{			
	$informationsystem_id = Core_Array::get(Core_Page::instance()->widgetParams, 'informationsystemId');
	$xsl = Core_Array::get(Core_Page::instance()->widgetParams, 'xsl');
	
	$Informationsystem_Controller_Tag_Show = new Informationsystem_Controller_Tag_Show(
		Core_Entity::factory('Informationsystem', $informationsystem_id)
	);
	$Informationsystem_Controller_Tag_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName($xsl)
		);

	if (is_object(Core_Page::instance()->object)
	&& get_class(Core_Page::instance()->object) == 'Informationsystem_Controller_Show'
	&& Core_Page::instance()->object->group)
	{
		$Informationsystem_Controller_Tag_Show->group(Core_Page::instance()->object->group);
	}

	if (is_object(Core_Page::instance()->object)
	&& get_class(Core_Page::instance()->object) == 'Informationsystem_Controller_Show')
	{
		$Informationsystem_Controller_Tag_Show->show();
	}
}
?>