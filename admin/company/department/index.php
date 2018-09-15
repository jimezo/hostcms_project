<?php
/**
 * Department.
 *
 * @package HostCMS
 * @version 6.x
 * @author Hostmake LLC
 * @copyright © 2005-2015 ООО "Хостмэйк" (Hostmake LLC), http://www.hostcms.ru
 */

require_once('../../../bootstrap.php');

Core_Auth::authorization($sModule = 'company');

$oAdmin_Form_Controller = Admin_Form_Controller::create();

$sAdminFormAction = '/admin/company/department/index.php';

$company_id = Core_Array::getRequest('company_id');
$oCompany = Core_Entity::factory('Company', $company_id);

// Контроллер формы
$oAdmin_Form_Controller
	->module(Core_Module::factory($sModule))
	->title(Core::_('Company_Department.title', $oCompany->name))
	->setUp();

ob_start();

$oAdmin_View = Admin_View::create();
$oAdmin_View
	->module(Core_Module::factory($sModule))
	->pageTitle(Core::_('Company_Department.title', $oCompany->name));

// Элементы строки навигации
$oAdmin_Form_Entity_Breadcrumbs = Admin_Form_Entity::factory('Breadcrumbs');

$sAdditionalParams = 'company_id=' . $company_id;

// Добавляем крошку на текущую форму
$oAdmin_Form_Entity_Breadcrumbs->add(
	Admin_Form_Entity::factory('Breadcrumb')
		->name(Core::_('Company.company_show_title2'))
		->href(
			$oAdmin_Form_Controller->getAdminLoadHref('/admin/company/index.php', NULL, NULL, '')
		)
		->onclick(
			$oAdmin_Form_Controller->getAdminLoadAjax('/admin/company/index.php', NULL, NULL, '')
		)
)->add(
	Admin_Form_Entity::factory('Breadcrumb')
		->name(Core::_('Company_Department.title', $oCompany->name))
		->href(
			$oAdmin_Form_Controller->getAdminLoadHref($oAdmin_Form_Controller->getPath(), NULL, NULL, $sAdditionalParams)
		)
		->onclick(
			$oAdmin_Form_Controller->getAdminLoadAjax($oAdmin_Form_Controller->getPath(), NULL, NULL, $sAdditionalParams)
		)
);

// Добавляем все хлебные крошки контроллеру
$oAdmin_View->addChild($oAdmin_Form_Entity_Breadcrumbs);

//$aCompanies = Core_Entity::factory('Site', CURRENT_SITE)->Companies->findAll();

$sStatusMessage = '';

