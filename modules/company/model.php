<?php

defined('HOSTCMS') || exit('HostCMS: access denied.');

/**
 * Company_Model
 *
 * @package HostCMS
 * @subpackage Company
 * @version 6.x
 * @author Hostmake LLC
 * @copyright © 2005-2018 ООО "Хостмэйк" (Hostmake LLC), http://www.hostcms.ru
 */
class Company_Model extends Core_Entity
{
	/**
	 * Callback structure
	 * @var int
	 */
	public $structure = 1;

	/**
	 * One-to-many or many-to-many relations
	 * @var array
	 */
	protected $_hasMany = array(
		'company_department' =>  array(),
		'company_site' =>  array(),
		'shop' => array(),
		'site' => array('through' => 'company_site'),
		'company_directory_email' => array(),
		'directory_email' => array('through' => 'company_directory_email', 'foreign_key' => 'company_id'),
		'company_directory_phone' => array(),
		'directory_phone' => array('through' => 'company_directory_phone', 'foreign_key' => 'company_id'),
		'company_directory_address' => array(),
		'directory_address' => array('through' => 'company_directory_address', 'foreign_key' => 'company_id'),
		'company_directory_website' => array(),
		'directory_website' => array('through' => 'company_directory_website', 'foreign_key' => 'company_id'),
		'user' => array('through' => 'company_department_post_user'),
		'company_department_post_user' => array()
	);

	/**
	 * Belongs to relations
	 * @var array
	 */
	protected $_belongsTo = array(
		'user' => array()
	);

	/**
	 * Forbidden tags. If list of tags is empty, all tags will show.
	 * @var array
	 */
	protected $_forbiddenTags = array(
		'deleted',
		'user_id',
		/*'~address',
		'~phone',
		'~fax',
		'~site',
		'~email'*/
	);

	/**
	 * Constructor.
	 * @param int $id entity ID
	 */
	public function __construct($id = NULL)
	{
		parent::__construct($id);

		if (is_null($id) && !$this->loaded())
		{
			$oUserCurrent = Core_Entity::factory('User', 0)->getCurrent();
			$this->_preloadValues['user_id'] = is_null($oUserCurrent) ? 0 : $oUserCurrent->id;
			$this->_preloadValues['guid'] = Core_Guid::get();
		}
	}

	/**
	 * Company departments tree
	 * @var array
	 */
	static protected $_aDepartmentsTree = array();

	/**
	 * Company departments tree with users and users posts
	 * @var array
	 */
	protected $_aDepartmentsUsersPostsTree = array();

	protected function _createDepartmentUsersPostsTree($iCompanyDepartmentParentId = 0)
	{
		$aReturn = array();

		$aCompanyDepartments = $this->Company_Departments->getAllByParent_id($iCompanyDepartmentParentId);

		if (count($aCompanyDepartments))
		{
			foreach ($aCompanyDepartments as $oCompanyDepartment)
			{
				$aCompanyDepartmentInfo = array();

				$aCompanyDepartmentInfo['department'] = $oCompanyDepartment;
				$aCompanyDepartmentInfo += $this->_createDepartmentUsersPostsTree($oCompanyDepartment->id);

				$oDepartmentUsers = $oCompanyDepartment->Users;

				$oDepartmentUsers->queryBuilder()
					->groupBy('users.id');

				$aDepartmentUsers = $oDepartmentUsers->findAll();

				foreach ($aDepartmentUsers as $oDepartmentUser)
				{
					$aUserInfo = array();
					$aUserInfo['user'] = $oDepartmentUser;

					$aUserCompanyPosts = $oDepartmentUser->getCompanyPostsByDepartment($oCompanyDepartment->id);
					foreach ($aUserCompanyPosts as $oUserCompanyPost)
					{
						$aUserInfo['user_posts'][] = $oUserCompanyPost;
					}

					$aCompanyDepartmentInfo['users'][] = $aUserInfo;
				}

				$aReturn['departments'][] = $aCompanyDepartmentInfo;
			}
		}

		return $aReturn;
	}

	protected function _setDepartmentsUsersPostsTree()
	{
		$this->_aDepartmentsUsersPostsTree = $this->_createDepartmentUsersPostsTree();

		return $this;
	}

