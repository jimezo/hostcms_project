<?php

defined('HOSTCMS') || exit('HostCMS: access denied.');

/**
 * Directory_Controller_Tab
 *
 * @package HostCMS
 * @subpackage Directory
 * @version 6.x
 * @author Hostmake LLC
 * @copyright © 2005-2018 ООО "Хостмэйк" (Hostmake LLC), http://www.hostcms.ru
 */
abstract class Directory_Controller_Tab extends Core_Servant_Properties
{
	protected $_allowedProperties = array(
		'title',
		'relation',
		'showPublicityControlElement',
		'prefix'
	);

	/**
	 * The singleton instances.
	 * @var mixed
	 */
	static public $instance = array();

	/**
	 * Register an existing instance as a singleton.
	 * @param string $name driver's name
	 * @return object
	 */
	static public function instance($name)
	{
		if (!is_string($name))
		{
			throw new Core_Exception('Wrong argument type (expected String)');
		}

		if (!isset(self::$instance[$name]))
		{
			$driver = __CLASS__ . '_' . ucfirst($name);
			self::$instance[$name] = new $driver();
		}

		return self::$instance[$name];
	}

	protected $_aDirectory_Relations = NULL;

	public function execute()
	{
		$oRowDiv = Admin_Form_Entity::factory('Div');

		$oPersonalDataInnerWrapper = Admin_Form_Entity::factory('Div')
			->class('well with-header')
			->add(
				Admin_Form_Entity::factory('Div')
					->class('header ' . $this->_titleHeaderColor)
					->add(
						Admin_Form_Entity::factory('Code')
							->html('<i class="widget-icon ' . $this->_faTitleIcon . ' icon-separator"></i>' . $this->title)
					)
			);

		$this->_aDirectory_Relations = $this->relation->findAll();

		$this->_execute($oPersonalDataInnerWrapper);

		$oRowDiv
			->class('row')
			->add(Admin_Form_Entity::factory('Div')
				->class('col-lg-12')
				->add($oPersonalDataInnerWrapper)
			);

		return $oRowDiv;

	}

	protected function _publicityControlElement()
	{
		return Admin_Form_Entity::factory('Checkbox')
			->divAttr(array('class' => 'col-xs-2 no-padding margin-top-23'))
			->caption('<acronym title="" data-original-title="Показывать на сайте">Показывать</acronym>');
	}

	protected function _buttons()
	{
		return Admin_Form_Entity::factory('Div') // div с кноками + и -
			->class('no-padding add-remove-property margin-top-23 pull-left')
			->add(
				Admin_Form_Entity::factory('Code')
					->html('<div class="btn btn-palegreen" onclick="$.cloneFormRow(this); event.stopPropagation();"><i class="fa fa-plus-circle close"></i></div><div class="btn btn-darkorange btn-delete' . (count($this->_aDirectory_Relations) ? '' : ' hide')  . '" onclick="$.deleteFormRow(this); event.stopPropagation();"><i class="fa fa-minus-circle close"></i></div>')
			);
	}



	protected function _getDirectoryTypes()
	{
		$aDirectory_Types = Core_Entity::factory($this->_directoryTypeName)->findAll();

		$aMasDirectoryTypes = array();

		foreach ($aDirectory_Types as $oDirectory_Type)
		{
			$aMasDirectoryTypes[$oDirectory_Type->id] = $oDirectory_Type->name;
		}

		return $aMasDirectoryTypes;
	}
}