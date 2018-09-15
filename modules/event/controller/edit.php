<?php

defined('HOSTCMS') || exit('HostCMS: access denied.');

/**
 * Events.
 *
 * @package HostCMS
 * @subpackage Event
 * @version 6.x
 * @author Hostmake LLC
 * @copyright © 2005-2018 ООО "Хостмэйк" (Hostmake LLC), http://www.hostcms.ru
 */
class Event_Controller_Edit extends Admin_Form_Action_Controller_Type_Edit
{
	/**
	 * Set object
	 * @param object $object object
	 * @return self
	 */
	public function setObject($object)
	{
		$this
			->addSkipColumn('datetime')
			->addSkipColumn('reminder_start');

		parent::setObject($object);

		$oMainTab = $this->getTab('main');
		$oAdditionalTab = $this->getTab('additional');

		$oSite = Core_Entity::factory('Site', CURRENT_SITE);

		// Ответственные сотрудники
		$aResponsibleEmployees = array();

		$aSelectResponsibleEmployees = array();

		$aTmpCompanies = array();

		$aCompanies = $oSite->Companies->findAll();
		foreach ($aCompanies as $oCompany)
		{
			$aTmpCompanies[] = $oCompany->id;

			$oOptgroupCompany = new stdClass();
			$oOptgroupCompany->attributes = array('label' => htmlspecialchars($oCompany->name), 'class' => 'company');
			$oOptgroupCompany->children = $oCompany->fillDepartmentsAndUsers($oCompany->id);

			$aSelectResponsibleEmployees[] = $oOptgroupCompany;
		}

		$oUser = Core_Entity::factory('User', 0)->getCurrent();

		$iCreatorUserId = 0;

		if ($this->_object->id)
		{
			$aEventUsers = $this->_object->Event_Users->findAll();

			foreach ($aEventUsers as $oEventUser)
			{
				$aResponsibleEmployees[] = $oEventUser->user_id;

				// Идентификатор создателя дела
				$oEventUser->creator && $iCreatorUserId = $oEventUser->user_id;
			}
		}
		else
		{
			$aResponsibleEmployees[] = $oUser->id;
			$iCreatorUserId = $oUser->id;

			$oEvent_Type = Core_Entity::factory('Event_Type')->getByDefault(1);
			!is_null($oEvent_Type) && $this->_object->event_type_id = $oEvent_Type->id;
		}

		// Если сотрудник является участником дела, но не его создателем, то возможен только просмотр информации о деле.
		if ($this->_object->id && $iCreatorUserId != $oUser->id)
		{
			$oMainTab->clear();
			$oAdditionalTab->clear();

			$this->title(htmlspecialchars($this->_object->name));

			$oMainTab
				->add($oMainRow1 = Admin_Form_Entity::factory('Div')->class('row'))
				->add($oMainRow2 = Admin_Form_Entity::factory('Div')->class('row'))
				->add($oMainRow3 = Admin_Form_Entity::factory('Div')->class('row'))
				->add($oMainRow4 = Admin_Form_Entity::factory('Div')->class('row profile-container'))
				->add($oMainRow5 = Admin_Form_Entity::factory('Div')->class('row'))
				->add($oMainRow6 = Admin_Form_Entity::factory('Div')->class('row'))
				->add($oMainRow7 = Admin_Form_Entity::factory('Div')->class('row profile-container'))
				->add($oMainRow8 = Admin_Form_Entity::factory('Div')->class('row'))
				->add($oMainRow9 = Admin_Form_Entity::factory('Div')->class('row'))
				->add($oMainRow10 = Admin_Form_Entity::factory('Div')->class('row'))
				->add($oMainRow11 = Admin_Form_Entity::factory('Div')->class('row'))
				;

			$oMainRow1->add(
				Admin_Form_Entity::factory('Code')
					->html('<div class="form-group col-xs-12">' . nl2br(htmlspecialchars($this->_object->description)) . '</div>')
			);

			$deadlineClass = $this->_object->deadline()
				? 'deadline'
				: '';

			// Время
			if ($this->_object->all_day)
			{
				$oMainRow2->add(
					Admin_Form_Entity::factory('Div')
						->class('col-xs-12 col-md-3')
						->add(
							Admin_Form_Entity::factory('Code')
								->html('
									<div class="form-group">
										<span class="caption">' . Core::_('Event.all_day_view') . '</span>
										<i class="fa fa-clock-o ' . $deadlineClass . '" style="margin-right: 5px;"></i><span class="' . $deadlineClass . '">' . Event_Controller::getDate($this->_object->start) . '</span>
									</div>
								')
						)
				)->add(
					Admin_Form_Entity::factory('Div')
						->class('col-xs-12 col-md-3')
						->add(
							Admin_Form_Entity::factory('Code')
								->html('
									<div class="form-group darkgray">
										<span class="caption">' . Core::_('Event.datetime_view') . '</span>
										<i class="fa fa-clock-o" style="margin-right: 5px;"></i><span>' . Event_Controller::getDateTime($this->_object->datetime) . '</span>
									</div>
								')
						)
				);
			}
			else
			{
				$oMainRow2->add(
					Admin_Form_Entity::factory('Div')
						->class('col-xs-12 col-md-3')
						->add(
							Admin_Form_Entity::factory('Code')
								->html('
									<div class="form-group">
										<span class="caption">' . Core::_('Event.start_view') . '</span>
										<i class="fa fa-clock-o" style="margin-right: 5px;"></i><span>' . Event_Controller::getDateTime($this->_object->start) . '</span>
									</div>
								')
						)
				)->add(
					Admin_Form_Entity::factory('Div')
						->class('col-xs-12 col-md-3')
						->add(
							Admin_Form_Entity::factory('Code')
								->html('
									<div class="form-group">
										<span class="caption">' . Core::_('Event.finish_view') . '</span>
										<i class="fa fa-clock-o ' . $deadlineClass . '" style="margin-right: 5px;"></i><span class="' . $deadlineClass . '">' . Event_Controller::getDateTime($this->_object->finish) . '</span>
									</div>
								')
						)
				)->add(
					Admin_Form_Entity::factory('Div')
						->class('col-xs-12 col-md-3')
						->add(
							Admin_Form_Entity::factory('Code')
								->html('
									<div class="form-group darkgray">
										<span class="caption">' . Core::_('Event.datetime_view') . '</span>
										<i class="fa fa-clock-o" style="margin-right: 5px;"></i><span>' . Event_Controller::getDateTime($this->_object->datetime) . '</span>
									</div>
								')
						)
				);
			}

			// Тип
			if ($this->_object->event_type_id)
			{
				ob_start();
				$this->_object->showType();

				$oMainRow3->add(
					Admin_Form_Entity::factory('Div')
						->class('col-xs-12 col-md-3')
						->add(
							Admin_Form_Entity::factory('Code')
								->html(ob_get_clean())
						)
				);
			}

			// Группа
			if ($this->_object->event_group_id)
			{
				$oEvent_Group = Core_Entity::factory('Event_Group', $this->_object->event_group_id);

				$sEventGroupName = htmlspecialchars($oEvent_Group->name);
				$sEventGroupColor = htmlspecialchars($oEvent_Group->color);
			}
			else
			{
				$sEventGroupName = Core::_('Event.notGroup');
				$sEventGroupColor = '#aebec4';
			}

			$oMainRow3->add(
				Admin_Form_Entity::factory('Div')
					->class('col-xs-12 col-md-3')
					->add(
						Admin_Form_Entity::factory('Code')
							->html('
								<div class="event-group">
									<i class="fa fa-circle" style="margin-right: 5px; color: ' . $sEventGroupColor. '"></i><span style="color: ' . $sEventGroupColor . '">' . $sEventGroupName . '</span>
								</div>
							')
					)
			);

			// Статус
			if ($this->_object->event_status_id)
			{
				$oEvent_Status = Core_Entity::factory('Event_Status', $this->_object->event_status_id);

				$sEventStatusName = htmlspecialchars($oEvent_Status->name);
				$sEventStatusColor = htmlspecialchars($oEvent_Status->color);
			}
			else
			{
				$sEventStatusName = Core::_('Event.notStatus');
				$sEventStatusColor = '#aebec4';
			}

			$oMainRow3->add(
				Admin_Form_Entity::factory('Div')
					->class('col-xs-12 col-md-3')
					->add(
						Admin_Form_Entity::factory('Code')
							->html('
								<div class="event-status">
									<i class="fa fa-circle" style="margin-right: 5px; color: ' . $sEventStatusColor. '"></i><span style="color: ' . $sEventStatusColor . '">' . $sEventStatusName . '</span>
								</div>
							')
					)
			);

			// Важное
			if ($this->_object->important)
			{
				$oMainRow3->add(
					Admin_Form_Entity::factory('Div')
						->class('col-xs-12 col-md-3')
						->add(
							Admin_Form_Entity::factory('Code')
								->html('
									<div class="event-status">
										<i class="fa fa-exclamation-circle darkorange"></i><span class="darkorange"> ' . Core::_('Event.important_view') . '</span>
									</div>
								')
						)
				);
			}

			// Клиенты, связанные с событием
			$aEvent_Siteusers = $this->_object->Event_Siteusers->findAll();
			if (count($aEvent_Siteusers))
			{
				$oMainRow4->add(
					Admin_Form_Entity::factory('Div')
						->class('col-xs-12')
						->add(
							Admin_Form_Entity::factory('Code')
								->html('<h6 class="row-title before-darkorange">' . Core::_('Event.event_siteusers') . '</h6>')
						)
				);
			}

			// Место
			if (strlen($this->_object->place))
			{
				$oMainRow6->add(
						Admin_Form_Entity::factory('Div')
							->class('col-xs-12 margin-top-20')
							->add(
								Admin_Form_Entity::factory('Code')
									->html('
										<i class="fa fa-map-marker azure"></i><span class="margin-left-5 azure">' . htmlspecialchars($this->_object->place) . '</span>
									')
							)
				);
			}

			// Ответственные сотрудники
			$aEvent_Users = $this->_object->Event_Users->findAll();
			if (count($aEvent_Users))
			{
				$oMainRow7->add(
					Admin_Form_Entity::factory('Div')
						->class('col-xs-12')
						->add(
							Admin_Form_Entity::factory('Code')
								->html('<h6 class="row-title before-palegreen">' . Core::_('Event.event_users') . '</h6>')
						)
				);

				foreach ($aEvent_Users as $oEvent_User)
				{
					$oUser = $oEvent_User->User;

					$aCompany_Department_Post_Users = $oUser->Company_Department_Post_Users->findAll();

					$sUserPost = isset($aCompany_Department_Post_Users[0])
						? $aCompany_Department_Post_Users[0]->Company_Post->name
						: '';

					$oMainRow8->add(
						Admin_Form_Entity::factory('Code')
							->html('
								<div class="col-lg-4 col-sm-6 col-xs-12">
									<div class="databox databox-graded">
										<div class="databox-left no-padding">
											<img src="' . $oUser->getAvatar() . '" style="width:65px; height:65px;">
										</div>
										<div class="databox-right padding-top-20 bg-whitesmoke">
											<div class="databox-stat orange radius-bordered">
												<div class="databox-text black semi-bold"><a class="darkgray" href="/admin/user/index.php?hostcms[action]=view&hostcms[checked][0][' . $oUser->id . ']=1" onclick="$.modalLoad({path: \'/admin/user/index.php\', action: \'view\', operation: \'modal\', additionalParams: \'hostcms[checked][0][' . $oUser->id . ']=1\', windowId: \'id_content\'}); return false">' . htmlspecialchars($oUser->getFullName()) . '</a></div>
												<div class="databox-text darkgray">' . htmlspecialchars($sUserPost) . '</div>
											</div>
										</div>
									</div>
								</div>
							')
					);
				}
			}

			// Завершено
			$sChecked = $this->_object->completed
				? 'checked="checked"'
				: '';

			$oMainRow9->add(
				Admin_Form_Entity::factory('Code')
					->html('
						<div class="form-group col-xs-4">
							<label>
								<input name="completed" class="colored-success" ' . $sChecked . ' type="checkbox">
								<span class="text">' . Core::_('Event.completed_view') . '</span>
							</label>
						</div>
					')
			);

			// Результат
			$oMainRow10
				->add(
					Admin_Form_Entity::factory('Textarea')
						->name('result')
						->caption(Core::_('Event.result_view'))
						->value($this->_object->result)
						->rows(2)
			)->add(
				Admin_Form_Entity::factory('Input')
					->type('hidden')
					->name('id')
					->value($this->_object->id)
			);

			// Файлы
			$aEvent_Attachments = $this->_object->Event_Attachments->findAll();

			foreach ($aEvent_Attachments as $oEvent_Attachment)
			{
				$sFilePath = $oEvent_Attachment->getFileHref();

				$textSize = $oEvent_Attachment->getTextSize();

				$ext = Core_File::getExtension($oEvent_Attachment->file_name);

				ob_start();
				$icon_file = '/admin/images/icons/' . (isset(Core::$mainConfig['fileIcons'][$ext]) ? Core::$mainConfig['fileIcons'][$ext] : 'file.gif');

				 Core::factory('Core_Html_Entity_Img')
					->src($icon_file)
					->class('img_line')
					->execute();

				$icon_file_img = ob_get_clean();

				ob_start();

				Core::factory('Core_Html_Entity_Strong')
					->value(" ({$textSize})")
					->execute();

				$oMainRow10->add(
					Admin_Form_Entity::factory('Code')
						->html('
							<div class="form-group col-xs-12">
								' . $icon_file_img . ' <a href="/admin/event/index.php?downloadFile=' . $oEvent_Attachment->id . '" target="_blank">' . $oEvent_Attachment->file_name . '</a> ' . ob_get_clean() . '
							</div>
						')
				);
			}

			return $this;
		}

		$this->title($this->_object->id
			? Core::_('Event.edit_title', $this->_object->name)
			: Core::_('Event.add_title'));

		$oMainTab
			->add($oMainRow1 = Admin_Form_Entity::factory('Div')->class('row'))
			->add($oMainRow2 = Admin_Form_Entity::factory('Div')->class('row'))

			->add($oMainRowEventStartButtons = Admin_Form_Entity::factory('Div')->class('row'))
			->add($oMainRowTimeSlider = Admin_Form_Entity::factory('Div')->class('row'))
			->add($oMainRow3_2 = Admin_Form_Entity::factory('Div')->class('row'))
			->add($oMainRow4 = Admin_Form_Entity::factory('Div')->class('row'))
			->add($oMainRow5 = Admin_Form_Entity::factory('Div')->class('row'))
			->add($oMainRow6 = Admin_Form_Entity::factory('Div')->class('row'))
			->add($oMainRow7 = Admin_Form_Entity::factory('Div')->class('row'))
			->add($oMainRow8 = Admin_Form_Entity::factory('Div')->class('row'))
			->add($oMainRow9 = Admin_Form_Entity::factory('Div')->class('row'))
			->add($oMainRowAttachments = Admin_Form_Entity::factory('Div')->class('row'))
			->add($oMainRowScripts = Admin_Form_Entity::factory('Div')->class('row'));


		$oMainTab
			//->delete($this->getField('duration'))
			->delete($this->getField('duration_type'))
			->delete($this->getField('reminder_type'));


		$oAdditionalTab
			->delete($this->getField('event_type_id'))
			->delete($this->getField('event_group_id'))
			->delete($this->getField('event_status_id'));

		$oDivTimeSlider = Admin_Form_Entity::factory('Div')
			->id('ts')
			->class('time-slider');

		$oDivWrapTimeSlider = Admin_Form_Entity::factory('Div')
			->add($oDivTimeSlider)
			->class('col-xs-12')
			//->style('margin-top: -50px; height: 135px;');
			->style('margin-top: -50px; height:130px');

		$oMainRowTimeSlider->add($oDivWrapTimeSlider);

		$windowId = $this->_Admin_Form_Controller->getWindowId();

		$oAdmin_Form_Entity_Code = Admin_Form_Entity::factory('Code');
		$oAdmin_Form_Entity_Code->html(
			'<script type="text/javascript">
				setTimeout(function() {

				var oEventStartDate = new Date(+$(\'#' . $windowId .' input[name="start"]\').parent().data("DateTimePicker").date()),
					timeZoneOffset = (oEventStartDate.getTimezoneOffset() * 60 * 1000 * -1),
					eventStartTime = oEventStartDate.getTime() + timeZoneOffset,

					eventStopTime = eventStartTime + getDurationMilliseconds(\'' . $windowId .'\'),
					oCurrentTime = Date.now() + timeZoneOffset,
					startTimestampRuler = eventStartTime - 3600 * 12 * 1000,
					cellId = "cellId",
					dateTimeFormatString = "' . Core::$mainConfig['dateTimePickerFormat'] . '";

				var jTimeSlider = $("#' . $windowId . ' #ts");

				jTimeSlider.TimeSlider({
					current_timestamp: oCurrentTime,
					start_timestamp: startTimestampRuler,
					//hours_per_ruler: 36,
					init_cells: [
						{
							"id": cellId,
							"_id": cellId,
							"start": eventStartTime, //(current_time - (3600 * 6 * 1000) ),
							"stop": eventStopTime, //eventStartTime + 3600 * 1 * 1000,
							"style": {
								"background-color": "#CAEF4A"
							}
						},
					],

					on_resize_timecell_callback: function (id, start, end){

						if (start > end)
						{
							start = end;
						}

						setDuration(start, end, \'' . $windowId .'\');
						setStartAndFinish(start - timeZoneOffset, end - timeZoneOffset, \'' . $windowId .'\');

						// Снимаем флажок "Весь день", если это необходимо
						cancelAllDay(\'' . $windowId .'\');
					},

					// Обработчик сдвига ползунка
					on_move_timecell_callback: function (id, start, end)
					{
						var timeCellStartTimestamp = jTimeSlider.data("timeCellStartTimestamp"),
							limit = 1000 * 60 * 60,	// 1 час
							startRuler = +jTimeSlider.data("timeslider")["options"]["start_timestamp"],

							// Длина линейки в миллисекундах
							ruler_duration = +jTimeSlider.data("timeslider")["options"]["hours_per_ruler"] * 60 * 60 * 1000,

							// Значение правой границы диапозона
							stopRuler = startRuler + ruler_duration,
							changeDelta = -1;

						if ( startRuler < start && (startRuler + limit) >= start)
						{
							var changeDelta = limit - (start - startRuler),

							// Сдвиг линейки влево
							leftShift = true;
						}
						else if (stopRuler > end && end >= (stopRuler - limit))
						{
							changeDelta = limit - (stopRuler - end);
							// Сдвиг линейки вправо
							leftShift = false;
						}

						jTimeSlider.data("timeCellStartTimestamp", start);

						if (changeDelta >= 0)
						{
							if (jTimeSlider.data("repeatingIntervalId"))
							{
								clearInterval(jTimeSlider.data("repeatingIntervalId"));
							}

							var timeCellDuration = end - start;

							var repeatingIntervalId = setInterval(function(){

								var timeCell = $("#" + cellId),
									startRuler = +jTimeSlider.data("timeslider")["options"]["start_timestamp"],
									stopRuler = startRuler + ruler_duration;

								// Передвигаем ползунок слева направо
								if (leftShift)
								{
									var	start = +timeCell.attr("start_timestamp");

									if ( start <= startRuler)
									{
										start = startRuler;
									}

									var newStart = start - changeDelta,
										newStop = newStart + timeCellDuration,
										newStartTimestamp = startRuler - changeDelta;
								}
								else
								{
									var end = +timeCell.attr("stop_timestamp");

									if ( end >= stopRuler)
									{
										end = stopRuler;
									}

									var newStop = end + changeDelta,
										newStart = newStop - timeCellDuration;
										newStartTimestamp = startRuler + changeDelta;
								}

								timeCellOptions = {
									"_id": cellId,
									"start": newStart,
									"stop": newStop
								};

								// Изменяем границу полосы прокрутки
								jTimeSlider.TimeSlider("new_start_timestamp", newStartTimestamp);

								// Изменяем положение ползунка
								jTimeSlider.TimeSlider("edit", timeCellOptions);

								setEventStartButtons(newStart - timeZoneOffset, \'' . $windowId .'\');

								setStartAndFinish(newStart - timeZoneOffset, newStop - timeZoneOffset, \'' . $windowId .'\');

							}, 25);

							jTimeSlider.data("repeatingIntervalId", repeatingIntervalId);
						}
						else if (jTimeSlider.data("repeatingIntervalId"))
						{
							clearInterval(jTimeSlider.data("repeatingIntervalId"));
						}

						// Устанавливаем вид кнопок быстрой установки даты
						setEventStartButtons(start - timeZoneOffset, \'' . $windowId .'\');

						// Устанавливаем значения полей начала/завершения события
						setStartAndFinish(start - timeZoneOffset, end - timeZoneOffset, \'' . $windowId .'\');

						// Снимаем флажок "Весь день", если это необходимо
						cancelAllDay(\'' . $windowId .'\');
					}
				});

				//$(function() {

					$("#' . $windowId . ' #ts .bg-event").on("dblclick", function (event){

						var deltaMilliseconds = jTimeSlider.data("timeslider")["options"]["hours_per_ruler"] * 3600 * 1000 / $(this).width() * (event.pageX - $(this).offset().left),
							newStartCell = +jTimeSlider.data("timeslider")["options"]["start_timestamp"] + deltaMilliseconds - timeZoneOffset,
							newStopCell = newStartCell + getDurationMilliseconds(\'' . $windowId .'\');

						setStartAndFinish(newStartCell, newStopCell, \'' . $windowId .'\');
						setEventStartButtons(newStartCell, \'' . $windowId .'\');
						// Снимаем флажок "Весь день", если это необходимо
						cancelAllDay(\'' . $windowId .'\');
					});

					$(\'#' . $windowId .' input[name="duration"]\').on("keyup", {cellId: cellId, timeZoneOffset: timeZoneOffset, windowId: \'' . $windowId .'\'}, changeDuration);
					$(\'#' . $windowId .' select[name="duration_type"]\').on("change", {cellId: cellId, timeZoneOffset: timeZoneOffset, windowId: \'' . $windowId .'\'}, changeDuration);

					// Обработчик изменения даты-времени начала/завершения события
					$(\'#' . $windowId .' input[class*="hasDatetimepicker"]\').parent().on("dp.change", function (event){

						var inputField = $("#' . $windowId . ' input.hasDatetimepicker", this),
							inputFieldName = inputField.attr("name"),
							startTimeCell = +$(\'#' . $windowId .' input[name="start"]\').parent().data("DateTimePicker").date()
							stopTimeCell = +$(\'#' . $windowId .' input[name="finish"]\').parent().data("DateTimePicker").date();

						if (!startTimeCell || !stopTimeCell)
						{
							startTimeCell = 0;
							stopTimeCell = 0;
						}

						var	timeCellOptions = {
								"_id": cellId,
								"start": startTimeCell ?  startTimeCell + timeZoneOffset : 1,
								"stop": stopTimeCell ? stopTimeCell + timeZoneOffset : 1
							};

						if (startTimeCell && !jTimeSlider.data("timeCellMouseDown"))
						{
							// Изменяем границу полосы прокрутки
							jTimeSlider.TimeSlider("new_start_timestamp", startTimeCell + timeZoneOffset - 3600 * 24 * 1000 / 2);
						}

						// Изменяем положение ползунка
						jTimeSlider.TimeSlider("edit", timeCellOptions);

						// Изменяем значение продолжительности
						setDuration(startTimeCell, stopTimeCell, \'' . $windowId .'\');

						setEventStartButtons(startTimeCell, \'' . $windowId .'\');
					});

					// Обработчик нажатия кнопки быстрого перехода по дням
					$("#eventStartButtonsGroup").on("click", "[data-start-day]", function (event){

						event.preventDefault();

						$(this)
							.addClass("active")
							.removeClass("btn-default")
							.siblings(".active")
							.removeClass("active");

						var koef = +$(this).data("startDay"),
							millisecondsDay = 3600 * 24 * 1000,

							// Текущая дата-время
							oCurrentDate = new Date(),

							// Текущая дата без времени
							oCurrentDateWithoutTime = new Date(oCurrentDate.getFullYear(), oCurrentDate.getMonth(), oCurrentDate.getDate()),

							// Текущая дата-время начала события
							//oCurrentStartDate = new Date(+$("#" + cellId).attr("start_timestamp")),
							oCurrentStartDate = new Date(+$("#" + cellId).attr("start_timestamp") - timeZoneOffset),

							// Текущая дата начала события без времени
							oCurrentStartDateWithoutTime = new Date(oCurrentStartDate.getFullYear(), oCurrentStartDate.getMonth(), oCurrentStartDate.getDate()),

							// Новая дата начала события без времени
							oNewStartDateWithoutTime = new Date(+oCurrentDate + millisecondsDay * koef);

						// Текущая и новая даты начала действия совпадают
						if (+oCurrentStartDateWithoutTime == +oNewStartDateWithoutTime)
						{
							return false;
						}

						var	newStartCell = +oCurrentDateWithoutTime + (oCurrentStartDate - oCurrentStartDateWithoutTime) + millisecondsDay * koef; // левая граница ползунка
							newStartRuler = newStartCell - millisecondsDay / 2, //левая граница полосы прокрутки
							newStopCell = newStartCell + getDurationMilliseconds(\'' . $windowId .'\'); //duration * durationMillisecondsKoef;

						timeCellOptions = {
							"_id": cellId,
							"start": newStartCell + timeZoneOffset,
							"stop": newStopCell + timeZoneOffset
						};

						// Изменяем границу полосы прокрутки
						jTimeSlider.TimeSlider("new_start_timestamp", newStartRuler);

						// Изменяем положение ползунка
						jTimeSlider.TimeSlider("edit", timeCellOptions);

						//setStartAndFinish(newStartCell - timeZoneOffset, newStopCell - timeZoneOffset, \'' . $windowId .'\');
						setStartAndFinish(newStartCell, newStopCell, \'' . $windowId .'\');
					});

					$(".page-body").on(
						{
							"selectstart": function (event){

								if (jTimeSlider.data("timeCellMouseDown"))
								{
									event.preventDefault();
								}
							},

							"mouseup": function (){

								jTimeSlider.data({"timeCellMouseDown": false});

								if (jTimeSlider.data("repeatingIntervalId"))
								{
									clearInterval(jTimeSlider.data("repeatingIntervalId"));
								}
							},

							"mousewheel": function(event) {

								if (jTimeSlider.data("mouseover"))
								{
									event.preventDefault();

									var originalEvent = event.originalEvent,
										delta = originalEvent.deltaY || originalEvent.detail || originalEvent.wheelDelta,
										// Правая граница линейки
										startRuler = +jTimeSlider.data("timeslider")["options"]["start_timestamp"],
										newStartRuler = startRuler + (delta > 0 ? 1 : -1) * 1000 * 60 * 120;

										// Изменяем границу полосы прокрутки
									jTimeSlider.TimeSlider("new_start_timestamp", newStartRuler);
								}
							}
						}
					)

					jTimeSlider.on({
							"mousedown": function (event){

								jTimeSlider.data({"timeCellMouseDown": true, "timeCellStartTimestamp": $("#" + cellId).attr("start_timestamp")});
							},
						}, "#t" + cellId
					)
					.on({
							"mouseover": function (){

								if (!jTimeSlider.data("mouseover"))
								{
									jTimeSlider.data({"mouseover": true})
								}
							},

							"mouseout": function (){

								jTimeSlider.removeData("mouseover");
							},
						}, ".bg-event"
					);

					$("#' . $windowId . ' input[name=\'all_day\']").on("click", function (){

						$("#' . $windowId . ' select[name=\'duration_type\']").parent("div").toggleClass("invisible");
						$("#' . $windowId . ' input[name=\'duration\']").parent("div").toggleClass("invisible");

						var startTimestampRuler = 0;

						// Установили чекбокс
						if (this.checked)
						{
							var formatDateTimePicker = "' . Core::$mainConfig['datePickerFormat'] . '",

								oOriginalDateStartEvent = new Date($(\'#' . $windowId .' input[name="start"]\').parent().data("DateTimePicker").date()),
								oOriginalDateEndEvent = new Date($(\'#' . $windowId .' input[name="finish"]\').parent().data("DateTimePicker").date()),
								oNewTimestampStartEvent = new Date(oOriginalDateStartEvent.getFullYear(), oOriginalDateStartEvent.getMonth(), oOriginalDateStartEvent.getDate()).getTime(),
								oNewTimestampEndEvent = oNewTimestampStartEvent + 3600 * 1000 * 24 - 1,

								originalStartTimestampRuler = +jTimeSlider.data("timeslider")["options"]["start_timestamp"];

								if (oOriginalDateStartEvent < originalStartTimestampRuler)
								{
									startTimestampRuler = oNewTimestampStartEvent;
								}

							jTimeSlider.data({
								"originalTimestampStartEvent": oOriginalDateStartEvent.getTime(),
								"originalTimestampEndEvent": oOriginalDateEndEvent.getTime(),
								"originalStartTimestampRuler": originalStartTimestampRuler
							});
						}
						else
						{
							formatDateTimePicker = "' . Core::$mainConfig['dateTimePickerFormat'] . '";

							oNewTimestampStartEvent = jTimeSlider.data("originalTimestampStartEvent");
							oNewTimestampEndEvent = jTimeSlider.data("originalTimestampEndEvent");

							startTimestampRuler = jTimeSlider.data("originalStartTimestampRuler");
						}

						if (startTimestampRuler)
						{
							jTimeSlider.TimeSlider("new_start_timestamp", startTimestampRuler);
						}

						setStartAndFinish(oNewTimestampStartEvent, oNewTimestampEndEvent, \'' . $windowId .'\');

						$(\'#' . $windowId .' input[name="start"]\').parent().data("DateTimePicker").format(formatDateTimePicker);
						$(\'#' . $windowId .' input[name="finish"]\').parent().data("DateTimePicker").format(formatDateTimePicker);
					});
				//});
				}, 300);
			</script>'
		);

		$oMainRowScripts->add($oAdmin_Form_Entity_Code);

		//Массив названий кнопок быстрого переключения даты начала события
		$masEventStartButtonTitle = array();
		$masEventStartButtonTitle["'" . Core_Date::timestamp2date(time()) . "'"] = Core::_('Event.eventStartButtonTitleToday');
		$masEventStartButtonTitle["'" . Core_Date::timestamp2date(time() + 3600 * 24) . "'"] = Core::_('Event.eventStartButtonTitleTomorrow');
		$masEventStartButtonTitle["'" . Core_Date::timestamp2date(time() + 3600 * 24 * 2) . "'"] = Core::_('Event.eventStartButtonTitleDayAfterTomorrow');
		$masEventStartButtonTitle["'" . Core_Date::timestamp2date(time() + 3600 * 24 * 3) . "'"] = Core::_('Event.eventStartButtonTitle3Days');

		$htmlEventStartButtons = '';
		$startDayNum = 0;

		// Формирование кнопок быстрого переключения даты начала события
		foreach ($masEventStartButtonTitle as $eventStartDate => $eventStartTitle)
		{
			$htmlEventStartButtons .= '<a href="#" data-start-day="' . $startDayNum . '" class="btn' . ((!$this->_object->id && !$startDayNum) || ($eventStartDate == ("'" . Core_Date::sql2date($this->_object->start) . "'")) ?  ' active' : '') . '">' . $eventStartTitle . '</a>';
			$startDayNum++;
		}

		$oAdmin_Form_Entity_Code = Admin_Form_Entity::factory('Code');

		$oAdmin_Form_Entity_Code->html(
			'<div class="col-xs-12 text-center" style="z-index: 10">
				<div id="eventStartButtonsGroup" class="btn-group margin-bottom-15">' . $htmlEventStartButtons . '</div>
			</div>
			<script type="text/javascript">
				$("#eventStartButtonsGroup").on({
						"mouseover": function (){
							!$(this).hasClass("active") && $(this).addClass("btn-default");
						},
						"mouseout": function (){
							$(this).removeClass("btn-default");
						}
					}, "[data-start-day]")
			</script>'
		);

		$oMainRowEventStartButtons->add($oAdmin_Form_Entity_Code);

		if (!$this->_object->id)
		{
			$date = Core_Array::getGet('date');

			if (!$date)
			{
				$this->getField('start')->value(Core_Date::timestamp2datetime(time()));
				$this->getField('finish')->value(Core_Date::timestamp2datetime(time() + 60 * 60));
			}
			else
			{
				$this->getField('start')->value(Core_Date::timestamp2datetime($date));
				$this->getField('finish')->value(Core_Date::timestamp2datetime($date + 60 * 60));
			}

			$this->getField('duration')->value(1);
		}

		$oMainTab
			->move($this->getField('start')->divAttr(array('class' => 'form-group col-md-3 col-sm-4 col-xs-6')), $oMainRow3_2)
			->move($this->getField('duration')->divAttr(array('class' => 'form-group col-sm-2 col-xs-3' . ($this->_object->all_day ? ' invisible' : ''))), $oMainRow3_2);

		$aDurationTypes = array(Core::_('Event.periodMinutes'), Core::_('Event.periodHours'), Core::_('Event.periodDays'));

		$oDurationTypes = Admin_Form_Entity::factory('Select')
			->options($aDurationTypes)
			->name('duration_type')
			->value($this->_object->id ? $this->_object->duration_type : 1)
			->divAttr(array('class' => 'form-group col-md-2 col-xs-3 no-padding-left' . ($this->_object->all_day ? ' invisible' : '')))
			->caption('&nbsp;');

		$oMainRow3_2->add($oDurationTypes);

		$oMainTab
			->move($this->getField('finish')->divAttr(array('class' => 'form-group col-md-3 col-sm-4 col-xs-6')), $oMainRow3_2)
			->move($this->getField('all_day')->divAttr(array('class' => 'form-group col-md-2 col-sm-4 col-xs-6  margin-top-21 no-padding-right')), $oMainRow3_2);

		$oAdmin_Form_Entity_Code = Admin_Form_Entity::factory('Code');
		$oAdmin_Form_Entity_Code->html(
			'<script type="text/javascript">
				var formatDateTimePicker = $("input[name=\'all_day\']").attr("checked") ? "' . Core::$mainConfig['datePickerFormat'] . '" : "' . Core::$mainConfig['dateTimePickerFormat'] . '";

				$(\'input[name="start"]\').parent().data("DateTimePicker").format(formatDateTimePicker);
				$(\'input[name="finish"]\').parent().data("DateTimePicker").format(formatDateTimePicker);
			</script>'
		);

		$oMainRow3_2->add($oAdmin_Form_Entity_Code);

		$aMasEventTypes = array();

		$aEventTypes = Core_Entity::factory('Event_Type', 0)->findAll();

		foreach ($aEventTypes as $oEventType)
		{
			$aMasEventTypes[$oEventType->id] = array(
				'value' => $oEventType->name,
				'color' => $oEventType->color,
				'icon' => $oEventType->icon
			);
		}

		$oDropdownlistEventTypes = Admin_Form_Entity::factory('Dropdownlist')
			->options($aMasEventTypes)
			->name('event_type_id')
			->value($this->_object->event_type_id)
			->caption(Core::_('Event.event_type_id'))
			->divAttr(array('class' => 'form-group col-md-3 col-sm-4 col-xs-6'));

		$oMainRow4->add($oDropdownlistEventTypes);

		$aMasEventGroups = array(array('value' => Core::_('Event.notGroup'), 'color' => '#aebec4'));

		$aEventGroups = Core_Entity::factory('Event_Group', 0)->findAll();

		foreach ($aEventGroups as $oEventGroup)
		{
			$aMasEventGroups[$oEventGroup->id] = array('value' => $oEventGroup->name, 'color' => $oEventGroup->color);
		}

		$oDropdownlistEventGroups = Admin_Form_Entity::factory('Dropdownlist')
			->options($aMasEventGroups)
			->name('event_group_id')
			->value($this->_object->event_group_id)
			->caption(Core::_('Event.event_group_id'))
			->divAttr(array('class' => 'form-group col-md-4 col-sm-5 col-xs-6'));

		$oMainRow4->add($oDropdownlistEventGroups);


		$aMasEventStatuses = array(array('value' => Core::_('Event.notStatus'), 'color' => '#aebec4'));

		// При добавлении дела отображаем статусы, которые не являются завершающими
		$aEventStatuses = is_null($this->_object->id)
			? Core_Entity::factory('Event_Status')->getAllByFinal(0)
			: Core_Entity::factory('Event_Status')->findAll();

		foreach ($aEventStatuses as $oEventStatus)
		{
			$aMasEventStatuses[$oEventStatus->id] = array(
				'value' => $oEventStatus->name,
				'color' => $oEventStatus->color
			);
		}

		$oDropdownlistEventStatuses = Admin_Form_Entity::factory('Dropdownlist')
			->options($aMasEventStatuses)
			->name('event_status_id')
			->value($this->_object->event_status_id)
			->caption(Core::_('Event.event_status_id'))
			->divAttr(array('class' => 'form-group col-md-3 col-sm-4 col-xs-6'));

		$oMainRow4->add($oDropdownlistEventStatuses);

		$oMainTab->move($this->getField('important')->class('colored-danger')->divAttr(array('class' => 'form-group col-md-2 col-sm-3 col-xs-6  margin-top-21 no-padding-right')), $oMainRow4);

		// Вместо 0 в качестве значения пустая строка
		if (is_null($this->_object->id) || !($this->getField('reminder_value')->value))
		{
			$this->getField('reminder_value')->value('');
		}

		$oSelectReminderTypes = Admin_Form_Entity::factory('Select')
			->options($aDurationTypes)
			->name('reminder_type')
			->value($this->_object->reminder_type)
			->divAttr(array('class' => 'form-group col-md-2 col-xs-3 no-padding-left'))
			->caption('&nbsp;');

		$oSelectResponsibleEmployees = Admin_Form_Entity::factory('Select')
			->id('event_user_id')
			->multiple('multiple')
			->options($aSelectResponsibleEmployees)
			->name('event_user_id[]')
			->value($aResponsibleEmployees)
			->caption(Core::_('Event.event_user_id'))
			->style("width: 100%");

		$oScriptResponsibleEmployees = Admin_Form_Entity::factory('Script')
			->type("text/javascript")
			->value('
				 var eventUsersControlElememt = $("#event_user_id")
					.data({
						// templateResultOptions - свойство-объект настроек выпадающего списка
						// templateResultOptions.excludedItems - массив идентификаторов элеметов, исключаемых из списка
						templateResultOptions: {
							excludedItems: [' . $iCreatorUserId . ']
						},
						// templateSelectionOptions - свойство-объект настроек отображаемых (выбранных) элементов
						// templateSelectionOptions.unavailableItems - массив идентификаторов выбранных элеметов, которые нельзя удалить
						templateSelectionOptions: {
							unavailableItems: [' . $iCreatorUserId . ']
						}
					})
					.select2({
						placeholder: "",
						//allowClear: true,
						//multiple: true,
						templateResult: $.templateResultItemResponsibleEmployees,
						escapeMarkup: function(m) { return m; },
						templateSelection: $.templateSelectionItemResponsibleEmployees,
						language: "' . Core_i18n::instance()->getLng() . '",
						width: "100%"
					});
					'
			);

		$oMainRow8
			->add($oSelectResponsibleEmployees)
			->add($oScriptResponsibleEmployees);

		// Массив установленных значений
		$aEventCompaniesPeople = array();

		$aExistSiteusers = array();

		if ($this->_object->id)
		{
			$aEventSiteusers = $this->_object->Event_Siteusers->findAll();

			foreach ($aEventSiteusers as $oEventSiteuser)
			{
				if ($oEventSiteuser->siteuser_company_id)
				{
					$aEventCompaniesPeople[] = 'company_' . $oEventSiteuser->siteuser_company_id;
					$aExistSiteusers[] = $oEventSiteuser->Siteuser_Company->siteuser_id;
				}
				else
				{
					$aEventCompaniesPeople[] = 'person_' . $oEventSiteuser->siteuser_person_id;
					$aExistSiteusers[] = $oEventSiteuser->Siteuser_Person->siteuser_id;
				}
			}
		}

		if (Core::moduleIsActive('siteuser'))
		{
			$aMasSiteusers = array();

			if (count($aExistSiteusers))
			{
				$aSiteusers = $oSite->Siteusers->getAllById($aExistSiteusers, FALSE, 'IN');
				foreach ($aSiteusers as $oSiteuser)
				{
					$oOptgroupSiteuser = new stdClass();
					$oOptgroupSiteuser->attributes = array('label' => $oSiteuser->login, 'class' => 'siteuser');

					$aSiteuserCompanies = $oSiteuser->Siteuser_Companies->findAll();
					foreach ($aSiteuserCompanies as $oSiteuserCompany)
					{
						$oOptgroupSiteuser->children['company_' . $oSiteuserCompany->id] = array(
							'value' => htmlspecialchars($oSiteuserCompany->name) . '%%%' . $oSiteuserCompany->getAvatar(),
							'attr' => array('class' => 'siteuser-company')
						);
					}

					$aSiteuserPeople = $oSiteuser->Siteuser_People->findAll();
					foreach ($aSiteuserPeople as $oSiteuserPerson)
					{
						$oOptgroupSiteuser->children['person_' . $oSiteuserPerson->id] = array(
							'value' => htmlspecialchars($oSiteuserPerson->getFullName()) . '%%%' . $oSiteuserPerson->getAvatar(),
							'attr' => array('class' => 'siteuser-person')
						);
					}

					$aMasSiteusers[$oSiteuser->id] = $oOptgroupSiteuser;
				}
			}

			$oSelectSiteusers = Admin_Form_Entity::factory('Select')
				->id('event_siteuser_id')
				->multiple('multiple')
				->options($aMasSiteusers)
				->name('event_siteuser_id[]')
				->value($aEventCompaniesPeople)
				->caption(Core::_('Event.event_siteuser_id'))
				->style("width: 100%");

			$oScriptSiteusers = Admin_Form_Entity::factory('Script')
				->type("text/javascript")
				->value('
					$("#event_siteuser_id").select2({
						minimumInputLength: 1,
						placeholder: "",
						allowClear: true,
						multiple: true,
						ajax: {
							url: "/admin/siteuser/index.php?loadEventSiteusers",
							dataType: "json",
							type: "GET",
							processResults: function (data) {
								var aResults = [];
								$.each(data, function (index, item) {
									aResults.push({
										"id": item.id,
										"text": item.text
									});
								});
								return {
									results: aResults
								};
							}
						},
						templateResult: $.templateResultItemSiteusers,
						escapeMarkup: function(m) { return m; },
						templateSelection: $.templateSelectionItemSiteusers,
						language: "' . Core_i18n::instance()->getLng() . '",
						width: "100%"
					});'
				);

			$oMainRow5
				->add($oSelectSiteusers)
				->add($oScriptSiteusers);
		}

		// Если сотрудник является участником дела, но не его создателем, то возможен только просмотр информации о деле.
		if ($this->_object->id && $iCreatorUserId != $oUser->id)
		{
			$oDivTimeSlider
				->add(
					Admin_Form_Entity::factory('Div')
						->class("disabled")
				);

			$this->getField('name')->disabled('disabled');
			$this->getField('description')->disabled('disabled');
			$this->getField('important')->disabled('disabled');
			$this->getField('start')->disabled('disabled');
			$this->getField('finish')->disabled('disabled');
			$this->getField('duration')->disabled('disabled');
			$this->getField('all_day')->disabled('disabled');
			$this->getField('place')->disabled('disabled');
			$this->getField('reminder_value')->disabled('disabled');
			$this->getField('completed')->disabled('disabled');
			$this->getField('busy')->disabled('disabled');

			$this->getField('result')->disabled('disabled');

			$oDropdownlistEventTypes->disabled(TRUE);
			$oDropdownlistEventGroups->disabled(TRUE);
			$oDropdownlistEventStatuses->disabled(TRUE);

			$oSelectSiteusers->disabled('disabled');
			$oDurationTypes->disabled('disabled');
			$oSelectReminderTypes->disabled('disabled');
			$oSelectResponsibleEmployees->disabled('disabled');
		}

		$oMainTab
			->move($this->getField('name')->rows(1), $oMainRow1)
			->move($this->getField('description'), $oMainRow2)
			->move($this->getField('place')->divAttr(array('class' => 'form-group col-md-4 col-xs-12')), $oMainRow6)
			->move($this->getField('reminder_value')->divAttr(array('class' => 'form-group col-md-2 col-xs-3')), $oMainRow6);

		$oMainRow6->add($oSelectReminderTypes);

		$oMainTab
			->move($this->getField('completed')->class('colored-success')->divAttr(array('class' => 'form-group col-md-2 col-xs-3 margin-top-21 no-padding-right')), $oMainRow6)
			->move($this->getField('busy')->divAttr(array('class' => 'form-group col-md-2 col-xs-3 margin-top-21 no-padding-right')), $oMainRow6)
			->move($this->getField('result'), $oMainRow9);

		$windowId = $this->_Admin_Form_Controller->getWindowId();
		$aEvent_Attachments = $this->_object->Event_Attachments->findAll();

		foreach ($aEvent_Attachments as $oEvent_Attachment)
		{
			$sFilePath = $oEvent_Attachment->getFileHref();

			$textSize = $oEvent_Attachment->getTextSize();

			$ext = Core_File::getExtension($oEvent_Attachment->file_name);

			ob_start();
			$icon_file = '/admin/images/icons/' . (isset(Core::$mainConfig['fileIcons'][$ext]) ? Core::$mainConfig['fileIcons'][$ext] : 'file.gif');

			 Core::factory('Core_Html_Entity_Img')
				->src($icon_file)
				->class('img_line')
				->execute();

			$icon_file_img = ob_get_clean();

			ob_start();

			Core::factory('Core_Html_Entity_Strong')
				->value(" ({$textSize})")
				->execute();

			$oAdmin_Form_Entity_File = Admin_Form_Entity::factory('File')
				->type('file')
				->caption($icon_file_img . ' ' . $oEvent_Attachment->file_name . ob_get_clean())
				->name("file_{$oEvent_Attachment->id}")
				->largeImage(
					array(
						'path' => '/admin/event/index.php?downloadFile=' . $oEvent_Attachment->id,
						'show_params' => FALSE,
						'delete_onclick' => "$.adminLoad({path: '/admin/event/index.php', additionalParams: 'hostcms[checked][0][{$this->_object->id}]=1', operation: '{$oEvent_Attachment->id}', action: 'deleteFile', windowId: '{$windowId}'}); return false",
						'delete_href' => ''
					)
				)
				->smallImage(
					array('show' => FALSE)
				)
				->divAttr(array('id' => "file_{$oEvent_Attachment->id}", 'class' => 'col-lg-12'));

			$oMainTab->add(Admin_Form_Entity::factory('Div')
				->class('row')
				->add($oAdmin_Form_Entity_File)
			);
		}

		$oAdmin_Form_Entity_Code = Admin_Form_Entity::factory('Code');
		$oAdmin_Form_Entity_Code->html('<div class="input-group-addon no-padding add-remove-property"><div class="no-padding-left col-lg-12"><div class="btn btn-palegreen" onclick="$.cloneFile(\'' . $windowId .'\'); event.stopPropagation();"><i class="fa fa-plus-circle close"></i></div>
			<div class="btn btn-darkorange" onclick="$(this).parents(\'#file\').remove(); event.stopPropagation();"><i class="fa fa-minus-circle close"></i></div>
			</div>
			</div>');

		$oFileField = Admin_Form_Entity::factory('File')
			->type('file')
			->name("file[]")
			->caption(Core::_('Event.attachment'))
			->largeImage(
				array('show_params' => FALSE))
			->smallImage(
				array('show' => FALSE))
			->divAttr(array('id' => 'file', 'class' => 'col-xs-12 col-sm-6'))
			->add($oAdmin_Form_Entity_Code);

		$oMainRowAttachments->add($oFileField);

		return $this;
	}

	/**
	 * Processing of the form. Apply object fields.
	 * @hostcms-event Event_Controller_Edit.onAfterRedeclaredApplyObjectProperty
	 */
	protected function _applyObjectProperty()
	{
		$oCurrentUser = Core_Entity::factory('User', 0)->getCurrent();
		$bAddEvent = is_null($this->_object->id);

		// Значение завершенности дела до применения изменений
		$eventCompletedBefore = $bAddEvent ? 0 : $this->_object->completed;

		// Запрещаем редактировать дело не его создателю
		if (!$bAddEvent && ($oEventCreator = $this->_object->getCreator()) && $oEventCreator->id != $oCurrentUser->id)
		{
			$this->_object->completed = strval(Core_Array::get($this->_formValues, 'completed')) == 'on' ? 1 : 0;
			$this->_object->result = strval(Core_Array::get($this->_formValues, 'result'));

			$this->_object->save();

			// Завершенность изменена
			if ($eventCompletedBefore != $this->_object->completed)
			{
				// Отправляем уведомления ответственным сотрудникам
				$this->_object->changeCompletedSendNotification();
			}

			return TRUE;
		}

		// Устанавливаем дату создания
		$bAddEvent && $this->_object->datetime = Core_Date::timestamp2sql(time());

		// Установлен флажок "Весь день"
		if (Core_Array::getPost('all_day'))
		{
			$this->_formValues['finish'] = $this->_formValues['finish'] . ' 23:59:59';
		}

		if ($iEventStatusId  = intval(Core_Array::getPost('event_status_id', 0)))
		{
			$oEventStatus = Core_Entity::factory('Event_Status', $iEventStatusId);
			$oEventStatus->final &&	$this->_formValues['completed']	= 1;
		}

		$startEvent = $this->_formValues['start'];

		// Задано время начала события
		if (!empty($startEvent))
		{
			// Определение даты-времени отправления напоминания
			$reminderValue = intval(Core_Array::getPost('reminder_value', 0));

			// Задан период напоминания о событии
			if ($reminderValue)
			{
				$iReminderType = Core_Array::getPost('reminder_type', 0);

				// Определяем значение периода напоминания о событии в секундах
				switch ($iReminderType)
				{
					case 1: // Часы
						$iSecondsReminderValue = 60 * 60 * $reminderValue;
						break;
					case 2: // Дни
						$iSecondsReminderValue = 60 * 60 * 24 * $reminderValue;
						break;

					default: // Минуты
						$iSecondsReminderValue = 60 * $reminderValue;
				}

				$this->_object->reminder_start = Core_Date::timestamp2sql(Core_Date::datetime2timestamp($startEvent) - $iSecondsReminderValue);
			}
		}

		parent::_applyObjectProperty();

		$oEvent = $this->_object;

		$aEventUserId = Core_Array::getPost('event_user_id', array());

		// To array
		!is_array($aEventUserId) && $aEventUserId = array();

		// Add creator
		!in_array($oCurrentUser->id, $aEventUserId) && $aEventUserId[] = $oCurrentUser->id;

		$aEventUserId = array_unique($aEventUserId);

		$aIssetUsers = array();

		// Массив идентификаторов пользователей, которым будет отправлено уведомление о исключении их из списка исполнителями дела
		$aNotificationEventExcludedUserId = array();

		// Менять список ответственных сотрудников может создатель дела
		//if (!$bAddEvent && ($oEventCreator = $oEvent->getCreator()) && $oEventCreator->id == $oCurrentUser->id)
		//{
			// Ответственные сотрудники
			$aEventUsers = $oEvent->Event_Users->findAll(FALSE);

			foreach ($aEventUsers as $oEventUser)
			{
				$iSearchIndex = array_search($oEventUser->user_id, $aEventUserId);

				if ($iSearchIndex === FALSE && $oEventUser->user_id != $oCurrentUser->id)
				{
					$aNotificationEventExcludedUserId[] = $oEventUser->user_id;
					$oEventUser->delete();
				}
				else
				{
					$aIssetUsers[] = $oEventUser->user_id;
				}
			}
		//}

		// Массив идентификаторов пользователей, которым будет отправлено уведомление о добавлении их исполнителями дела
		$aNotificationEventParticipantUserId = array();

		// Добавление исполнителей дела
		foreach ($aEventUserId as $iEventUserId)
		{
			if (!in_array($iEventUserId, $aIssetUsers))
			{
				$oEventUser = Core_Entity::factory('Event_User')
					->user_id($iEventUserId);

				// При добавлении события указываем создателя
				$bAddEvent
					&& $iEventUserId == $oCurrentUser->id
					&& $oEventUser->creator(1);

				$oEvent->add($oEventUser);

				$iEventUserId != $oCurrentUser->id
					&& $aNotificationEventParticipantUserId[] = $iEventUserId;
			}
		}

		// Замена загруженных ранее файлов на новые
		$aEvent_Attachments = $this->_object->Event_Attachments->findAll();
		foreach ($aEvent_Attachments as $oEvent_Attachment)
		{
			$aExistFile = Core_Array::getFiles("file_{$oEvent_Attachment->id}");

			if (Core_File::isValidExtension($aExistFile['name'], Core::$mainConfig['availableExtension']))
			{
				$oEvent_Attachment->saveFile($aExistFile['tmp_name'], $aExistFile['name']);
			}
		}

		$windowId = $this->_Admin_Form_Controller->getWindowId();

		// New values of property
		$aNewFiles = Core_Array::getFiles("file", array());

		// New values of property
		if (is_array($aNewFiles) && isset($aNewFiles['name']))
		{
			$iCount = count($aNewFiles['name']);

			for ($i = 0; $i < $iCount; $i++)
			{
				ob_start();

					$aFile = array(
						'name' => $aNewFiles['name'][$i],
						'tmp_name' => $aNewFiles['tmp_name'][$i],
						'size' => $aNewFiles['size'][$i]
					);

					$oCore_Html_Entity_Script = Core::factory('Core_Html_Entity_Script')
						->type("text/javascript")
						->value("$(\"#{$windowId} #file:has(input\\[name='file\\[\\]'\\])\").eq(0).remove();");

					if (intval($aFile['size']) > 0)
					{
						$oEvent_Attachment = Core_Entity::factory('Event_Attachment');

						$oEvent_Attachment->event_id = $this->_object->id;

						$oEvent_Attachment
							->saveFile($aFile['tmp_name'], $aFile['name']);

						if (!is_null($oEvent_Attachment->id))
						{
							$oCore_Html_Entity_Script
								->value("$(\"#{$windowId} #file\").find(\"input[name='file\\[\\]']\").eq(0).attr('name', 'file_{$oEvent_Attachment->id}');");
						}
					}

					$oCore_Html_Entity_Script
						->execute();

				$this->_Admin_Form_Controller->addMessage(ob_get_clean());
			}
		}

		// Создаем уведомление
		if (!is_null($oModule = Core_Entity::factory('Module')->getByPath('event')))
		{
			/*
			switch ($iEventType)
			{
				case 3: // Дело
					$sUserRoleName = 'исполнителей';
					break;

				default:
					$sUserRoleName = 'участников';
			}
			*/

			// Идентификатор формы "Пользователи центра администрирования (сотрудники)"
			$iAdmin_Form_Id = 8;
			$oAdmin_Form = Core_Entity::factory('Admin_Form', $iAdmin_Form_Id);

			$windowId = $this->_Admin_Form_Controller->getWindowId();

			// Контроллер формы
			$oAdmin_Form_Controller = Admin_Form_Controller::create($oAdmin_Form);
			$oAdmin_Form_Controller
				->path('/admin/user/index.php')
				->window($windowId);

			// Есть сотрудники, удаленные из списка исполнителей
			if (count($aNotificationEventExcludedUserId))
			{
				// Добавляем уведомление
				$oNotification = Core_Entity::factory('Notification')
					->title($oEvent->name)
					->description(Core::_('Event.notificationDescriptionType1', htmlspecialchars($oCurrentUser->getFullName()))) //$oCurrentUser->getFullName() . ' исключил Вас из списка ' . $sUserRoleName)
					->datetime(Core_Date::timestamp2sql(time()))
					->module_id($oModule->id)
					->type(1) // 1 - сотрудник исключен из списка исполнителей дела
					->entity_id($oEvent->id)
					->save();

				// Связываем уведомление с сотрудниками
				foreach ($aNotificationEventExcludedUserId as $iUserId)
				{
					Core_Entity::factory('Notification_User')
						->notification_id($oNotification->id)
						->user_id($iUserId)
						->save();
				}
			}

			// Есть исполнители
			if (count($aNotificationEventParticipantUserId))
			{
				// Добавляем уведомление
				$oNotification = Core_Entity::factory('Notification')
					->title($oEvent->name)
					->description(Core::_('Event.notificationDescriptionType0', htmlspecialchars($oCurrentUser->getFullName())))  //($oCurrentUser->getFullName() . ' добавил Вас в список ' . $sUserRoleName)
					->datetime(Core_Date::timestamp2sql(time()))
					->module_id($oModule->id)
					->type(0) // 0 - сотрудник добален исполнителем дела
					->entity_id($oEvent->id)
					->save();

				// Связываем уведомление с сотрудниками
				foreach ($aNotificationEventParticipantUserId as $iUserId)
				{
					Core_Entity::factory('Notification_User')
						->notification_id($oNotification->id)
						->user_id($iUserId)
						->save();
				}
			}

			// Завершенность изменена
			if ($eventCompletedBefore != $this->_object->completed)
			{
				// Отправляем уведомления ответственным сотрудникам
				$this->_object->changeCompletedSendNotification();
			}
		}

		// Клиенты, связанные с событием
		$aEventSiteusers = $oEvent->Event_Siteusers->findAll();

		$aEventSiteuserId = Core_Array::getPost('event_siteuser_id');

		!is_array($aEventSiteuserId) && $aEventSiteuserId = array();

		$aExcludeIndexes = array();
		foreach ($aEventSiteusers as $oEventSiteuser)
		{
			$iSearchIndex = array_search($oEventSiteuser->siteuser_company_id ? ('company_' . $oEventSiteuser->siteuser_company_id) : ('person_' . $oEventSiteuser->siteuser_person_id), $aEventSiteuserId);
			//$iSearchIndex = array_search($oEventSiteuser->id, $aEventSiteuserId);

			if ($iSearchIndex === FALSE)
			{
				$oEventSiteuser->delete();
			}
			else
			{
				$aExcludeIndexes[] = $iSearchIndex;
			}
		}

		foreach ($aEventSiteuserId as $key => $sEventSiteuserId)
		{
			if (!in_array($key, $aExcludeIndexes))
			{
				$aTmp = explode('_', $sEventSiteuserId);

				if (count($aTmp))
				{
					if ($aTmp[0] == 'company')
					{
						$iEventSiteuserCompanyId = intval($aTmp[1]);
						$iEventSiteuserPersonId = 0;
					}
					else
					{
						$iEventSiteuserCompanyId = 0;
						$iEventSiteuserPersonId = intval($aTmp[1]);
					}

					$oEventSiteuser = Core_Entity::factory('Event_Siteuser')
						->siteuser_company_id($iEventSiteuserCompanyId)
						->siteuser_person_id($iEventSiteuserPersonId);

					$oEvent->add($oEventSiteuser);
				}
			}
		}

		// Связывание дела со сделкой
		if (Core::moduleIsActive('deal') && $bAddEvent)
		{
			$iDealId = intval(Core_Array::getGet('deal_id'));

			if ($iDealId)
			{
				$oDeal = Core_Entity::factory('Deal', $iDealId);
				$oDeal->add($this->_object);

				/*$this
					//->clearContent()
					->addContent('<script type="text/javascript">$(\'#refresh-toggler\').click();</script>');*/
			}
		}

		Core_Event::notify(get_class($this) . '.onAfterRedeclaredApplyObjectProperty', $this, array($this->_Admin_Form_Controller));
	}

	/**
	 * Executes the business logic.
	 * @param mixed $operation Operation name
	 * @return mixed
	 */
	public function execute($operation = NULL)
	{
		$oUser = Core_Entity::factory('User', 0)->getCurrent();

		$iDealId = intval(Core_Array::getGet('deal_id'));

		$sJsRefresh = '<script type="text/javascript">
		$("#calendar").fullCalendar("refetchEvents");
		if ($(".kanban-board").length && typeof _windowSettings != \'undefined\') {
			$(\'#refresh-toggler\').click();
		}

		// Refresh deal events list
		if ($("#deal-events").length)
		{
			$.adminLoad({ path: \'/admin/deal/event/index.php\', additionalParams: \'deal_id=' . $iDealId . '\', windowId: \'deal-events\' });
		}
		</script>';

		switch ($operation)
		{
			case 'save':
			case 'saveModal':
			case 'applyModal':
				$aEventUserId = Core_Array::get($this->_formValues, 'event_user_id');

				// Редактирование дела
				if (!is_null($this->_object->id))
				{
					$oEventCreator = $this->_object->getCreator();
					if ($oEventCreator && $oEventCreator->id == $oUser->id)
					{
						// Заданы ответственные сотрудники
						if (count($aEventUserId))
						{
							$bError = TRUE;

							//foreach ($aEventUserId as $key => $sEventUserId)
							foreach ($aEventUserId as $key => $iEventUserId)
							{
								//$aTmp = explode('_', $sEventUserId);

								// Идентификатор сотрудника
								//$iEventUserId = intval($aTmp[2]);

								// Проверяем задан ли создатель дела
								if ($iEventUserId == $oUser->id)
								{
									 $bError = FALSE;
									 break;
								}
							}

							if ($bError)
							{
								$this->addMessage(
									Core_Message::get(Core::_('Event.creatorNotDefined'), 'error')
								);
								return TRUE;
							}
						}
						else // Нет ответственных пользователей
						{
							$this->addMessage(
								Core_Message::get(Core::_('Event.notSetResponsibleEmployees'), 'error')
							);
							return TRUE;
						}
					}
				}

				$operation == 'saveModal' && $this->addMessage($sJsRefresh);
				$operation == 'applyModal' && $this->addContent($sJsRefresh);
			break;
			case 'markDeleted':
				$this->_object->markDeleted();

				$operation == 'markDeleted' && $this->addContent($sJsRefresh);
			break;
		}

		// Запрещаем сотрудникам доступ к делам, в которых они не принимают участие
		if (!is_null($this->_object->id) && !$this->_object->checkPermission2View($oUser)
			/*$this->_object->Event_Users->getCountByUser_id($oUser->id, FALSE) == 0*/)
		{
			return TRUE;
		}

		return parent::execute($operation);
	}

	/**
	 * Add save and apply buttons
	 * @return Admin_Form_Entity_Buttons
	 * @hostcms-event Admin_Form_Action_Controller_Type_Edit_Show.onBeforeAddButtons
	 * @hostcms-event Admin_Form_Action_Controller_Type_Edit_Show.onAfterAddButtons
	 */
	protected function _addButtons()
	{
		$oUser = Core_Entity::factory('User', 0)->getCurrent();

		$iCreatorUserId = 0;

		if ($this->_object->id)
		{
			$aEvent_Users = $this->_object->Event_Users->findAll();

			foreach ($aEvent_Users as $oEvent_User)
			{
				// Идентификатор создателя дела
				$oEvent_User->creator && $iCreatorUserId = $oEvent_User->user_id;
			}
		}
		else
		{
			$iCreatorUserId = $oUser->id;
		}

		if ($this->_object->id && $iCreatorUserId != $oUser->id)
		{
			// Кнопки
			$oAdmin_Form_Entity_Buttons = Admin_Form_Entity::factory('Buttons');

			$sOperaion = $this->_Admin_Form_Controller->getOperation();
			$sOperaionSufix = $sOperaion == 'modal'
				? 'Modal'
				: '';

			if ($sOperaionSufix == '')
			{
				// Кнопка Назад
				$oAdmin_Form_Entity_Button_Back = Admin_Form_Entity::factory('Button')
					->name('back')
					->class('btn btn-yellow')
					->value(Core::_('Event.back'))
					->onclick(
						$this->_Admin_Form_Controller->getAdminLoadAjax($this->_Admin_Form_Controller->getPath(), NULL, NULL, '')
					);

				$oAdmin_Form_Entity_Buttons->add($oAdmin_Form_Entity_Button_Back);
			}

			// Кнопка Применить
			$oAdmin_Form_Entity_Button_Apply = Admin_Form_Entity::factory('Button')
				->name('apply')
				->class('btn btn-palegreen')
				->type('submit')
				->value(Core::_('Admin_Form.apply'))
				->onclick(
					$this->_Admin_Form_Controller->getAdminSendForm(NULL, 'apply' . $sOperaionSufix)
				);

			$oAdmin_Form_Entity_Buttons->add($oAdmin_Form_Entity_Button_Apply);
		}
		elseif ($this->_object->id && $iCreatorUserId == $oUser->id
			&& $this->_Admin_Form_Controller->getOperation() == 'modal')
		{
			$oAdmin_Form_Entity_Buttons = Admin_Form_Entity::factory('Buttons');

			$sOperaion = $this->_Admin_Form_Controller->getOperation();
			$sOperaionSufix = $sOperaion == 'modal'
				? 'Modal'
				: '';

			// Кнопка Сохранить
			$oAdmin_Form_Entity_Button_Save = Admin_Form_Entity::factory('Button')
				->name('save')
				->class('btn btn-blue')
				->value(Core::_('admin_form.save'))
				->onclick(
					$this->_Admin_Form_Controller->getAdminSendForm(NULL, 'save' . $sOperaionSufix)
				);

			$oAdmin_Form_Entity_Button_Apply = Admin_Form_Entity::factory('Button')
				->name('apply')
				->class('btn btn-palegreen')
				->type('submit')
				->value(Core::_('admin_form.apply'))
				->onclick(
					$this->_Admin_Form_Controller->getAdminSendForm(NULL, 'apply' . $sOperaionSufix)
				);

			// $windowId = $this->_Admin_Form_Controller->getWindowId();

			// Кнопка Удалить
			$oAdmin_Form_Entity_Button_Delete = Admin_Form_Entity::factory('Button')
				->name('markDeleted')
				->class('btn btn-darkorange pull-right')
				->type('submit')
				->value(Core::_('Admin_Form.delete'))
				->onclick(
					"res = confirm('" . Core::_('Admin_Form.confirm_dialog', htmlspecialchars(Core::_('Admin_Form.delete'))) . "'); if (res) {" . $this->_Admin_Form_Controller->getAdminSendForm(NULL, 'markDeleted') . "} else { return false; }"
				);

			$oAdmin_Form_Entity_Buttons
				->add($oAdmin_Form_Entity_Button_Save)
				->add($oAdmin_Form_Entity_Button_Apply)
				->add($oAdmin_Form_Entity_Button_Delete);
		}
		else
		{
			$oAdmin_Form_Entity_Buttons = TRUE;
		}

		return $oAdmin_Form_Entity_Buttons;
	}
}