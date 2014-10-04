currentUser.friends = function(callback){
  return $.get("/friends", callback);
}

currentUser.logout = function(){
  return $.ajax({
    type: "DELETE",
    url: "/logout"
  })
}