	/**
	 * Показ прав доступа к этапу сделки отделов и сотрудников с учетом организационной структуры компании
	 * @var array $aDepartment информация об отделе
	 */
	public function showDepartmentsAndUsers4DealTemplateStepAccess($deal_template_step_id, $aDepartment = NULL)
	{
		if (is_null($aDepartment))
		{
			// Построение массива, содержащего структуру компании
			$this->_setDepartmentsUsersPostsTree();

			if (!isset($this->_aDepartmentsUsersPostsTree['departments']))
			{
				return;
			}
			$aDepartment = $this->_aDepartmentsUsersPostsTree;
		}

		if (is_array($aDepartment) && count($aDepartment))
		{
			if (isset($aDepartment["department"]))
			{
				$issetChildrenItems =  isset($aDepartment["users"]) || isset($aDepartment["departments"]);

				$aUsers = $aDepartment["department"]->getHeads();

				$aHeadIds = array();
				foreach ($aUsers as $oUser)
				{
					$aHeadIds[] = $oUser->id;
				}

				?><div id="department<?php echo $aDepartment["department"]->id?>"><div class="depatment_info"><div class="title_department"><?php echo ($issetChildrenItems ? '<i class="fa fa-caret-down fa-fw"></i>' : '') . htmlspecialchars($aDepartment["department"]->name)?><span class="icons_permissions"><?php

				$oDeal_Template_Step_Access_Department = $aDepartment["department"]->Deal_Template_Step_Access_Departments->getByDeal_template_step_id($deal_template_step_id);

				for ($bitNumber = 0; $bitNumber < 4 ; $bitNumber++)
				{
					$bitValue = !is_null($oDeal_Template_Step_Access_Department) ? Core_Bit::getBit($oDeal_Template_Step_Access_Department->access, $bitNumber) : 0;

					switch($bitNumber)
					{
						case 0:
							$actionName = 'create';
							$actionTitle = Core::_('Deal_Template_Step.actionTitleCreate');
							break;

						case 1:
							$actionName = 'edit';
							$actionTitle = Core::_('Deal_Template_Step.actionTitleEdit');
							break;

						case 2:
							$actionName = 'show';
							$actionTitle = Core::_('Deal_Template_Step.actionTitleShow');
							break;

						case 3:
							$actionName = 'delete';
							$actionTitle = Core::_('Deal_Template_Step.actionTitleDelete');
							break;
					}
					?><i id="department_<?php echo $aDepartment["department"]->id . '_' . $deal_template_step_id . '_' . $bitNumber?>" title="<?php echo $actionTitle?>" data-action="<?php echo $actionName?>" data-allowed="<?php echo $bitValue?>" class="fa <?php echo ($bitValue ? 'fa-circle' : 'fa-circle-o')?>"></i><?php
				}
				?></span></div></div>
				<?php
				if ($issetChildrenItems)
				{
					?><div class="wrap"><?php
				}
			}
			else
			{
				?><div id="company<?php echo $this->id?>"><?php
			}

			if (isset($aDepartment["users"]))
			{
				?><div class="users">
					<!-- <div class="title_users"><i class="fa fa-caret-down fa-fw"></i><?php echo Core::_('User.ua_link_users_site')?></div>-->
					<div class="list_users"><?php

				foreach ($aDepartment["users"] as $aUserInfo)
				{
					$oDeal_Template_Step_Access_User = $aUserInfo['user']->Deal_Template_Step_Access_Users->getByDeal_template_step_id($deal_template_step_id);

					?><div class="user"><div class="user_info">
					<img class="user_ico img-circle" src="<?php echo htmlspecialchars($aUserInfo['user']->getAvatar() . '?rand=' . rand())?>" />
					<div class="user_details"><div class="user_name semi-bold"><?php echo htmlspecialchars($aUserInfo['user']->getFullName())?>
					<?php
					if (in_array($aUserInfo['user']->id, $aHeadIds))
					{
						?><i class="fa fa-star margin-left-5 gold"></i><?php
					}
					?>
					</div><?php

					$aCompany_Posts = $aUserInfo['user']->Company_Posts->findAll();

					if (count($aCompany_Posts))
					{
						?><div class="posts small"><?php

						$aCompanyPostName = array();

						foreach ($aCompany_Posts as $oCompany_Post)
						{
							$aCompanyPostName[] = htmlspecialchars($oCompany_Post->name);
						}

						echo implode(', ', $aCompanyPostName)
						?></div><?php
					}
					?><span class="icons_permissions"><?php

					for ($bitNumber = 0; $bitNumber < 4 ; $bitNumber++)
					{
						$bitValue = !is_null($oDeal_Template_Step_Access_User) ? Core_Bit::getBit($oDeal_Template_Step_Access_User->access, $bitNumber) : 0;

						switch($bitNumber)
						{
							case 0:
								$actionName = 'create';
								$actionTitle = Core::_('Deal_Template_Step.actionTitleCreate');
								break;

							case 1:
								$actionName = 'edit';
								$actionTitle = Core::_('Deal_Template_Step.actionTitleEdit');
								break;

							case 2:
								$actionName = 'show';
								$actionTitle = Core::_('Deal_Template_Step.actionTitleShow');
								break;

							case 3:
								$actionName = 'delete';
								$actionTitle = Core::_('Deal_Template_Step.actionTitleDelete');
								break;
						}

						?><i id="user_<?php echo $aUserInfo['user']->id . '_' . $deal_template_step_id . '_' . $bitNumber?>" title="<?php echo $actionTitle?>" data-action="<?php echo $actionName?>" data-allowed="<?php echo $bitValue?>" class="fa <?php echo ($bitValue ? 'fa-circle' : 'fa-circle-o')?>"></i><?php

					}
					?></span></div></div></div><?php
				}
				?></div></div><?php
			}

			if (isset($aDepartment["departments"]))
			{
				?><div class="departments"><?php

				foreach ($aDepartment["departments"] as $aDepartmentInfo)
				{
					$this->showDepartmentsAndUsers4DealTemplateStepAccess($deal_template_step_id, $aDepartmentInfo);
				}

				?></div><?php
			}

			if (isset($issetChildrenItems) && $issetChildrenItems)
			{
				?></div><?php
			}

			?></div><?php
		}
	}

