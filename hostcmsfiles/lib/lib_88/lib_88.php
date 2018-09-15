<?php
$year = Core_Array::get(Core_Page::instance()->widgetParams, 'years');
$company = Core_Array::get(Core_Page::instance()->widgetParams, 'company');
?>

<div class="hostcms_link">
Copyright &copy; <?php echo htmlspecialchars($year)?> <?php echo htmlspecialchars($company)?>. Работает на <a href="http://www.hostcms.ru" title="Система управления сайтом HostCMS">HostCMS</a>
</div>