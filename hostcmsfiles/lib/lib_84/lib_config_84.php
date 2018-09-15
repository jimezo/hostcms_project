<?php

$oShop = Core_Entity::factory('Shop', Core_Array::get(Core_Page::instance()->libParams, 'shopId'));

$Comment_Shop_Controller_Show = new Comment_Shop_Controller_Show($oShop);

$limit = Core_Array::get(Core_Page::instance()->libParams, 'limit');

$Comment_Shop_Controller_Show
	->limit($limit)
	->parseUrl();

Core_Page::instance()->object = $Comment_Shop_Controller_Show;