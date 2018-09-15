<?php

defined('HOSTCMS') || exit('HostCMS: access denied.');

/**
 * Admin forms.
 *
 * @package HostCMS
 * @subpackage Skin
 * @version 6.x
 * @author Hostmake LLC
 * @copyright © 2005-2018 ООО "Хостмэйк" (Hostmake LLC), http://www.hostcms.ru
 */
class Event_Controller_Kanban extends Admin_Form_Controller_View
{
	public function execute()
	{
		$oAdmin_Form_Controller = $this->_Admin_Form_Controller;
		$oAdmin_Form = $oAdmin_Form_Controller->getAdminForm();

		$oAdmin_View = Admin_View::create($this->_Admin_Form_Controller->Admin_View)
			->pageTitle($oAdmin_Form_Controller->pageTitle)
			->module($oAdmin_Form_Controller->module);

		$aAdminFormControllerChildren = array();

		foreach ($oAdmin_Form_Controller->getChildren() as $oAdmin_Form_Entity)
		{
			if ($oAdmin_Form_Entity instanceof Skin_Bootstrap_Admin_Form_Entity_Breadcrumbs
				|| $oAdmin_Form_Entity instanceof Skin_Bootstrap_Admin_Form_Entity_Menus)
			{
				$oAdmin_View->addChild($oAdmin_Form_Entity);
			}
			else
			{
				$aAdminFormControllerChildren[] = $oAdmin_Form_Entity;
			}
		}

		// При показе формы могут быть добавлены сообщения в message, поэтому message показывается уже после отработки формы
		ob_start();
		?>
		<div class="table-toolbar">
			<?php $this->_Admin_Form_Controller->showFormMenus()?>
			<div class="table-toolbar-right pull-right">
				<?php $this->_Admin_Form_Controller->pageSelector()?>
				<?php $this->_Admin_Form_Controller->showChangeViews()?>
			</div>
			<div class="clear"></div>
		</div>
		<?php
		foreach ($aAdminFormControllerChildren as $oAdmin_Form_Entity)
		{
			$oAdmin_Form_Entity->execute();
		}

		$this->_showContent();
		$content = ob_get_clean();

		$oAdmin_View
			->content($content)
			->message($oAdmin_Form_Controller->getMessage())
			->show();

		//$oAdmin_Form_Controller->applyEditable();
		$oAdmin_Form_Controller->showSettings();

		return $this;
	}

