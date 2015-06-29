$ ->
  $('#address-tip').tipTip({
    activation: 'hover',
    content: "If your address can't be found, please manually enter it below."
  })

jQuery ->
        $('.best_in_place').best_in_place().css('cursor' ,'pointer')
        $('.field_value').best_in_place().css('cursor' ,'pointer')
