<?php
	$address = htmlspecialchars(Core_Array::get(Core_Page::instance()->widgetParams, 'address'));
	$phone = htmlspecialchars(Core_Array::get(Core_Page::instance()->widgetParams, 'phone'));
	$email = htmlspecialchars(Core_Array::get(Core_Page::instance()->widgetParams, 'email'));
?>

<section class="block-contacts">
	<div>
		<h4 class="contacts">Контактная информация</h4>
		<ul class="toggle-footer">
			<li class="address-info"> <?php echo $address ?> </li>
			<li class="phone-info"><i class="fa fa-phone"></i><?php echo $phone ?> </li>
			<li class="email-info">
				<i class="fa fa-envelope"></i><a href="mailto:<?php echo $email ?>"><?php echo $email ?></a>
			</li>
		</ul>
	</div>
</section>