	/**
	 * Show form content in administration center
	 * @return self
	 */
	protected function _showContent()
	{
		$oAdmin_Form_Controller = $this->_Admin_Form_Controller;
		$oAdmin_Form = $oAdmin_Form_Controller->getAdminForm();

		$oAdmin_Language = $oAdmin_Form_Controller->getAdminLanguage();

		$aAdmin_Form_Fields = $oAdmin_Form->Admin_Form_Fields->findAll();

		$oSortingField = $oAdmin_Form_Controller->getSortingField();

		if (empty($aAdmin_Form_Fields))
		{
			throw new Core_Exception('Admin form does not have fields.');
		}

		$windowId = $oAdmin_Form_Controller->getWindowId();

		$oUser = Core_Entity::factory('User', 0)->getCurrent();

		$oEvent_Statuses = Core_Entity::factory('Event_Status');
		$oEvent_Statuses->queryBuilder()
			->clearOrderBy()
			->orderBy('event_statuses.sorting', 'ASC');

		$aEvent_Statuses = $oEvent_Statuses->findAll(FALSE);

		$aStatuses = array(0 => Core::_('Event.notStatus'));

		foreach ($aEvent_Statuses as $oEvent_Status)
		{
			$aStatuses[$oEvent_Status->id] = $oEvent_Status->name;
		}

		$aColors = array(
			'blue',
			'palegreen',
			'warning',
			'darkorange',
			'danger',
			'maroon',
		);
		$iCountColors = count($aColors);

		// Устанавливаем ограничения на источники
		$oAdmin_Form_Controller->setDatasetConditions();

		$aDatasets = $oAdmin_Form_Controller->getDatasets();

		$aEntities = $aDatasets[0]->load();
		?>
		<!-- <div class="container kanban-board hidden">-->
		<div class="container kanban-board">
			<div class="horizon-prev"><img src="/hostcmsfiles/images/scroll/l-arrow.png"></div>
			<div class="horizon-next"><img src="/hostcmsfiles/images/scroll/r-arrow.png"></div>
			<div class="row">
			<?php
				foreach ($aStatuses as $iEventStatusId => $sEventStatusName)
				{
					?>
					<div class="col-xs-12 col-sm-3">
						<h5><?php echo htmlspecialchars($sEventStatusName)?></h5>
						<ul id="<?php echo $iEventStatusId?>" class="kanban-list">
						<?php
						foreach ($aEntities as $key => $oEntity)
						{
							$color = $iCountColors
								? $aColors[$key % $iCountColors]
								: 'palegreen';

							if ($oEntity->event_status_id == $iEventStatusId)
							{
								$oEventCreator = $oEntity->getCreator();
								$userIsEventCreator = $oEventCreator && $oEventCreator->id == $oUser->id;
							?>
							<li id="<?php echo $oEntity->id?>">
								<div class="well bordered-left bordered-<?php echo $color?>">
									<div class="drag-handle"></div>
									<div class="row">
										<div class="col-xs-12 col-sm-6">
											<?php echo $oEntity->showType()?>
										</div>
										<div class="col-xs-12 col-sm-6 well-avatar text-align-right">
											<?php
											if (!$userIsEventCreator)
											{
											?>
												<img src="<?php echo $oEventCreator->getAvatar()?>" title="<?php echo htmlspecialchars($oEventCreator->getFullName())?>"/>
											<?php
											}
											?>

											<img src="<?php echo $oUser->getAvatar()?>" title="<?php echo htmlspecialchars($oUser->getFullName())?>"/>
										</div>
									</div>
									<div class="row">
										<div class="col-xs-12 well-body">
											<span><?php echo htmlspecialchars($oEntity->name)?></span>
										</div>
									</div>
									<?php
									if (strlen($oEntity->description))
									{
									?>
									<div class="row">
										<div class="col-xs-12 well-description">
											<span><?php echo htmlspecialchars($oEntity->description)?></span>
										</div>
									</div>
									<?php
									}
									?>
									<div class="row">
										<div class="col-xs-12 well-description">
											<div class="event-date">
											<?php
											if ($oEntity->all_day)
											{
												echo Event_Controller::getDate($oEntity->start);
											}
											else
											{
												if (!is_null($oEntity->start) && $oEntity->start != '0000-00-00 00:00:00')
												{
													echo Event_Controller::getDateTime($oEntity->start);
												}

												if (!is_null($oEntity->start) && $oEntity->start != '0000-00-00 00:00:00'
													&& !is_null($oEntity->finish) && $oEntity->finish != '0000-00-00 00:00:00'
												)
												{
													echo ' — ';
												}

												if (!is_null($oEntity->finish) && $oEntity->finish != '0000-00-00 00:00:00')
												{
													?><strong><?php echo Event_Controller::getDate($oEntity->finish);?></strong><?php
												}
											}
											?>
											</div>
										</div>
									</div>
									<div class="edit-entity" onclick="$.modalLoad({path: '/admin/event/index.php', action: 'edit',operation: 'modal', additionalParams: 'hostcms[checked][0][<?php echo $oEntity->id?>]=1', windowId: 'id_content'});"><i class="fa fa-pencil"></i></div>
								</div>
							</li>
							<?php
							}
						}
						?>
						</ul>
					</div>
					<?php
				}
				?>
			</div>
		</div>
		<script type="text/javascript">
		$(function() {
			$.sortableKanban('/admin/event/index.php');

			var $kanban = $('.kanban-board > .row'),
				$prevNav = $('.horizon-prev', '.kanban-board'),
				$nextNav = $('.horizon-next', '.kanban-board');

			$.fn.horizon = function () {
				// Set mousewheel event
				$kanban.mousewheel(function(event, delta) {
					this.scrollLeft += (delta * 30);

					showButtons(this.scrollLeft);

					event.preventDefault();
				});

				// Click and hold action on nav buttons
				$nextNav.mousedown(function () {
					if ($.fn.horizon.defaults.interval)
					{
						clearInterval($.fn.horizon.defaults.interval);
					}

					$.fn.horizon.defaults.interval = setInterval(function() { scrollRight(); }, 50);
				}).mouseup(function() {
					clearInterval($.fn.horizon.defaults.interval);
				});

				$prevNav.mousedown(function () {
					if ($.fn.horizon.defaults.interval)
					{
						clearInterval($.fn.horizon.defaults.interval);
					}

					$.fn.horizon.defaults.interval = setInterval(function() { scrollLeft(); }, 50);
				}).mouseup(function() {
					clearInterval($.fn.horizon.defaults.interval);
				});

				// Keyboard buttons
				$(window).on('keydown', function (e) {
					if (scrolls[e.which]) {
						scrolls[e.which]();
						e.preventDefault();
					}
				});

				showButtons($.fn.horizon.defaults.interval);
			};

			// Global vars
			$.fn.horizon.defaults = {
				delta: 0,
				interval: 0
			};

			// Left scroll
			var scrollLeft = function () {
				var i2 = $.fn.horizon.defaults.delta - 1;
				$kanban.scrollLeft($kanban.scrollLeft() + (i2 * 30));

				showButtons($kanban.scrollLeft());
			};

			// Right scroll
			var scrollRight = function () {
				var i2 = $.fn.horizon.defaults.delta + 1;
				$kanban.scrollLeft($kanban.scrollLeft() + (i2 * 30));

				showButtons($kanban.scrollLeft());
			};

			// Left-Right buttons
			var showButtons = function (index) {
				if (index === 0) {
					if ($.fn.horizon.defaults.interval)
					{
						$prevNav.hide(function (){
							clearInterval($.fn.horizon.defaults.interval);
						});
					}
					else
					{
						$prevNav.hide();
					}

					$nextNav.show();
				} else if (index >= $kanban.width()) {
					$prevNav.show();

					if ($.fn.horizon.defaults.interval)
					{
						$nextNav.hide(function (){
							clearInterval($.fn.horizon.defaults.interval);
						});
					}
					else
					{
						$nextNav.hide();
					}
				} else {
					$nextNav.show();
					$prevNav.show();
				}
			};

			// Keyboard buttons array
			var scrolls = {
				'right': scrollRight,
				'down': scrollRight,
				'left': scrollLeft,
				'up': scrollLeft,
				37: scrollLeft,
				38: scrollRight,
				39: scrollRight,
				40: scrollLeft
			};

			$kanban.horizon();
		});
		</script>
		<?php

		return $this;
	}
}