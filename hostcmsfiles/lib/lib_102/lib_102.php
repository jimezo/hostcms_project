<?php
	$link = Core_Array::get(Core_Page::instance()->widgetParams, 'link');
	$title = Core_Array::get(Core_Page::instance()->widgetParams, 'title');
	$image = Core_Array::get(Core_Page::instance()->widgetParams, 'image');
?>

<!-- Logo -->
<div class="logo">
	<a href="<?php echo $link?>" title="<?php echo htmlspecialchars($title)?>"><img src="<?php echo $image?>"></a>
</div>