//if (count($aCompanies))
//{
	$windowId = $oAdmin_Form_Controller->getWindowId();

	$oContent = Admin_Form_Entity::factory('Div')
			->controller($oAdmin_Form_Controller);

	// Действие "Добавить/редактировать отдел"
	if ($oAdmin_Form_Controller->getAction() == 'addEditDepartment')
	{
		if (is_null($sOperation = $oAdmin_Form_Controller->getOperation()))
		{
			$iCompanyId = intval(Core_Array::getGet('company_id'));
			$iDepartmentId = intval(Core_Array::getGet('department_id'));

			$oCompany = Core_Entity::factory('Company', $iCompanyId);

			$oDepartment = Core_Entity::factory('Company_Department', $iDepartmentId ? $iDepartmentId : NULL);

			ob_start();
			// Форма добавления/редактирования отдела

			// Email'ы отдела
			$aDirectory_Email_Types = Core_Entity::factory('Directory_Email_Type')->findAll();

			$aMasDirectoryEmailTypes = array();

			foreach ($aDirectory_Email_Types as $oDirectory_Email_Type)
			{
				$aMasDirectoryEmailTypes[$oDirectory_Email_Type->id] = $oDirectory_Email_Type->name;
			}

			$aCompany_Department_Directory_Emails = $oDepartment->Company_Department_Directory_Emails->findAll();

			$oAdditionalDataInnerWrapperEmails = Admin_Form_Entity::factory('Div')
				->class('well with-header')
				->add(
					Admin_Form_Entity::factory('Div')
						->class('header bordered-magenta bg-palegreen')
						->add(Admin_Form_Entity::factory('Code')
								->html('<i class="widget-icon fa fa-envelope icon-separator"></i>' . Core::_('Directory_Email.emails'))
						)
				);

			$oButtons = Admin_Form_Entity::factory('Div') // div с кноками + и -
				->class('no-padding add-remove-property margin-top-23 pull-left')
				->add(
					Admin_Form_Entity::factory('Code')
						->html('<div class="btn btn-palegreen" onclick="$.cloneFormRow(this); event.stopPropagation();">
									<i class="fa fa-plus-circle close"></i>
								</div>
								<div class="btn btn-darkorange btn-delete' . (count($aCompany_Department_Directory_Emails) ? '' : ' hide')  . '" onclick="$.deleteFormRow(this); event.stopPropagation();">
									<i class="fa fa-minus-circle close"></i>
								</div>')
				);

			// Email'ы сотрудника
			$oDepartmentEmailsRow = Directory_Controller_Tab::instance('email')
				->title(Core::_('Directory_Email.emails'))
				->relation($oDepartment->Company_Department_Directory_Emails)
				->execute();

			// Телефоны
			$oDepartmentPhonesRow = Directory_Controller_Tab::instance('phone')
				->title(Core::_('Directory_Phone.phones'))
				->relation($oDepartment->Company_Department_Directory_Phones)
				->execute();

			Admin_Form_Entity::factory('Div')
				->controller($oAdmin_Form_Controller)
				->id('addEditDepartmentModal')
				->class('tabbable')
				->add(
					Admin_Form_Entity::factory('Form')
						->action($oAdmin_Form_Controller->getPath())
						->add(
							Admin_Form_Entity::factory('Code')
								->html('<ul id="addEditDepartmentTabModal" class="nav nav-tabs">
											<li class="active">
												<a href="#addEditDepartmentMainTab" data-toggle="tab" aria-expanded="true">' . Core::_('Admin_Form.form_forms_tab_1') . '</a>
											</li>

											<li class="tab-red">
												<a href="#addEditDepartmentAdditionalTab" data-toggle="tab" aria-expanded="false">' . Core::_('Admin_Form.form_forms_tab_2') . '</a>
											</li>
										</ul>')
						)
						->add(
							Admin_Form_Entity::factory('Div')
								->class('tab-content')
								->add(
									Admin_Form_Entity::factory('Div')
										->id('addEditDepartmentMainTab')
										->class('tab-pane active')
										->add(
											Admin_Form_Entity::factory('Div')
												->class('row')
												->add(
													Admin_Form_Entity::factory('Input')
														->type('text')
														->class('form-control')
														->name('name')
														->value($oDepartment->name)
														->caption(Core::_('Company_Department.name'))
														->divAttr(array('class' => 'form-group col-lg-12 col-md-6 col-sm-6'))
												)
												->add(
													Admin_Form_Entity::factory('Select')
														->name('department_parent_id')
														->caption(Core::_('Company_Department.parent_id'))
														->options(
															array(' … ') + $oCompany->fillDepartments($iCompanyId, 0)
														)
														->value($oDepartment->parent_id ? $oDepartment->parent_id : 0)
														->filter(TRUE)
														->caseSensitive(FALSE)
												)
												->add(
													Admin_Form_Entity::factory('Input')
														->type('text')
														->class('form-control')
														->name('address')
														->value($oDepartment->address)
														->caption(Core::_('Company_Department.address'))
														->divAttr(array('class' => 'form-group col-lg-12 col-md-6 col-sm-6'))
												)
												->add(
													Admin_Form_Entity::factory('Textarea')
														->class('form-control')
														->name('description')
														->value($oDepartment->description)
														->caption(Core::_('Company_Department.description'))
														->divAttr(array('class' => 'form-group col-lg-12 col-md-6 col-sm-6'))
												)
												->add(
													Admin_Form_Entity::factory('Input')
														->divAttr(array('class' => ''))
														->type('hidden')
														->name('department_id')
														->value($iDepartmentId)
												)
												->add(
													Admin_Form_Entity::factory('Input')
														->divAttr(array('class' => ''))
														->type('hidden')
														->name('company_id')
														->value($iCompanyId)
												)
										)
								)
								->add(
									Admin_Form_Entity::factory('Div')
										->id('addEditDepartmentAdditionalTab')
										->class('tab-pane')
										->add($oDepartmentEmailsRow)
										->add($oDepartmentPhonesRow)
								)
						)
						->add(
							Admin_Form_Entity::factory('Code')
								->html('<script>changeFilterFieldWindowId(\'addEditDepartmentModal\')</script>')
						)
				)

				//->style('display:none')
				->execute();

			$sAddEditDepartmentFormContent = Core_Str::escapeJavascriptVariable(ob_get_clean());

			$oContent->add(
				Admin_Form_Entity::factory('Code')
					->html('
						<script>
							var depatmentId = ' . ($oDepartment->id ? $oDepartment->id : 0) . ';

							bootbox.dialog({
								//message: $("#addEditDepartmentModal").html(),
								message: \'' . $sAddEditDepartmentFormContent . '\',
								title: depatmentId ? "' . Core::_('Company_Department.edit_form_title') . '" : "' . Core::_('Company_Department.add_form_title') . '",
								className: "modal-darkorange",
								backdrop: false,
								buttons: {
									success: {
										label: depatmentId ? "' . Core::_('Company_Department.edit') . '" : "' . Core::_('Company_Department.add') . '",
										className: "btn-blue",
										callback: function() {

											$.adminSendForm({buttonObject: $(this).find(\'form\'), operation: \'addEditDepartment\', action: \'addEditDepartment\', windowId: \'' . $windowId . '\'});
										}
									},
									cancel: {
										label: "' . Core::_('Company_Department.cancel') . '",
										className: "btn-default",
										//callback: function() {}
									}
								},
								onEscape: true
							});
						</script>'
					)
			);

			$oContent->execute();
			$sContent = ob_get_clean();

			echo Core::showJson(
				array('error' => $sContent , 'form_html' => '')
			);
		}
		elseif ($sOperation == 'addEditDepartment')
		{
			$sDepartmentName = trim(Core_Array::getPost('name'));
			$iDepartmentParentId = intval(Core_Array::getPost('department_parent_id'));
			$sDepartmentAddress = trim(Core_Array::getPost('address'));
			$sDepartmentDescription = trim(Core_Array::getPost('description'));
			$iCompanyId = intval(Core_Array::getPost('company_id'));
			$iDepartmentId = intval(Core_Array::getPost('department_id'));

			$oDepartment = Core_Entity::factory('Company_Department', $iDepartmentId ? $iDepartmentId : NULL);

			$oDepartment
				->parent_id($iDepartmentParentId)
				->company_id($iCompanyId)
				->name($sDepartmentName)
				->address($sDepartmentAddress)
				->description($sDepartmentDescription)
				->save();

			// Электронные адреса, установленные значения
			$aCompany_Department_Directory_Emails = $oDepartment->Company_Department_Directory_Emails->findAll();

			foreach ($aCompany_Department_Directory_Emails as $oCompany_Department_Directory_Email)
			{
				$sEmail = trim(Core_Array::getPost("email#{$oCompany_Department_Directory_Email->id}"));

				if (!empty($sEmail))
				{
					$oDirectory_Email = $oCompany_Department_Directory_Email->Directory_Email;
					$oDirectory_Email
						->directory_email_type_id(intval(Core_Array::getPost("email_type#{$oCompany_Department_Directory_Email->id}", 0)))
						->value($sEmail)
						->save();
				}
				else
				{
					// Удаляем пустую строку с полями
					$oCompany_Department_Directory_Email->Directory_Email->delete();
				}
			}

			// Электронные адреса, новые значения
			$aEmails = Core_Array::getPost('email');
			$aEmail_Types = Core_Array::getPost('email_type');

			if (count($aEmails))
			{
				foreach ($aEmails as $key => $sEmail)
				{
					$sEmail = trim($sEmail);

					if (!empty($sEmail))
					{
						$oDirectory_Email = Core_Entity::factory('Directory_Email')
							->directory_email_type_id(intval(Core_Array::get($aEmail_Types, $key)))
							->value($sEmail)
							->save();

						$oDepartment->add($oDirectory_Email);
					}
				}
			}

			// Телефоны, установленные значения
			$aCompany_Department_Directory_Phones = $oDepartment->Company_Department_Directory_Phones->findAll();
			foreach ($aCompany_Department_Directory_Phones as $oCompany_Department_Directory_Phone)
			{
				$sPhone = trim(Core_Array::getPost("phone#{$oCompany_Department_Directory_Phone->id}"));

				if (!empty($sPhone))
				{
					$oDirectory_Phone = $oCompany_Department_Directory_Phone->Directory_Phone;
					$oDirectory_Phone
						->directory_phone_type_id(intval(Core_Array::getPost("phone_type#{$oCompany_Department_Directory_Phone->id}", 0)))
						->value($sPhone)
						->save();
				}
				else
				{
					$oCompany_Department_Directory_Phone->Directory_Phone->delete();
				}
			}

			// Телефоны, новые значения
			$aPhones = Core_Array::getPost('phone');
			$aPhone_Types = Core_Array::getPost('phone_type');

			if (count($aPhones))
			{
				foreach ($aPhones as $key => $sPhone)
				{
					$sPhone = trim($sPhone);

					if (!empty($sPhone))
					{
						$oDirectory_Phone = Core_Entity::factory('Directory_Phone')
							->directory_phone_type_id(intval(Core_Array::get($aPhone_Types, $key)))
							->value($sPhone)
							->save();

						$oDepartment->add($oDirectory_Phone);
					}
				}
			}

			$sStatusMessage = Core_Message::get($iDepartmentId ? Core::_('Company_Department.apply_success') : Core::_('Company_Department.add_success'));
		}
		elseif ($sOperation == 'changeParentDepartment')
		{
			$iCompanyId = intval(Core_Array::getGet('company_id'));
			$iDepartmentId = intval(Core_Array::getGet('department_id'));
			$iNewParentDepartmentId = intval(Core_Array::getGet('new_parent_id'));

			if ($iDepartmentId)
			{
				$oDepartment = Core_Entity::factory('Company_Department', $iDepartmentId)
					->company_id($iCompanyId)
					->parent_id($iNewParentDepartmentId)
					->save();

				$sStatusMessage = Core_Message::get("Вышестоящий отдел для \"{$oDepartment->name}\" изменен.");
			}

			echo Core::showJson(
				array('error' => $sStatusMessage, 'form_html' => '')
			);
		}
	}

	// Действие "Удалить отдел"
	if ($oAdmin_Form_Controller->getAction() == 'deleteDepartment')
	{
		if (!is_null($sOperation = $oAdmin_Form_Controller->getOperation()) && $sOperation == 'deleteDepartment')
		{
			$iDepartmentId = intval(Core_Array::getGet('department_id'));

			//пример в /admin/document/index.php $oDocument_Dir = Core_Entity::factory('Document_Dir')->find($document_dir_id);
			$oDepartment = Core_Entity::factory('Company_Department')->find($iDepartmentId);

			ob_start();

			if (!is_null($oDepartment->id))
			{
				$oDepartment->markDeleted();

				$oContent->add(
					Admin_Form_Entity::factory('Code')
						->html('
							<script>

								$("#' . $windowId .' li.dd-item[data-id=\'' . $iDepartmentId . '\']").remove();
							</script>'
						)
				);

				$oContent->execute();

				$sTypeMessage = 'message';
			}
			else
			{
				$sTypeMessage = 'error';
			}

			$sContent = ob_get_clean();

			$sStatusMessage = Core_Message::get(!is_null($oDepartment->id) ? Core::_('Company_Department.markDeleted_success') : Core::_('Company_Department.markDeleted_error'), $sTypeMessage);

			echo Core::showJson(
				array('error' => $sStatusMessage . $sContent, 'form_html' => '')
			);
		}
	}

	// Действие "Добавить/редактировать должность сотрудника в отделе"
	if ($oAdmin_Form_Controller->getAction() == 'addEditUserDepartment')
	{
		if (is_null($sOperation = $oAdmin_Form_Controller->getOperation()))
		{
			$iCompanyId = intval(Core_Array::getGet('company_id'));
			$iDepartmentId = intval(Core_Array::getGet('department_id'));

			$oDepartment = Core_Entity::factory('Company_Department')->find($iDepartmentId);

			$iUserId = intval(Core_Array::getGet('user_id'));

			$iCompanyPostId = intval(Core_Array::getGet('company_post_id'));

			if (!is_null($oDepartment->id) && $oDepartment->company_id == $iCompanyId)
			{
				$oCompany = $oDepartment->Company;

				$aMasDepartmentUsers = array();

				$aUsers = Core_Entity::factory('User')->findAll();

				foreach ($aUsers as $oUser)
				{
					$aMasDepartmentUsers[$oUser->id] = $oUser->getFullName();
				}

				$aMasCompanyPosts = array();
				$aCompanyPosts = Core_Entity::factory('Company_Post')->findAll();

				foreach ($aCompanyPosts as $oCompanyPost)
				{
					$aMasCompanyPosts[$oCompanyPost->id] = $oCompanyPost->name;
				}

				$iDepartmentPostHead = 0;

				if ($iDepartmentId && $iCompanyPostId && $iUserId)
				{
					$oCompany_Department_Post_User = Core_Entity::factory('Company_Department_Post_User');
					$oCompany_Department_Post_User
						->queryBuilder()
						->where('company_department_post_users.company_department_id', '=', $iDepartmentId)
						->where('company_department_post_users.company_post_id', '=', $iCompanyPostId)
						->where('company_department_post_users.user_id', '=', $iUserId);

					$aCompany_Department_Post_Users = $oCompany_Department_Post_User->findAll();

					if (isset($aCompany_Department_Post_Users[0]))
					{
						$iDepartmentPostHead = $aCompany_Department_Post_Users[0]->head;
					}
				}

				// Форма добавления сотрудника в отдел
				ob_start();
				Admin_Form_Entity::factory('Div')
					->controller($oAdmin_Form_Controller)
					->id('addEditUserDepartmentModal')
					->add(
						Admin_Form_Entity::factory('Form')
							->action($oAdmin_Form_Controller->getPath())
							->add(
								Admin_Form_Entity::factory('Div')
									->class('row')
									->add(
										Admin_Form_Entity::factory('Select')
											->name('user_id')
											->caption(Core::_('User.caption'))
											->options($aMasDepartmentUsers)
											->value($iUserId)
											->filter(TRUE)
											->caseSensitive(FALSE)
									)
									->add(
										Admin_Form_Entity::factory('Select')
											->name('department_id')
											->caption(Core::_('Company_Department.caption'))
											->options(
												array(' … ') + $oCompany->fillDepartments($iCompanyId, 0)
											)
											->value($iDepartmentId)
											->filter(TRUE)
											->caseSensitive(FALSE)
									)
									->add(
										Admin_Form_Entity::factory('Select')
											->name('company_post_id')
											->caption(Core::_('Company_Post.caption'))
											->options($aMasCompanyPosts)
											->value($iCompanyPostId)
											->filter(TRUE)
											->caseSensitive(FALSE)
									)
									->add(
										Admin_Form_Entity::factory('Checkbox')
											->class('form-control')
											->name('head')
											->caption(Core::_('User.head'))
											->checked($iDepartmentPostHead ? $iDepartmentPostHead : NULL)
											->value($iDepartmentPostHead)
											->divAttr(array('class' => 'form-group col-lg-12 col-md-6 col-sm-6'))
									)
									->add(
										Admin_Form_Entity::factory('Input')
											->divAttr(array('class' => ''))
											->type('hidden')
											->name('company_id')
											->value($iCompanyId)
									)
									->add(
										Admin_Form_Entity::factory('Input')
											->divAttr(array('class' => ''))
											->type('hidden')
											->name('original_department_id')
											->value($oDepartment->id)
									)
									->add(
										Admin_Form_Entity::factory('Input')
											->divAttr(array('class' => ''))
											->type('hidden')
											->name('original_company_post_id')
											->value($iCompanyPostId)
									)
									->add(
										Admin_Form_Entity::factory('Input')
											->divAttr(array('class' => ''))
											->type('hidden')
											->name('original_user_id')
											->value($iUserId)
									)
							)
							->add(
								Admin_Form_Entity::factory('Code')
									->html('<script>changeFilterFieldWindowId(\'addEditUserDepartmentModal\')</script>')
							)
					)

					->execute();

				$sAddEditUserFormContent  = Core_Str::escapeJavascriptVariable(ob_get_clean());

				$oContent->add(
					Admin_Form_Entity::factory('Code')
						->html('
							<script>
								bootbox.dialog({
									message: \'' . $sAddEditUserFormContent  . '\',
									title: "' . ($iUserId ? Core::_('Company_Department.edit_user_title') : Core::_('Company_Department.add_user_title')) . '",
									className: "modal-darkorange",
									backdrop: false,
									buttons: {
										success: {
											label: "' . ($iUserId ? Core::_('Company_Department.edit') : Core::_('Company_Department.add')) . '",
											className: "btn-blue",
											callback: function() {
														$.adminSendForm({buttonObject: $(this).find(\'form\'), operation: \'addEditUserDepartment\', action: \'addEditUserDepartment\', windowId: \'' . $windowId . '\'});
													}
										},
										cancel: {
											label: "' . Core::_('Company_Department.cancel') . '",
											className: "btn-default",
											//callback: function() {}
										}
									},
									onEscape: true
								});

							</script>'
						)
				);

				$oContent->execute();
				$sContent = ob_get_clean();

				echo Core::showJson(
					array('error' => $sContent , 'form_html' => '')
				);
			}
		}
		elseif ($sOperation == 'addEditUserDepartment')
		{
			$iDepartmentId = intval(Core_Array::getPost('department_id'));
			$oDepartment = Core_Entity::factory('Company_Department')->find($iDepartmentId);

			$iCompanyId = intval(Core_Array::getPost('company_id'));

			if (!is_null($oDepartment->id) && $oDepartment->company_id == $iCompanyId)
			{
				$iUserId =  intval(Core_Array::getPost('user_id'));

				$oUser = Core_Entity::factory('User', $iUserId);

				$iCompanyPostId = intval(Core_Array::getPost('company_post_id'));

				$oCompany_Post = Core_Entity::factory('Company_Post', $iCompanyPostId);

				$iOriginalDepartmentId = intval(Core_Array::getPost('original_department_id'));
				$iOriginalCompanyPostId = intval(Core_Array::getPost('original_company_post_id'));
				$iOriginalUserId = intval(Core_Array::getPost('original_user_id'));

				$iHead = !is_null(Core_Array::getPost('head')) ? intval(Core_Array::getPost('head')) : 0;

				$oCompany_Department_Post_Users = $oDepartment->Company_Department_Post_Users;

				// Получаем запись о должностей сотрудника в отделе
				$oCompany_Department_Post_Users
					->queryBuilder()
					->where('user_id', '=', $iUserId)
					->where('company_post_id', '=', $iCompanyPostId);

				$aCompany_Department_Post_Users = $oCompany_Department_Post_Users->findAll();

				// Уже есть запись о должности сотрудника в отделе, согласно переданным данным
				if (isset($aCompany_Department_Post_Users[0]))
				{
					// Сотрудник является начальником в отделе на этой должности
					if ($aCompany_Department_Post_Users[0]->head != $iHead && $iOriginalUserId)
					{
						$sStatusMessage = $iHead
											? Core_Message::get(Core::_('Company_Department.addUserToHeads_success', $oUser->getFullName(), $oDepartment->name))
											: Core_Message::get(Core::_('Company_Department.deleteUserFromHeads_success', $oUser->getFullName(), $oDepartment->name));

						$oCompany_Department_Post_User = $aCompany_Department_Post_Users[0];
					}
					elseif (!$iOriginalUserId)
					{
						//$sStatusMessage = Core_Message::get('<span class="primary">' . $oUser->getFullName() . '</span> уже находится на должности <span class="primary">' . $oCompany_Post->name . '</span> в <span class="primary">' .  $oDepartment->name . '</span>');
						$sStatusMessage = Core_Message::get(Core::_('Company_Department.addUserToHeads_error', $oUser->getFullName(), $oCompany_Post->name, $oDepartment->name), 'error');
					}
				}
				else // Запись о должности сотрудника в отделе отсутствует
				{
					// Редактируем информацию о должности сотрудника
					if ($iUserId == $iOriginalUserId)
					{
						$oOriginal_Department = Core_Entity::factory('Company_Department')->find($iOriginalDepartmentId);
						$oOriginal_Company_Department_Post_Users = $oOriginal_Department->Company_Department_Post_Users;

						// Новый вариант - начало

						// Получаем запись о прежней должности сотрудника в отделе
						$oOriginal_Company_Department_Post_Users
							->queryBuilder()
							->where('user_id', '=', $iOriginalUserId)
							->where('company_post_id', '=', $iOriginalCompanyPostId);

						$aOriginal_Company_Department_Post_Users = $oOriginal_Company_Department_Post_Users->findAll();

						if (isset($aOriginal_Company_Department_Post_Users[0]))
						{
							// Установка флагов
							// Изменения отдела
							$changeDepartment = $iDepartmentId != $iOriginalDepartmentId;

							// Изменения должности
							$changePost = $iCompanyPostId != $iOriginalCompanyPostId;

							// Изменения статуса руководителя
							$changeHead = $aOriginal_Company_Department_Post_Users[0]->head != $iHead;

							if ($changeDepartment || $changePost)
							{
								// Переведен на должность $iCompanyPostId, отдел $iDepartmentId
								$sStatusMessage = Core_Message::get(Core::_('Company_Department.changeUserDepartmentPost_success', $oUser->getFullName(), $oCompany_Post->name, $oDepartment->name));
							}

							if ($changeHead && !$changeDepartment)
							{
								$sStatusMessage .= $iHead
													? Core_Message::get(Core::_('Company_Department.addUserToHeads_success', $oUser->getFullName(), $oDepartment->name))
													: Core_Message::get(Core::_('Company_Department.deleteUserFromHeads_success', $oUser->getFullName(), $oDepartment->name));

							}
							elseif ($changeDepartment && $iHead)
							{
								// $sStatusMessage .= Core_Message::get('<span class="primary">' . $oUser->getFullName() . '</span> зачислен в руководство <span class="primary">' . $oDepartment->name . '</span>');
								$sStatusMessage .= Core_Message::get(Core::_('Company_Department.addUserToHeads_success', $oUser->getFullName(), $oDepartment->name));
							}

							$oCompany_Department_Post_User = $aOriginal_Company_Department_Post_Users[0];
						}
					}
					else // Добавление должности сотрудника
					{
						$oCompany_Department_Post_User = Core_Entity::factory('Company_Department_Post_User');

						// Сотрудник добавлен в отдел $iDepartmentId на должность $iCompanyPostId
						$sStatusMessage = Core_Message::get(Core::_('Company_Department.addUserToDepartmentPost_success', $oUser->getFullName(), $oCompany_Post->name, $oDepartment->name));

						if ($iHead)
						{
							// Зачислен в руководство отдела $iDepartmentId
							//$sStatusMessage .= Core_Message::get('<span class="primary">' . $oUser->getFullName() . '</span> зачислен в руководство <span class="primary">' . $oDepartment->name . '</span>');
							$sStatusMessage .= Core_Message::get(Core::_('Company_Department.addUserToHeads_success', $oUser->getFullName(), $oDepartment->name));
						}
					}
				}

				if (isset($oCompany_Department_Post_User))
				{
					$oCompany_Department_Post_User
							->company_id($iCompanyId)
							->company_post_id($iCompanyPostId)
							->user_id($iUserId)
							->head($iHead);
					$oDepartment->add($oCompany_Department_Post_User);
				}
			}
			else
			{
				$sStatusMessage = Core::_('Company_Depertment.departmentExistence_error'); //'Ошибка! Такого отдела не существует.';
				echo Core::showJson(
						array('error' => Core_Message::get($sStatusMessage, 'error'), 'form_html' => '')
					);
			}
		}
	}

	// Действие "Удалить сотрудника из отдела"
	if ($oAdmin_Form_Controller->getAction() == 'deleteUserFromDepartment')
	{
		if (!is_null($sOperation = $oAdmin_Form_Controller->getOperation()) && $sOperation == 'deleteUserFromDepartment')
		{
			$iDepartmentId = intval(Core_Array::getGet('department_id'));
			$iUserId = intval(Core_Array::getGet('user_id'));
			$iCompanyPostId = intval(Core_Array::getGet('company_post_id'));

			$oUser = Core_Entity::factory('User', $iUserId);

			$oCompany_Department_Post_Users = $oUser->Company_Department_Post_Users;
			$oCompany_Department_Post_Users
				->queryBuilder()
				->where('company_department_post_users.company_department_id', '=', $iDepartmentId)
				->where('company_department_post_users.company_post_id', '=', $iCompanyPostId);

			$aCompany_Department_Post_Users = $oCompany_Department_Post_Users->findAll();

			if (isset($aCompany_Department_Post_Users[0]))
			{
				$aCompany_Department_Post_Users[0]->delete();

				$oCompany_Department = Core_Entity::factory('Company_Department', $iDepartmentId);

				$aDepartmentUsers = $oCompany_Department->getEmployeesWithoutHeads();

				$oContent->add(
					Admin_Form_Entity::factory('Code')
						->html('
							<script>
								// Получаем элемент из списка руководителей
								var removeElement = $("li.dd-item[data-id = \'' . $iDepartmentId . '\'] div.user[data-user-id=\'' . $iUserId . '\'][data-company-post-id=\'' . $iCompanyPostId . '\']");

								// Получаем элемент из списка обычных сотрудников
								if (!removeElement.length)
								{
									removeElement = ' . (count($aDepartmentUsers)
										? '$("li.dd-item[data-id = \'' . $iDepartmentId . '\'] li.user[data-user-id=\'' . $iUserId . '\'][data-company-post-id=\'' . $iCompanyPostId . '\']")'
										: '$("li.dd-item[data-id = \'' . $iDepartmentId . '\'] div.department-users").eq(0)'
										) . ';
								}

								removeElement.remove();
								' . ( count($aDepartmentUsers) ?  '$("li.dd-item[data-id = \'' . $iDepartmentId . '\'] div.department-users span.count-users").eq(0).html("' . count($aDepartmentUsers)  .'")' : '') . '
							</script>'
						)
				);

				$oContent->execute();
				$sContent = ob_get_clean();

				$oCompany_Post = Core_Entity::factory('Company_Post', $iCompanyPostId);

				$sUserName = $oUser->getFullName();

				$sStatusMessage = Core::_('Company_Department.deleteUserFromDepartment_success', $sUserName, $oCompany_Post->name, $oCompany_Department->name);
				echo Core::showJson(
					array('error' => Core_Message::get($sStatusMessage) . $sContent , 'form_html' => '')
				);
			}
		}
	}

	$iCompanyId = intval(Core_Array::getRequest('company_id'));

	/*$aMasCompanies = array();

	foreach ($aCompanies as $oCompany)
	{
		$aMasCompanies[$oCompany->id] = $oCompany->name;

		!$iCompanyId && $iCompanyId = $oCompany->id;
	}*/

	$oCompany = Core_Entity::factory('Company', $iCompanyId);

	/*$oSelectCompanies =  Admin_Form_Entity::factory('Select')
		->id('company_id')
		->name('company_id')
		->value($iCompanyId)
		->caption(Core::_('Company_Department.company'))
		->options($aMasCompanies)
		->divAttr(array('class' => 'form-group col-lg-4 col-md-4 col-sm-4'));
		//->controller($oAdmin_Form_Controller);*/

	$oContent
		->add(
			Admin_Form_Entity::factory('Div')
				->class('row')
				->add(
					Admin_Form_Entity::factory('Div')
						->class('col-lg-12')
						->add(
							Admin_Form_Entity::factory('Div')
								->class('widget flat no-margin-bottom')
								->add(
									Admin_Form_Entity::factory('Div')
										->class('widget-body')
										->add(
											Admin_Form_Entity::factory('Div')
												->class('row')
												/*->add(
													$oSelectCompanies
														->onchange("$.adminLoad({path: '{$sAdminFormAction}', additionalParams: 'company_id=' + this.value, windowId : '{$windowId}'});")
												)*/
												->add(
													Admin_Form_Entity::factory('Div')
														->class('col-lg-3')
														->add(
															Admin_Form_Entity::factory('a')
																->id('addEditDepartment')
																->class('btn btn-palegreen')
																->add(
																	Admin_Form_Entity::factory('Code')
																		->html('<i class="fa fa-plus"></i>Добавить отдел')
																)
														)
												)
										)

								)
						)
				)
		);



	// Company_Controller_Show::create();

	$oCompany_Controller_Show = new Company_Controller_Show($oCompany);

	ob_start();

	$oCompany_Controller_Show
		->window($windowId)
		->path($sAdminFormAction)
		->show();

	$oContent->add(
		Admin_Form_Entity::factory('Code')
			->html(ob_get_clean())
	)
	->add(
		Admin_Form_Entity::factory('Code')
			->html('
				<script>
					$("#addEditDepartment").on("click", function () {
							$.adminLoad({path: \'' . $sAdminFormAction . '\', additionalParams: \'company_id=' . $iCompanyId . '\', action: \'addEditDepartment\', windowId: \'' . $windowId . '\'});
						}
					);

					// Функция замены windowId у полей фильтров выпадающих списков для обеспечения работы фильтрации во всплывающих окнах
					function changeFilterFieldWindowId(newFilterFieldWindowId)
					{
						if (newFilterFieldWindowId)
						{
							$("input[id ^= \'filer_field_id_\']").each( function() {
								var onKeyupText = $(this).attr(\'onkeyup\'),
									pos = onKeyupText.indexOf(\'oSelectFilter\') + \'oSelectFilter\'.length,
									suffix = onKeyupText.substr(pos, 1),
									index = \'oSelectFilter\' + suffix;

									if ( window[index] )
									{
										window[index].windowId = newFilterFieldWindowId;
									}
								}
							)
						}
					}
				</script>'
			)
	);

	$oContent->execute();

	$sContent = ob_get_clean();
//}

ob_start();

$oAdmin_View
	->content($sContent)
	->show();

Core_Skin::instance()->answer()
	->module($sModule)
	->ajax(Core_Array::getRequest('_', FALSE))
	->message($sStatusMessage)
	->content(ob_get_clean())
	->title(Core::_('Company_Department.title', $oCompany->name))
	->execute();