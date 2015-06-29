//= require jquery
//= require jquery_ujs
//= require gritter
//= require highcharts
//= require_tree .
//= require_self

$(document).ready(function(){
  
  $("#address_search").geocomplete({
    details: "form",
    detailsAttribute: "data-geo",
    componentRestrictions: {country: ['ZA']}
  });

});

  // Loading indicator on continue button
 //  $('#next,#prev,#spinner_submit,.unstyled_spinner_submit').click(function(){
//     $(".submit").hide();
//     $('input').removeAttr('disabled');
//     $('#loading_step').show();
//   });
//
//   // Alert when inserting manual account installment
//   $("fieldset#accounts .installment").live("click", function() {
//     confirm("You are about to add/edit an account installment manually, this ordinarily should be classified via your bank statement when paid. Please consider this to avoid double counting this amount.");
//     return false;
//   });
//
//   // Cycle through accounts, loans, credit cards when clicking continue
//   $('.debt_next').click(function() {
//     if ($('#account_tab').hasClass('current')) {
//       $('#cc_tab').click();
//       $('#loading_step').hide();
//       $(".submit").show();
//       return false;
//     }
//     else if ($('#cc_tab').hasClass('current')) {
//       $('#loan_tab').click();
//       $('#loading_step').hide();
//       $(".submit").show();
//       return false;
//     }
//   });
//
//   // Tabbed functionality
//   $('.tab').eq(0).siblings('.tab').hide();
//   $('#tabs li').click(function(){
//     $(this).addClass('current').siblings().removeClass('current');
//     link = $("a",this)
//
//     $(".financial-roadmap").hide();
//     $("#finmap").hide();
//     $("#debtrelief").hide();
//
//     category = link.attr("data-category");
//     if(category == "Debt Relief Solutions") {
//       $(".financial-roadmap").show();
//       $("#debtrelief").show();
//     }
//     if(category == "Life Events") {
//       $(".financial-roadmap").show();
//       $("#finmap").show();
//     }
//
//     $('.tab').eq($(this).find('a').attr('rel')).fadeIn().siblings('.tab').hide();
//     return false;
//   });
//
//   $("#tabs li:first").click();
//
//   $(".view-details").live("click", function(){
//     $(this).next('table.detail').toggle();
//     if($(this).text() == '+ View Details'){
//       $(this).text('- Hide Details');
//     }
//     else{
//       $(this).text('+ View Details');
//     }
//     return false;
//   });
//
//   // Lightox on 'boxy' rel tags
//   $('a[rel=boxy]').fancybox({'showNavArrows' : false});
//   $('a[rel=calc_box]').fancybox({'showNavArrows' : false, 'hideOnContentClick': false});
//
//
//   $('input.description').change(function() {
//     $(this).attr('title', $(this).val());
//     $(this).tipTip({maxWidth: "auto", defaultPosition: "top", delay: 0});
//   });
//
//   // Messages
//   $('.message').hide().append('<span class="close" title="Dismiss"></span>').fadeIn('slow');
//   $('.message .close').hover(
//     function() { $(this).addClass('hover'); },
//     function() { $(this).removeClass('hover'); }
//   );
//
//   $('.message .close').click(function() {
//     $(this).parent().fadeOut('slow', function() { $(this).remove(); });
//     return false;
//   });
//
//   $(".recaptcha_error").remove();
//
// });
//
// function remove_fields(link) {
//   if ($(link).closest('tr').hasClass('split')) {
//     var split_amount = $(link).closest('tr').find('input.amount').val();
//     var original_amount = $(link).closest('tr').prevAll("tr.original:first").find('input.amount').val();
//     $(link).closest('tr').prevAll("tr.original:first").find('input.amount').val(parseFloat(split_amount) + parseFloat(original_amount));
//   }
//   $(link).prev("input[type=hidden]").val("1");
//   $(link).closest(".fields").fadeOut();
//   changed = changed+1;
// }
//
// function add_fields(link, association, content, place) {
//   var new_id = new Date().getTime();
//   var regexp = new RegExp("new_" + association, "g")
//
//   if(place == "above"){
//     $(link).parent().before(content.replace(regexp, new_id));
//     $(link).parent().parent().children(".fields:last").hide().fadeIn();
//   }else{
//     $(link).parent().after(content.replace(regexp, new_id));
//     //$(link).parent().next(".fields").hide().show('medium');
//   }
//   //$(link).parent().before(content.replace(regexp, new_id));
//
//   var target = $(link).parent().prev(".fields").find(".datepicker");
//   target.datepicker();
//   var select_target = $(link).parent().prev("fieldset").find(".styled");
//   $(select_target).customStyle();
//   changed = changed+1;
//
//   return false;
// }
//
//
//
// function split_fields(link, association, content, place) {
//   var new_id = new Date().getTime();
//   var regexp = new RegExp("new_" + association, "g")
//   if(place == "above"){
//     $(link).parents(".fields").before(content.replace(regexp, new_id));
//   }else{
//     $(link).parents(".fields").after(content.replace(regexp, new_id));
//   }
//
//   var original = $(link).parents(".fields");
//   var target = $(link).parents(".fields").next(".fields");
//
//   target.find(".date").val(original.find(".date").val());
//
//   target.find(".datepicker").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
//
//   target.find(".description").val(original.find(".description").val());
//   target.find(".description").attr(original.find(".description").val());
//
//   target.find(".amount").val(original.find(".amount").val());
//
//   target.find(".category").val(original.find(".category").val());
//
//   target.find(".supplier").val(original.find(".supplier").val());
//
//   changed = changed+1;
//
// }
//
// // Random functions
//
// function capitaliseFirstLetter(string)
// {
//     return string.charAt(0).toUpperCase() + string.slice(1);
// }
