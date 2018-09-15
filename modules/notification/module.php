<?php

defined('HOSTCMS') || exit('HostCMS: access denied.');

/**
 * Notifications.
 *
 * @package HostCMS
 * @subpackage Notification
 * @version 6.x
 * @author Hostmake LLC
 * @copyright © 2005-2018 ООО "Хостмэйк" (Hostmake LLC), http://www.hostcms.ru
 */
class Notification_Module extends Core_Module{	/**
	 * Module version
	 * @var string
	 */
	public $version = '6.8';

	/**
	 * Module date
	 * @var date
	 */
	public $date = '2018-08-15';
	/**
	 * Module name
	 * @var string
	 */
	protected $_moduleName = 'notification';

	/**
	 * Get Module's Menu
	 * @return array
	 */
	public function getMenu()
	{
		$this->menu = array(
			array(
				'sorting' => 150,
				'block' => 3,
				'ico' => 'fa fa-warning',
				'name' => Core::_('Notification.model_name'),
				'href' => "/admin/notification/index.php",
				'onclick' => "$.adminLoad({path: '/admin/notification/index.php'}); return false"
			)
		);

		return parent::getMenu();
	}
}