	/**
	 * Build visual representation of group tree
	 * @param int $iInformationsystemId information system ID
	 * @param int $iInformationsystemGroupParentId parent ID
	 * @param int $aExclude exclude group ID
	 * @param int $iLevel current nesting level
	 * @return array
	 */
	static public function fillDepartments($iCompanyId, $iCompanyDepartmentParentId = 0, $aExclude = array(), $iLevel = 0)
	{
		$iCompanyId = intval($iCompanyId);
		$iCompanyDepartmentParentId = intval($iCompanyDepartmentParentId);
		$iLevel = intval($iLevel);

		if ($iLevel == 0)
		{
			$aTmp = Core_QueryBuilder::select('id', 'parent_id', 'name')
				->from('company_departments')
				->where('company_id', '=', $iCompanyId)
				->where('deleted', '=', 0)
				->orderBy('name')
				->execute()->asAssoc()->result();

			foreach ($aTmp as $aDepartment)
			{
				self::$_aDepartmentsTree[$aDepartment['parent_id']][] = $aDepartment;
			}
		}

		$aReturn = array();

		if (isset(self::$_aDepartmentsTree[$iCompanyDepartmentParentId]))
		{
			$countExclude = count($aExclude);
			foreach (self::$_aDepartmentsTree[$iCompanyDepartmentParentId] as $childrenDepartment)
			{
				if ($countExclude == 0 || !in_array($childrenDepartment['id'], $aExclude))
				{
					$aReturn[$childrenDepartment['id']] = str_repeat('  ', $iLevel) . htmlspecialchars($childrenDepartment['name']);
					$aReturn += self::fillDepartments($iCompanyId, $childrenDepartment['id'], $aExclude, $iLevel + 1);
				}
			}
		}

		$iLevel == 0 && self::$_aDepartmentsTree = array();

		return $aReturn;
	}

	/**
	 * Build visual representation of group tree
	 * @param int $iInformationsystemId information system ID
	 * @param int $iInformationsystemGroupParentId parent ID
	 * @param int $aExclude exclude group ID
	 * @param int $iLevel current nesting level
	 * @return array
	 */
	static public function fillDepartmentsAndUsers($iCompanyId, $iCompanyDepartmentParentId = 0, $aExclude = array(), $iLevel = 0)
	{
		$iCompanyId = intval($iCompanyId);
		$iCompanyDepartmentParentId = intval($iCompanyDepartmentParentId);
		$iLevel = intval($iLevel);

		if ($iLevel == 0)
		{
			self::$_aDepartmentsTree = array();
			$aTmp = Core_QueryBuilder::select('id', 'parent_id', 'name')
				->from('company_departments')
				->where('company_id', '=', $iCompanyId)
				->where('deleted', '=', 0)
				->orderBy('name')
				->execute()->asAssoc()->result();

			foreach ($aTmp as $aDepartment)
			{
				self::$_aDepartmentsTree[$aDepartment['parent_id']][] = $aDepartment;
			}
		}

		$aReturn = array();

		if (isset(self::$_aDepartmentsTree[$iCompanyDepartmentParentId]))
		{
			$countExclude = count($aExclude);
			foreach (self::$_aDepartmentsTree[$iCompanyDepartmentParentId] as $childrenDepartment)
			{
				if (!$countExclude || !in_array($childrenDepartment['id'], $aExclude))
				{
					$iMarginLeft = ($iLevel + 1) * 15;

					$oOptgroup = new stdClass();
					$oOptgroup->attributes = array(
						'label' => htmlspecialchars($childrenDepartment['name']),
						'class' => 'company-department',
						'style' => "margin-left: {$iMarginLeft}px"
					);
					$oOptgroup->children = array();

					$oCompanyDepartment = Core_Entity::factory('Company_Department', $childrenDepartment['id']);
					$aDepartmentUsers = $oCompanyDepartment->Users->findAll();

					foreach ($aDepartmentUsers as $oDepartmentUser)
					{
						$aUserCompanyPosts = array();
						$aObjectUserCompanyPosts = $oDepartmentUser->getCompanyPostsByDepartment($childrenDepartment['id']);

						foreach ($aObjectUserCompanyPosts as $oObjectUserCompanyPost)
						{
							$aUserCompanyPosts[] = $oObjectUserCompanyPost->name;
						}
						$sUserCompanyPosts = implode('###', $aUserCompanyPosts);

						$sOptionValue = htmlspecialchars($oDepartmentUser->getFullName()) . '%%%' . htmlspecialchars($oCompanyDepartment->name)
							. '%%%' . (!empty($sUserCompanyPosts) ? htmlspecialchars($sUserCompanyPosts) : '')
							. '%%%' . htmlspecialchars($oDepartmentUser->getAvatar() . '?rand=' . rand());

						$oOptgroup->children[/*$iCompanyId . '_' . $childrenDepartment['id'] . '_' . */$oDepartmentUser->id] = array(
							'value' => $sOptionValue,
							'attr' => array('class' => 'user-name', 'style' => "margin-left: {$iMarginLeft}px")
						);
					}

					$oOptgroup->children += self::fillDepartmentsAndUsers($iCompanyId, $childrenDepartment['id'], $aExclude, $iLevel + 1);

					$aReturn['company_department_' . $childrenDepartment['id']] = $oOptgroup;
				}
			}
		}

		//$iLevel == 0 && self::$_aDepartmentsTree = array();

		return $aReturn;
	}

