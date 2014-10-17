$(document).on("click", ".magis-setup .next", function(){
  var $form = $(this).closest(".item")
  var name=$form.children().data("name")

  params = Object();
  params[name] = Object()
  $form.find("input").each( function(index, authInput){
    params[name][$(authInput).attr("name")] = $(authInput).val();
  })

  $auth = $.post("/setup/"+name, params)
  $auth.then(function(response){
    $(".magis-setup").carousel('next')
  })
});

