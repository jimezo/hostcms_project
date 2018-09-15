<?php
/**
 * Events.
 *
 * @package HostCMS
 * @version 6.x
 * @author Hostmake LLC
 * @copyright © 2005-2018 ООО "Хостмэйк" (Hostmake LLC), http://www.hostcms.ru
 */
require_once('../../bootstrap.php');

Core_Auth::authorization($sModule = 'event');

// File download
if (Core_Array::getGet('downloadFile'))
{
	$oEvent_Attachment = Core_Entity::factory('Event_Attachment')->find(intval(Core_Array::getGet('downloadFile')));
	if (!is_null($oEvent_Attachment->id))
	{
		$oUser = Core_Entity::factory('User', 0)->getCurrent();

		$oEvent_User = $oEvent_Attachment->Event->Event_Users->getByuser_id($oUser->id);

		if (!is_null($oEvent_User))
		{
			$filePath = $oEvent_Attachment->getFilePath();
			Core_File::download($filePath, $oEvent_Attachment->file_name, array('content_disposition' => 'inline'));
		}
		else
		{
			throw new Core_Exception('Access denied');
		}
	}
	else
	{
		throw new Core_Exception('Access denied');
	}

	exit();
}

// Код формы
$iAdmin_Form_Id = 220;
$sAdminFormAction = '/admin/event/index.php';

$oAdmin_Form = Core_Entity::factory('Admin_Form', $iAdmin_Form_Id);

// Контроллер формы
$oAdmin_Form_Controller = Admin_Form_Controller::create($oAdmin_Form);
$oAdmin_Form_Controller
	->module(Core_Module::factory($sModule))
	->setUp()
	->path($sAdminFormAction)
	->title(Core::_('Event.events_title'))
	->pageTitle(Core::_('Event.events_title'))
	->addView('kanban', 'Event_Controller_Kanban')
	// ->view('kanban')
	;

if (Core_Array::getPost('id') && Core_Array::getPost('target_status_id'))
{
	$aJSON = array();

	$iEventId = intval(Core_Array::getPost('id'));
	$iTargetStatusId = intval(Core_Array::getPost('target_status_id'));

	$oEvent_Status = Core_Entity::factory('Event_Status')->find($iTargetStatusId);
	if (!is_null($oEvent_Status->id))
	{
		$oEvent = Core_Entity::factory('Event')->find($iEventId);

		if (!is_null($oEvent->id))
		{
			$oEvent->event_status_id = $oEvent_Status->id;
			$oEvent->save();

			$aJSON = "success";
		}
	}

	Core::showJson($aJSON);
}

// Меню формы
$oAdmin_Form_Entity_Menus = Admin_Form_Entity::factory('Menus');

// Элементы меню
$oAdmin_Form_Entity_Menus->add(
	Admin_Form_Entity::factory('Menu')
		->name(Core::_('Event.events_menu_add_event'))
		->icon('fa fa-plus')
		->img('/admin/images/add.gif')
		->href(
			$oAdmin_Form_Controller->getAdminActionLoadHref($oAdmin_Form_Controller->getPath(), 'edit', NULL, 0, 0)
		)
		->onclick(
			$oAdmin_Form_Controller->getAdminActionLoadAjax($oAdmin_Form_Controller->getPath(), 'edit', NULL, 0, 0)
		)
)
->add(
	Admin_Form_Entity::factory('Menu')
		->name(Core::_('Event.events_menu_directories'))
		->icon('fa fa-book')
		->add(
			Admin_Form_Entity::factory('Menu')
				->name(Core::_('Event.events_menu_types'))
				->icon('fa fa-bars')
				->img('/admin/images/add.gif')
				->href(
					$oAdmin_Form_Controller->getAdminLoadHref($sEventGroupsFormPath = '/admin/event/type/index.php')
				)
				->onclick(
					$oAdmin_Form_Controller->getAdminLoadAjax($sEventGroupsFormPath)
				)
		)
		->add(
			Admin_Form_Entity::factory('Menu')
				->name(Core::_('Event.events_menu_groups'))
				->icon('fa fa-folder-o')
				->img('/admin/images/add.gif')
				->href(
					$oAdmin_Form_Controller->getAdminLoadHref($sEventGroupsFormPath = '/admin/event/group/index.php')
				)
				->onclick(
					$oAdmin_Form_Controller->getAdminLoadAjax($sEventGroupsFormPath)
				)
		)
		->add(
			Admin_Form_Entity::factory('Menu')
				->name(Core::_('Event.events_menu_statuses'))
				->icon('fa fa-circle')
				->img('/admin/images/add.gif')
				->href(
					$oAdmin_Form_Controller->getAdminLoadHref($sEventStatusesFormPath = '/admin/event/status/index.php')
				)
				->onclick(
					$oAdmin_Form_Controller->getAdminLoadAjax($sEventStatusesFormPath)
				)
		)
);

