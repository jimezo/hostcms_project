<?php

defined('HOSTCMS') || exit('HostCMS: access denied.');

/**
 * Event_Status_Model
 *
 * @package HostCMS
 * @subpackage Event
 * @version 6.x
 * @author Hostmake LLC
 * @copyright © 2005-2017 ООО "Хостмэйк" (Hostmake LLC), http://www.hostcms.ru
 */
class Event_Status_Model extends Core_Entity
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
		return '<i class="fa fa-circle" style="margin-right: 5px; color: ' . ($this->color ? htmlspecialchars($this->color) : '#eee' ) . '"></i> '
				. '<span class="editable" id="apply_check_0_' . $this->id . '_fv_1151">' . htmlspecialchars($this->name) . '</span>';
	}

	/**
	 * Change event status final
	 * @hostcms-event event_status.onBeforeChangeActive
	 * @hostcms-event event_status.onAfterChangeActive
	 * @return self
	 */
	public function changeFinal()
	{
		Core_Event::notify($this->_modelName . '.onBeforeChangeFinal', $this);

		$this->final = 1 - $this->final;
		$this->save();

		Core_Event::notify($this->_modelName . '.onAfterChangeFinal', $this);

		return $this;
	}

	/**
	 * Delete object from database
	 * @param mixed $primaryKey primary key for deleting object
	 * @return Core_Entity
	 * @hostcms-event event_status.onBeforeRedeclaredDelete
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
			->set('event_status_id', 0)
			->where('event_status_id', '=', $this->id)
			->execute();

		return parent::delete($primaryKey);
	}
}