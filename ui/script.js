window.addEventListener("message", function(event) { // Escuchar los mensajes del servidor
    if (event.data.type == "actualizarContadores") { // Si el mensaje es para actualizar los contadores
      var contador1 = document.getElementById("contador1");
      var contador2 = document.getElementById("contador2");
      
      contador1.innerHTML =  "<i class='fa fa-user'></i> " + event.data.numJugadores;
      contador2.innerHTML =  "<i class='fa fa-bullseye'></i> " + event.data.numBajas;
    }
});

window.addEventListener("message", function(event) { // Escuchar los mensajes del servidor
  if (event.data.type == "ShowBox") { // Si el mensaje es para actualizar los contadores
    var Box = document.getElementById("caja");
    Box.style.display = "flex";
  }
});

window.addEventListener("message", function(event) { // Escuchar los mensajes del servidor
  if (event.data.type == "HideBox") { // Si el mensaje es para actualizar los contadores
    var box = document.getElementById("caja");
    box.style.display = "none";
  }
});
