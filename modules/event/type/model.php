<?php

defined('HOSTCMS') || exit('HostCMS: access denied.');

/**
 * Event_Type_Model
 *
 * @package HostCMS
 * @subpackage Event
 * @version 6.x
 * @author Hostmake LLC
 * @copyright © 2005-2017 ООО "Хостмэйк" (Hostmake LLC), http://www.hostcms.ru
 */
class Event_Type_Model extends Core_Entity
{
	/**
	 * One-to-many or many-to-many relations
	 * @var array
	 */
	protected $_hasMany = array(
		'event' =>  array()
	);

	/**
	 * Backend callback method
	 * @return string
	 */
	public function name()
	{
		return  ($this->icon ? '<i class="' . htmlspecialchars($this->icon) . '" style="margin-right: 5px; color: ' . ($this->color ? htmlspecialchars($this->color) : '#eee' ) . '"></i> ' : '')
				. '<span class="editable" id="apply_check_0_' . $this->id . '_fv_1160">' . htmlspecialchars($this->name) . '</span>';
	}

	public function getDefault($bCache = TRUE)
	{
		$this->queryBuilder()
			//->clear()
			->where('default', '=', 1)
			->limit(1);

		$aEvent_Types = $this->findAll($bCache);

		return isset($aEvent_Types[0]) ? $aEvent_Types[0] : NULL;
	}

	public function setDefault()
	{
		$oEvent_Types = Core_Entity::factory('Event_Type');

		$oEvent_Types
			->queryBuilder()
			->where('default', '=', 1)
			->where('id', '!=', $this->id);

		$aEvent_Types = $oEvent_Types->findAll(FALSE);

		foreach($aEvent_Types as $oEvent_Type)
		{
			$oEvent_Type->default = 0;
			$oEvent_Type->save();
		}

		$this->default = 1;
		$this->save();

		return $this;
	}

	/**
	 * Delete object from database
	 * @param mixed $primaryKey primary key for deleting object
	 * @return Core_Entity
	 * @hostcms-event event_type.onBeforeRedeclaredDelete
	 */
	public function delete($primaryKey = NULL)
	{
		if (is_null($primaryKey))
		{
			$primaryKey = $this->getPrimaryKey();
		}

		$this->id = $primaryKey;

		Core_Event::notify($this->_modelName . '.onBeforeRedeclaredDelete', $this, array($primaryKey));

		Core_QueryBuilder::update('events')
			->set('event_type_id', 0)
			->where('event_type_id', '=', $this->id)
			->execute();

		return parent::delete($primaryKey);
	}
}