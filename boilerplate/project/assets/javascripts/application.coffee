Router.collection(".main", "documentation")



$.capsuleForm(".documentation")
$(->
  $.get("/pages/authentication", (data)->
    $("body").append(data)

    View.cog(".main", $("[name='authentication']").html(), Object())
  )
)

App.initialize()