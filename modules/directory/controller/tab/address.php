<?php

defined('HOSTCMS') || exit('HostCMS: access denied.');

/**
 * Directory_Controller_Tab_Address
 *
 * @package HostCMS
 * @subpackage Directory
 * @version 6.x
 * @author Hostmake LLC
 * @copyright © 2005-2018 ÎÎÎ "Õîñòìýéê" (Hostmake LLC), http://www.hostcms.ru
 */
class Directory_Controller_Tab_Address extends Directory_Controller_Tab
{
	protected $_directoryTypeName = 'Directory_Address_Type';
	protected $_titleHeaderColor = 'bordered-palegreen';
	protected $_faTitleIcon = 'fa fa-map-marker';

	protected function _execute($oPersonalDataInnerWrapper)
	{
		$aDirectory_Relations = $this->relation->findAll();

		$aMasDirectoryTypes = $this->_getDirectoryTypes();

		$oButtons = $this->_buttons();

		if (count($this->_aDirectory_Relations))
		{
			foreach ($this->_aDirectory_Relations as $oDirectory_Relation)
			{
				$oRowElements = $this->_addressTemplate($aMasDirectoryTypes, $oDirectory_Relation);

				$oPersonalDataInnerWrapper->add(
					$oRowElements->add($oButtons)
				);
			}
		}
		else
		{
			$oRowElements = $this->_addressTemplate($aMasDirectoryTypes);

			$oPersonalDataInnerWrapper->add(
				$oRowElements->add($oButtons)
			);
		}
	}

	protected function _addressTemplate($aMasDirectoryAddressTypes, $oUser_Directory_Address = NULL)
	{
		 $oRowElements = Admin_Form_Entity::factory('Div')
			->class('row')
			->add(
				Admin_Form_Entity::factory('Select')
					->options($aMasDirectoryAddressTypes)
					->name($this->prefix . 'address_type' . ($oUser_Directory_Address ? '#' . $oUser_Directory_Address->id : '[]'))
					->value($oUser_Directory_Address ? $oUser_Directory_Address->Directory_Address->directory_address_type_id : '')
					->caption(Core::_('Directory_Address.type_address'))
					->divAttr(array('class' => 'form-group col-xs-12 col-sm-6 col-lg-3'))
			)
			->add(
				Admin_Form_Entity::factory('Input')
					->name($this->prefix . 'address_country' . ($oUser_Directory_Address ? '#' . $oUser_Directory_Address->id : '[]'))
					->value($oUser_Directory_Address ? $oUser_Directory_Address->Directory_Address->country : '')
					->caption(Core::_('Directory_Address.address_country'))
					// ->divAttr(array('class' => 'form-group no-padding-left ' . ($this->showPublicityControlElement ? 'col-xs-3' : 'col-lg-5 col-sm-6 col-xs-5')))
					->divAttr(array('class' => 'form-group col-xs-12 col-sm-6 col-lg-3'))
			)
			->add(
				Admin_Form_Entity::factory('Input')
					->name($this->prefix . 'address_postcode' . ($oUser_Directory_Address ? '#' . $oUser_Directory_Address->id : '[]'))
					->value($oUser_Directory_Address ? $oUser_Directory_Address->Directory_Address->postcode : '')
					->caption(Core::_('Directory_Address.address_postcode'))
					// ->divAttr(array('class' => 'form-group no-padding-left ' . ($this->showPublicityControlElement ? 'col-xs-3' : 'col-lg-5 col-sm-6 col-xs-5')))
					->divAttr(array('class' => 'form-group col-xs-12 col-sm-6 col-lg-3'))
			)
			->add(
				Admin_Form_Entity::factory('Input')
					->name($this->prefix . 'address_city' . ($oUser_Directory_Address ? '#' . $oUser_Directory_Address->id : '[]'))
					->value($oUser_Directory_Address ? $oUser_Directory_Address->Directory_Address->city : '')
					->caption(Core::_('Directory_Address.address_city'))
					// ->divAttr(array('class' => 'form-group no-padding-left ' . ($this->showPublicityControlElement ? 'col-xs-3' : 'col-lg-5 col-sm-6 col-xs-5')))
					->divAttr(array('class' => 'form-group col-xs-12 col-sm-6 col-lg-3'))
			)
			->add(
				Admin_Form_Entity::factory('Input')
					->name($this->prefix . 'address' . ($oUser_Directory_Address ? '#' . $oUser_Directory_Address->id : '[]'))
					->value($oUser_Directory_Address ? $oUser_Directory_Address->Directory_Address->value : '')
					->caption(Core::_('Directory_Address.address'))
					// ->divAttr(array('class' => 'form-group ' . ($this->showPublicityControlElement ? 'col-sm-8 col-xs-3' : 'col-lg-5 col-sm-6 col-xs-5')))
					->divAttr(array('class' => 'form-group col-xs-12 col-sm-8'))
			);

			if ($this->showPublicityControlElement)
			{
				$iAddressPublic = $oUser_Directory_Address ? $oUser_Directory_Address->Directory_Address->public : 0;

				$oRowElements->add(
					Admin_Form_Entity::factory('Checkbox')
						->divAttr(array('class' => 'col-xs-2 no-padding margin-top-23'))
						->name($this->prefix . 'address_public' . ($oUser_Directory_Address ? '#' . $oUser_Directory_Address->id : '[]'))
						->checked($iAddressPublic ? $iAddressPublic : NULL)
						->value($iAddressPublic)
						->caption(Core::_('Directory_Address.address_public'))
				);
			}

			return $oRowElements;
	}
}