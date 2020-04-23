//= require active_admin/base

$(document).on('ready page:load turbolinks:load', function () {
  $('a.modalOrder').click(function(e){
    id = this.id;
    e.stopPropagation();
    e.preventDefault();

    ActiveAdmin.modal_dialog("Selecciona la tarifa", {tarifa: ["Colegio","Curso","Curso Virtual","ICFES","Univ","ICFES Virtual"], "sesiones fijas": "checkbox","fecha final": "datepicker"}, function(inputs) {
      $.get("/admin/students/"+id+"/neworden",inputs,function(data){ document.write(data); document.close();});
    })
  })

})






