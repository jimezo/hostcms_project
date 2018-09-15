var block = document.getElementById('stickyBlock')
$('#stickyBlock').on('click', function() {
  if(block.style['width'] == 50 + 'px') {
    $('#stickyBlock').show('slow', function() {
      for(var i=0; i < 400; i += 2) {
        block.style['width'] = 400 + 'px';
      }
      $('#stickyBlock h2').remove()
      $('#stickyBlock').append("<h2>Вертолетная площадка</h2>");
    })
  }
  else {
    $('#stickyBlock h2').remove()
    $('#stickyBlock').append("<h2>H</h2>");
    block.style['width'] = 50 + 'px';}
  })
