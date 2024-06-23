$(document).on('ajax:success', 'form', function(event) {
  var [data, status, xhr] = event.detail;
  $('#countries_list').html(data);
});
