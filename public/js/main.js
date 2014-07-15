$(".full img").on("click", function() {
  $(this).toggleClass("zoom");
});



$(function (){

Socialite.setup({
  facebook: {
    lang:  'en_US',
    appId: '806230736060494'
  }
});
Socialite.load();

});