	/**
	 * Backend callback method
	 * @param Admin_Form_Field $oAdmin_Form_Field
	 * @param Admin_Form_Controller $oAdmin_Form_Controller
	 * @return string
	 */
	public function nameBadge($oAdmin_Form_Field, $oAdmin_Form_Controller)
	{
		$Company_Department_Post_Users = $this->Company_Department_Post_Users;
		$Company_Department_Post_Users->queryBuilder()
			->groupBy('user_id');

		$count = count($Company_Department_Post_Users->findAll());
		$count && Core::factory('Core_Html_Entity_Span')
			->class('badge badge-hostcms badge-square')
			->value('<i class="fa fa-user"></i> ' . $count)
			->execute();

		$oCompany_Site = $this->Company_Sites->getBySite_id(CURRENT_SITE);

		!is_null($oCompany_Site) &&
			Core::factory('Core_Html_Entity_Span')
				->value('<i class="fa fa-check-circle-o palegreen"></i>')
				->execute();
	}

	/**
	 * Backend callback method
	 * @param Admin_Form_Field $oAdmin_Form_Field
	 * @param Admin_Form_Controller $oAdmin_Form_Controller
	 * @return string
	 */
	public function structureBadge($oAdmin_Form_Field, $oAdmin_Form_Controller)
	{
		$count = $this->Company_Departments->getCount();
		$count && Core::factory('Core_Html_Entity_Span')
			->class('badge badge-ico badge-azure white')
			->value($count < 100 ? $count : '∞')
			->title($count)
			->execute();
	}

	/**
	 * Delete object from database
	 * @param mixed $primaryKey primary key for deleting object
	 * @return Core_Entity
	 * @hostcms-event company.onBeforeRedeclaredDelete
	 */
	public function delete($primaryKey = NULL)
	{
		if (is_null($primaryKey))
		{
			$primaryKey = $this->getPrimaryKey();
		}

		$this->id = $primaryKey;

		Core_Event::notify($this->_modelName . '.onBeforeRedeclaredDelete', $this, array($primaryKey));

		$this->Company_Departments->deleteAll(FALSE);
		$this->Company_Department_Post_Users->deleteAll(FALSE);
		$this->Company_Sites->deleteAll(FALSE);

		$this->Directory_Addresses->deleteAll(FALSE);
		$this->Directory_Emails->deleteAll(FALSE);
		$this->Directory_Phones->deleteAll(FALSE);
		$this->Directory_Websites->deleteAll(FALSE);

		return parent::delete($primaryKey);
	}

	/**
	 * Get XML for entity and children entities
	 * @return string
	 * @hostcms-event company.onBeforeRedeclaredGetXml
	 */
	public function getXml()
	{
		Core_Event::notify($this->_modelName . '.onBeforeRedeclaredGetXml', $this);

		$aDirectory_Addresses = $this->Directory_Addresses->findAll(FALSE);
		$aDirectory_Phones = $this->Directory_Phones->findAll(FALSE);
		$aDirectory_Websites = $this->Directory_Websites->findAll(FALSE);
		$aDirectory_Emails = $this->Directory_Emails->findAll(FALSE);

		$this
			->addEntities($aDirectory_Addresses)
			->addEntities($aDirectory_Phones)
			->addEntities($aDirectory_Emails)
			->addEntities($aDirectory_Websites);

		return parent::getXml();
	}
}