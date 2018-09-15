<?php

defined('HOSTCMS') || exit('HostCMS: access denied.');

/**
 * Directory_Controller_Tab_Email
 *
 * @package HostCMS
 * @subpackage Directory
 * @version 6.x
 * @author Hostmake LLC
 * @copyright © 2005-2018 ÎÎÎ "Õîñòìýéê" (Hostmake LLC), http://www.hostcms.ru
 */
class Directory_Controller_Tab_Email extends Directory_Controller_Tab
{
	protected $_directoryTypeName = 'Directory_Email_Type';
	protected $_titleHeaderColor = 'bordered-darkorange';
	protected $_faTitleIcon = 'fa fa-envelope-o';

	protected function _execute($oPersonalDataInnerWrapper)
	{
		$aDirectory_Relations = $this->relation->findAll();

		$aMasDirectoryTypes = $this->_getDirectoryTypes();

		$oButtons = $this->_buttons();

		if (count($this->_aDirectory_Relations))
		{
			foreach ($this->_aDirectory_Relations as $oDirectory_Relation)
			{
				$oRowElements = $this->_emailTemplate($aMasDirectoryTypes, $oDirectory_Relation);

				$oPersonalDataInnerWrapper->add(
					$oRowElements->add($oButtons)
				);
			}
		}
		else
		{
			$oRowElements = $this->_emailTemplate($aMasDirectoryTypes);

			$oPersonalDataInnerWrapper->add(
				$oRowElements->add($oButtons)
			);
		}
	}

	protected function _emailTemplate($aMasDirectoryEmailTypes, $oUser_Directory_Email = NULL)
	{
		$oRowElements = Admin_Form_Entity::factory('Div')
			->class('row')
			->add(
				Admin_Form_Entity::factory('Select')
					->options($aMasDirectoryEmailTypes)
					->name($this->prefix . 'email_type' . ($oUser_Directory_Email ? '#' . $oUser_Directory_Email->id : '[]'))
					->value($oUser_Directory_Email ? $oUser_Directory_Email->Directory_Email->directory_email_type_id : '')
					->caption(Core::_('Directory_Email.type_email'))
					->divAttr(array('class' => 'form-group col-xs-4'))
			)
			->add(
				Admin_Form_Entity::factory('Input')
					->name($this->prefix . 'email' . ($oUser_Directory_Email ? '#' . $oUser_Directory_Email->id : '[]'))
					->value($oUser_Directory_Email ? $oUser_Directory_Email->Directory_Email->value : '')
					->caption(Core::_('Directory_Email.email'))
					->divAttr(array('class' => 'form-group no-padding-left ' . ($this->showPublicityControlElement ? 'col-sm-4 col-xs-3' : 'col-lg-5 col-sm-6 col-xs-5')))
			);

			if ($this->showPublicityControlElement)
			{
				$iEmailPublic = $oUser_Directory_Email ? $oUser_Directory_Email->Directory_Email->public : 0;

				$oRowElements->add(
					Admin_Form_Entity::factory('Checkbox')
						->divAttr(array('class' => 'col-xs-2  no-padding margin-top-23'))
						->name($this->prefix . 'email_public' . ($oUser_Directory_Email ? '#' . $oUser_Directory_Email->id : '[]'))
						->checked($iEmailPublic ? $iEmailPublic : NULL)
						->value($iEmailPublic)
						->caption(Core::_('Directory_Email.email_public'))
				);
			}

			return $oRowElements;
	}
}