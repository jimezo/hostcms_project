<?php
if (Core::moduleIsActive('search'))
{
	$action = Core_Array::get(Core_Page::instance()->widgetParams, 'action');
	$placeholder = Core_Array::get(Core_Page::instance()->widgetParams, 'placeholder');			
?>
	<form class="top-search-form" method="get" action="<?php echo $action?>">
		<div class="form-search">
			<input id="search" type="text" name="text" placeholder="<?php echo $placeholder?>">
			<i class="fa fa-search" onclick="$(this).closest('form').submit();"></i>
		</div>
	</form>
<?php
}