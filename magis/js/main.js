Router = Object();
Router.addRoute = function(name, callBack){
  return Finch.route(name, callBack);
}

$.capsuleForm = (function(formName){
  
  $(document).on("click", "[data-name='"+formName+"'].form .submit", function(){
    submitData = Object();
    $form = $(this).parents(".form");
    $form.find("input").each(function(i, input){
      submitData[$(this).attr("name")] = $(this).val()
    })
    $.post("/api/collections/" + formName, {data: submitData})
  })

})

function Page(target, collection){
  $.get("/pages/" + collection, function(data){
    $("body").append(data);
    Router.addRoute("/"+collection, function() {
      View.render(target, collection, "collections/"+collection);
    });
  })
}

var View  = Object();
View.cog = function(element, template, data){
  return new Ractive({
    el: element,
    template: template,
    data: data
  });
}

View.render = function(target, templateName, url){
  var defer = $.Deferred()
  collection =  App.collections[templateName] || (App.collections[templateName] = new Collection(templateName))
  collection.find().then(function(data){
    collection.data = data;
    customData = Object();
    customData[templateName] = collection.data;
    View.cog(target, $("[name='"+templateName+"']").html(), customData);
    defer.resolve()
  });
  return defer;
}

App = Object();
App.collections = Object();
App.initialize = function(){
  Finch.listen();
}

App.fayeClient = new Faye.Client("/faye");

currentUser = Object();

Collection = function(name){
  this.name = name;
  
  localCollection = this;
  
  App.fayeClient.subscribe('/'+this.name, function(data) {
    localCollection.data.push(JSON.parse(data.json));
  });
  
  this.create = function(params){
    return $.post("/api/collections/"+name, params);
  }
  
  this.find = function(params){
    return $.get("/api/collections/"+name, params);
  }

  this.update = function(id, params){
    name = this.name
    request = $.ajax({
      url: "/api/collections/"+name+"/"+id,
      type: "PUT",
      data: params,
      dataType: "json"
    });
    
    return request;
  }
  
  this.remove = function(id){
    request = $.ajax({
      url: "/api/collections/"+name+"/"+id,
      type: "DELETE",
      dataType: "json"
    });
    
    return request;
  }
  
  this.findOne = function(params){
    var defer = $.Deferred()
    
    $.get("/api/collections/"+name, params).then(function(data){
      data = data[0];
      defer.resolve(data);
    });
    
    defer
  }
}