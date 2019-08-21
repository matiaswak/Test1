$(document).keyup(function(event) {
    if ((event.keyCode == 13)) {
        $("#chat_send").click();
    }
});

var oldContent = null;
window.setInterval(function() {
  var elem = document.getElementById('chat_result');
  if (oldContent != elem.innerHTML){
    scrollToBottom();
  }
  oldContent = elem.innerHTML;  
}, 300);

function scrollToBottom(){
  var elem = document.getElementById('chat_result');
  elem.scrollTop = elem.scrollHeight;
}