// Добавляем все меню контроллеру
$oAdmin_Form_Controller->addEntity($oAdmin_Form_Entity_Menus);

$oAdmin_Form_Controller->addEntity(
	Admin_Form_Entity::factory('Code')
		->html('
			<div class="add-event margin-bottom-20">
				<form action="/admin/event/index.php" method="POST">
					<div class="input-group">
						<input type="text" name="event_name" class="form-control" placeholder="' . Core::_('Event.placeholderEventName') . '">
						<span class="input-group-btn bg-azure bordered-azure">
							<button id="sendForm" class="btn btn-azure" type="submit" onclick="' . $oAdmin_Form_Controller->getAdminSendForm('addEvent', NULL, '') . '">
								<i class="fa fa-check no-margin"></i>
							</button>
						</span>
						<input type="hidden" name="hostcms[checked][0][0]" value="1"/>
					</div>
				</form>
			</div>
		')
);

$oAdmin_Form_Entity_Breadcrumbs = Admin_Form_Entity::factory('Breadcrumbs');

// Добавляем крошку на текущую форму
$oAdmin_Form_Entity_Breadcrumbs->add(
	Admin_Form_Entity::factory('Breadcrumb')
		->name(Core::_('Event.events_title'))
		->href(
			$oAdmin_Form_Controller->getAdminLoadHref($oAdmin_Form_Controller->getPath(), NULL, NULL, '')
		)
		->onclick(
			$oAdmin_Form_Controller->getAdminLoadAjax($oAdmin_Form_Controller->getPath(), NULL, NULL, '')
		)
);

$oAdmin_Form_Controller->addEntity($oAdmin_Form_Entity_Breadcrumbs);

// Действие редактирования
$oAdmin_Form_Action = Core_Entity::factory('Admin_Form', $iAdmin_Form_Id)
	->Admin_Form_Actions
	->getByName('edit');

if ($oAdmin_Form_Action && $oAdmin_Form_Controller->getAction() == 'edit')
{
	$oEvent_Controller_Edit = Admin_Form_Action_Controller::factory(
		'Event_Controller_Edit', $oAdmin_Form_Action
	);

	// Хлебные крошки для контроллера редактирования
	$oEvent_Controller_Edit
		->addEntity(
			$oAdmin_Form_Entity_Breadcrumbs
		);

	// Добавляем типовой контроллер редактирования контроллеру формы
	$oAdmin_Form_Controller->addAction($oEvent_Controller_Edit);
}

// Действие "Применить"
$oAdminFormActionApply = Core_Entity::factory('Admin_Form', $iAdmin_Form_Id)
	->Admin_Form_Actions
	->getByName('apply');

if ($oAdminFormActionApply && $oAdmin_Form_Controller->getAction() == 'apply')
{
	$oControllerApply = Admin_Form_Action_Controller::factory(
		'Admin_Form_Action_Controller_Type_Apply', $oAdminFormActionApply
	);

	// Добавляем типовой контроллер редактирования контроллеру формы
	$oAdmin_Form_Controller->addAction($oControllerApply);
}

// Действие "Копировать"
$oAdminFormActionCopy = Core_Entity::factory('Admin_Form', $iAdmin_Form_Id)
	->Admin_Form_Actions
	->getByName('copy');

if ($oAdminFormActionCopy && $oAdmin_Form_Controller->getAction() == 'copy')
{
	$oControllerCopy = Admin_Form_Action_Controller::factory(
		'Admin_Form_Action_Controller_Type_Copy', $oAdminFormActionCopy
	);

	// Добавляем типовой контроллер редактирования контроллеру формы
	$oAdmin_Form_Controller->addAction($oControllerCopy);
}

// Действие "Изменить группу"
$oAdminFormActionChangeGroup = Core_Entity::factory('Admin_Form', $iAdmin_Form_Id)
	->Admin_Form_Actions
	->getByName('changeGroup');

if ($oAdminFormActionChangeGroup && $oAdmin_Form_Controller->getAction() == 'changeGroup')
{
	$oEventControllerGroup = Admin_Form_Action_Controller::factory(
		'Event_Controller_Group', $oAdminFormActionChangeGroup
	);

	// Добавляем типовой контроллер редактирования контроллеру формы
	$oAdmin_Form_Controller->addAction($oEventControllerGroup);
}

// Действие "Изменить статус"
$oAdminFormActionChangeStatus = Core_Entity::factory('Admin_Form', $iAdmin_Form_Id)
	->Admin_Form_Actions
	->getByName('changeStatus');

if ($oAdminFormActionChangeStatus && $oAdmin_Form_Controller->getAction() == 'changeStatus')
{
	$oEventControllerStatus = Admin_Form_Action_Controller::factory(
		'Event_Controller_Status', $oAdminFormActionChangeStatus
	);

	// Добавляем типовой контроллер редактирования контроллеру формы
	$oAdmin_Form_Controller->addAction($oEventControllerStatus);
}

// Действие "Удалить файл"
$oAdminFormActionDeleteFile = Core_Entity::factory('Admin_Form', $iAdmin_Form_Id)
	->Admin_Form_Actions
	->getByName('deleteFile');

if ($oAdminFormActionDeleteFile && $oAdmin_Form_Controller->getAction() == 'deleteFile')
{
	$oController_Type_Delete_File = Admin_Form_Action_Controller::factory(
		'Admin_Form_Action_Controller_Type_Delete_File', $oAdminFormActionDeleteFile
	);

	$oController_Type_Delete_File
		->methodName('deleteFile')
		->divId('file_' . $oAdmin_Form_Controller->getOperation());

	// Добавляем контроллер удаления файла контроллеру формы
	$oAdmin_Form_Controller->addAction($oController_Type_Delete_File);
}

// Действие "Добавить дело"
$oAdminFormActionAddEvent = Core_Entity::factory('Admin_Form', $iAdmin_Form_Id)
	->Admin_Form_Actions
	->getByName('addEvent');

if ($oAdminFormActionAddEvent && $oAdmin_Form_Controller->getAction() == 'addEvent')
{
	$oControllerAddEvent = Admin_Form_Action_Controller::factory(
		'Event_Controller_Add', $oAdminFormActionAddEvent
	);

	$sEventName = trim(strval(Core_Array::getRequest('event_name')));

	$oControllerAddEvent
		->event_name($sEventName);

	// Добавляем типовой контроллер редактирования контроллеру формы
	$oAdmin_Form_Controller->addAction($oControllerAddEvent);
}

// Источник данных 0
$oAdmin_Form_Dataset = new Admin_Form_Dataset_Entity(Core_Entity::factory('Event'));

$oCurrentUser = Core_Entity::factory('User', 0)->getCurrent();

$oAdmin_Form_Dataset
	->addCondition(
		array('select' => array('events.*'))
	)
	->addCondition(
		array('join' => array('event_users', 'events.id', '=', 'event_users.event_id'))
	)
	->addCondition(
		array('where' => array('event_users.user_id', '=', $oCurrentUser->id))
	);

// Список значений для фильтра и поля
$aEvent_Groups = Core_Entity::factory('Event_Group')->findAll();
$sList = "0=…\n";
foreach ($aEvent_Groups as $oEvent_Group)
{
	$sList .= "{$oEvent_Group->id}={$oEvent_Group->name}\n";
}

$oAdmin_Form_Dataset
	->changeField('event_group_id', 'list', trim($sList));

function correctDateTime($sDateTime, $oAdmin_Form_Field)
{
	if (strlen($sDateTime))
	{
		$aDateTime = explode(' ', trim($sDateTime, '*'));

		// Дата
		if (isset($aDateTime[0]))
		{
			$aDate = explode('.', $aDateTime[0]);

			foreach ($aDate as $key => $value)
			{
				// Добавляем ведущий ноль элементам даты
				strlen($value) == 1 && $aDate[$key] = '0' . $value;
			}

			count($aDate) > 1 && $aDateTime[0] = implode('-', array_reverse($aDate));
		}

		return '*' . implode(' ', $aDateTime) . '*';
	}
}

$oAdmin_Form_Controller
	->addFilterCallback('start', 'correctDateTime')
	->addFilterCallback('finish', 'correctDateTime');

// Добавляем источник данных контроллеру формы
$oAdmin_Form_Controller->addDataset($oAdmin_Form_Dataset);

// Показ формы
$oAdmin_Form_Controller->execute();