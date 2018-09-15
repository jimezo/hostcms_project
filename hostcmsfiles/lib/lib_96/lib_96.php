<?php
$aImages = Core_Array::get(Core_Page::instance()->widgetParams, 'image');
$aTitles = Core_Array::get(Core_Page::instance()->widgetParams, 'title');
$aTexts = Core_Array::get(Core_Page::instance()->widgetParams, 'text');
$aLinks = Core_Array::get(Core_Page::instance()->widgetParams, 'link');

if (is_array($aImages) && count($aImages))
{
?>
	<script>
		$(function() {
			var demo1 = $("#main-slider").slippry({
				useCSS: true,

				// general elements & wrapper
				slippryWrapper: '<div class="sy-box news-slider" />', // wrapper to wrap everything, including pager
				elements: 'article', // elments cointaining slide content

				// options
				adaptiveHeight: false, // height of the sliders adapts to current
				captions: false,

				// pager
				//pagerClass: 'news-pager',

				// transitions
				transition: 'horizontal', // fade, horizontal, kenburns, false
				speed: 1200,
				pause: 8000,

				autoDirection: 'next'
			});

			$('.stop').click(function () {
				demo1.stopAuto();
			});

			$('.start').click(function () {
				demo1.startAuto();
			});

			$('.prev').click(function () {
				demo1.goToPrevSlide();
				return false;
			});
			$('.next').click(function () {
				demo1.goToNextSlide();
				return false;
			});
			$('.reset').click(function () {
				demo1.destroySlider();
				return false;
			});
			$('.reload').click(function () {
				demo1.reloadSlider();
				return false;
			});
			$('.init').click(function () {
				demo1 = $("#main_slider").slippry();
				return false;
			});
		});
	</script>

	<style>
	.news-slider .text-content {
		position: absolute;
		top: 0;
		right: 30px;
		padding: 1em;
		width: 30%;
		height: 100%;
	}
	.news-slider .text-content h2 {
		margin: 0;
		font-size: 30px;
		color: #fff;
		padding: 15px;
		background-color: rgba(0,0,0,.1);
	}
	.news-slider .text-content p {
		margin: 1em 0;
		color: #eee;
		line-height: 23px;
		display: none;
		background-color: rgba(0,0,0,.1);
		padding: 15px;
	}
	.news-slider .text-content a.button-link {
		padding: 0.25em 0.5em;
		position: absolute;
		bottom: 3em;
		right: 3em;
		background-color: rgba(0,0,0,.1);
		color: #fff;
		display: inline-block;
		font-size: 0.8em;
		font-weight: 700;
		letter-spacing: 0.1em;
		text-align: center;
		text-decoration: none;
		text-transform: uppercase;
		vertical-align: text-bottom;
		border: 1px solid #fff;
	}
	.news-slider .image-content {
		line-height: 0;
	}
	.news-slider .image-content img {
		max-width: 100%;
	}
	@media (max-width: 768px) {
		.news-slider .text-content { width: 40%; }
		.news-slider .text-content h2 { font-size: 10px; }
	}
	@media only screen and (min-width: 769px) {
		.news-slider .text-content {
			width: 55%;
		}
		.news-slider .text-content p {
			display: block;
		}
	}
	</style>

<section id="main-slider">
<?php
	foreach ($aImages as $key => $path)
	{
		?><article>
			<?php
			if (isset($aTitles[$key]) || isset($aTexts[$key]) || isset($aLinks[$key]))
			{
				?><div class="text-content">
				<?php
				if (isset($aTitles[$key]))
				{
				  ?><h2><?php echo $aTitles[$key]?></h2><?php
				}

				if (isset($aTexts[$key]))
				{
				  ?><p><?php echo $aTexts[$key]?></p><?php
				}

				if (isset($aLinks[$key]))
				{
				  ?><a href="<?php echo $aLinks[$key]?>" class="button-link read-more">подробнее</a><?php
				}
				?></div><?php
			}
			?>
			<div class="image-content"><img src="<?php echo htmlspecialchars($path)?>" alt="slide_<?php echo htmlspecialchars($key)?>"></div>
		  </article>
		<?php
	}
?>
</section>
<?php
}