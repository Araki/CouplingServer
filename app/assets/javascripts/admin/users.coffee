jQuery ->
  $('a.search').click ()->
    keyword = $('#keyword').val()
    if keyword isnt ''
      location.href = "/admin/users?search=id&field=" + $(this).data('type') + "&keyword=" + encodeURI(keyword)
    return false
  return