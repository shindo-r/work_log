unique = (array) ->
  storage = {}
  uniqueArray = []
  i = undefined
  value = undefined
  i = 0
  while i < array.length
    value = array[i]
    unless value of storage
      storage[value] = true
      uniqueArray.push value
    i++
  uniqueArray

clear = (form)->
  form.find('input').each -> 
    $(this).val('')
  $(form.find('input')[0]).focus()

press_enter_key = (event)->
  event.keyCode == 13
