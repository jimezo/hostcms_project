<?php

if (!Core::moduleIsActive('siteuser'))
{
	?>
	<h1>Пользователи сайта</h1>
	<p>Функционал недоступен, приобретите более старшую редакцию.</p>
	<p>Модуль &laquo;<a href="http://www.hostcms.ru/hostcms/modules/users/">Пользователи сайта</a>&raquo; доступен в редакциях &laquo;<a href="http://www.hostcms.ru/hostcms/editions/corporation/">Корпорация</a>&raquo; и &laquo;<a href="http://www.hostcms.ru/hostcms/editions/business/">Бизнес</a>&raquo;.</p>
	<?php
	return ;
}

$Siteuser_Controller_Show = Core_Page::instance()->object;

$xslUserAuthorization = Core_Array::get(Core_Page::instance()->libParams, 'userAuthorizationXsl');

$oSiteuser = $Siteuser_Controller_Show->getEntity();

if ($oSiteuser->id)
{
	if (Core::moduleIsActive('shop'))
	{
		/* Последние заказы пользователя */
		$oShop_Orders = Core_Entity::factory('Shop_Order');

		$oShop_Orders
			->queryBuilder()
			->leftJoin('shops', 'shop_orders.shop_id', '=', 'shops.id')
			->where('shop_orders.siteuser_id', '=', $oSiteuser->id)
			->where('shops.site_id', '=', CURRENT_SITE)
			->limit(3)
			->clearOrderBy()
			->orderBy('shop_orders.id', 'DESC');

		$aShop_Orders = $oShop_Orders->findAll(FALSE);

		foreach ($aShop_Orders as $oShop_Order)
		{
			$sum = $oShop_Order->sum();

			$aShop_Order_Items = $oShop_Order->Shop_Order_Items->findAll(FALSE);

			foreach ($aShop_Order_Items as $oShop_Order_Item)
			{
				$oShop_Order->addEntity(
					$oShop_Order_Item->clearEntities()
				);
			}

			$oShop_Order
				->showXmlOrderStatus(TRUE)
				->showXmlDelivery(TRUE);

			//Currency
			$oShop_Currency = Core_Entity::factory('Shop_Currency', $oShop_Order->shop_currency_id);

			if (!is_null($oShop_Currency))
			{
				$oShop_Order->addEntity(
					$oShop_Currency
				);
			}

			$Siteuser_Controller_Show->addEntity(
				$oShop_Order
					->addEntity(
						Core::factory('Core_Xml_Entity')
						->name('sum')
						->value($sum)
				)
			);
		}

		$aShops = Core_Entity::factory('Shop')->getAllBySite_id(CURRENT_SITE);

		/* Просмотренные */
		$Siteuser_Controller_Show->addEntity(
				$oViewedEntity = Core::factory('Core_Xml_Entity')
					->name('viewed')
			);

		if (count($aShops))
		{
			$hostcmsViewed = array();
			foreach ($aShops as $oShop)
			{
				$hostcmsViewed = array_merge(
					$hostcmsViewed,
					Core_Array::get(Core_Array::get($_SESSION, 'hostcmsViewed', array()), $oShop->id, array())
				);
			}

			// Extract a slice of the array
			$hostcmsViewed = array_slice($hostcmsViewed, 0, 6);

			foreach ($hostcmsViewed as $view_item_id)
			{
				$oShop_Item = Core_Entity::factory('Shop_Item')->find($view_item_id);

				if (!is_null($oShop_Item->id) && $oShop_Item->active)
				{
					$oViewedEntity->addEntity($oShop_Item->clearEntities());
				}
			}
		}

		/* Избранное */
		$Siteuser_Controller_Show->addEntity(
				$oFavouriteEntity = Core::factory('Core_Xml_Entity')
					->name('favorite')
			);

		if (count($aShops))
		{
			$hostcmsFavorite = array();
			foreach ($aShops as $oShop)
			{
				$hostcmsFavorite = array_merge(
					$hostcmsFavorite,
					Core_Array::get(Core_Array::get($_SESSION, 'hostcmsFavorite', array()), $oShop->id, array())
				);
			}

			// Extract a slice of the array
			$hostcmsFavorite = array_slice($hostcmsFavorite, 0, 6);

			foreach ($hostcmsFavorite as $shop_item_id)
			{
				$oShop_Item = Core_Entity::factory('Shop_Item')->find($shop_item_id);
				if (!is_null($oShop_Item->id) && $oShop_Item->active)
				{
					$oFavouriteEntity->addEntity($oShop_Item->clearEntities());
				}
			}
		}

		/* Лицевой счет */
		$Siteuser_Controller_Show->addEntity(
				$oAccountEntity = Core::factory('Core_Xml_Entity')
					->name('account')
			);

		if (count($aShops))
		{
			foreach ($aShops as $oShop)
			{
				$amount = $oSiteuser->getTransactionsAmount($oShop);

				$oShop->addEntity(
					Core::factory('Core_Xml_Entity')
						->name('transaction_amount')
						->value($amount)
				);

				$oAccountEntity->addEntity(
					$oShop
				);
			}
		}

		/* Объявления */
		$oCore_QueryBuilder_Select = Core_QueryBuilder::select()
			->select(array(Core_QueryBuilder::expression('COUNT(*)'), 'count'))
			->from('shop_items')
			->join('shops', 'shop_items.shop_id', '=', 'shops.id')
			->where('shop_items.active', '=', 1)
			->where('shop_items.deleted', '=', 0)
			->where('shop_items.siteuser_id', '=', $oSiteuser->id)
			->where('shops.site_id', '=', CURRENT_SITE);

		$row = $oCore_QueryBuilder_Select->execute()->asAssoc()->result();

		$Siteuser_Controller_Show->addEntity(
				$oFavouriteEntity = Core::factory('Core_Xml_Entity')
					->name('siteuser_advertisement_count')
					->value($row[0]['count'])
			);
	}

	if (Core::moduleIsActive('maillist'))
	{
		/* Почтовые рассылки */
		$aMaillists = $oSiteuser->getAllowedMaillists();

		if (count($aMaillists))
		{
			$Siteuser_Controller_Show->addEntity(
					$oMaillistEntity = Core::factory('Core_Xml_Entity')
						->name('maillists')
				);

			foreach ($aMaillists as $oMaillist)
			{
				$oMaillist_Siteuser = $oSiteuser->Maillist_Siteusers->getByMaillist($oMaillist->id);

				$oMaillistEntity->addEntity(
					$oMaillist->clearEntities()
				);

				if (!is_null($oMaillist_Siteuser))
				{
					$oMaillist->addEntity(
						$oMaillist_Siteuser->clearEntities()
					);
				}
			}
		}
	}

	/* Messages */
	if (Core::moduleIsActive('message'))
	{
		$oMessage_Topics = Core_Entity::factory('Message_Topic');
		$oMessage_Topics
			->queryBuilder()
			->where('message_topics.deleted_by_sender', '=', 0)
			->where('message_topics.deleted_by_recipient', '=', 0)
			->where('message_topics.recipient_siteuser_id', '=', $oSiteuser->id)
			->clearOrderBy()
			->orderBy('message_topics.id', 'DESC');

		$aMessage_Topics = $oMessage_Topics->findAll(FALSE);

		foreach ($aMessage_Topics as $oMessage_Topic)
		{
			$Siteuser_Controller_Show->addEntity(
				$oMessage_Topic->clearEntities()
			);
		}
	}

	if (Core::moduleIsActive('helpdesk'))
	{
		$aHelpdesks = Core_Entity::factory('Site', CURRENT_SITE)->Helpdesks->findAll(FALSE);

		if (count($aHelpdesks))
		{
			$Siteuser_Controller_Show->addEntity(
				$oTicketEntity = Core::factory('Core_Xml_Entity')
					->name('helpdesk_tickets')
			);

			$oHelpdesk = $aHelpdesks[0];

			$oHelpdesk_Tickets = $oHelpdesk->Helpdesk_Tickets;

			$oHelpdesk_Tickets
				->queryBuilder()
				->where('helpdesk_tickets.siteuser_id', '=', $oSiteuser->id)
				->limit(3)
				->clearOrderBy()
				->orderBy('helpdesk_tickets.id', 'DESC');

			$aHelpdesk_Tickets = $oHelpdesk_Tickets->findAll(FALSE);

			foreach ($aHelpdesk_Tickets as $oHelpdesk_Ticket)
			{
				$oTicketEntity->addEntity(
					$oHelpdesk_Ticket->clearEntities()
						->showXmlSiteuser(FALSE)
				);
			}
		}
	}
}

$Siteuser_Controller_Show->xsl(
	Core_Entity::factory('Xsl')->getByName($xslUserAuthorization)
)
->show();