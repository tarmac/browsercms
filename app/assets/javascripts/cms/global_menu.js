// @deprecated Used to handle updating the toolbar on sitemap.
var GlobalMenu = function() {

};

// Setting the 'New Page' path should update the global menu
GlobalMenu.prototype.addPagePath = function(path) {
  $('#new-content-button').attr('href', path);
  $('.add-page-button').attr('href', path);
};

GlobalMenu.prototype.addSectionPath = function(path) {
  $('.add-link-button').attr('href', path);
};

GlobalMenu.prototype.addLinkPath = function(path) {
  $('.add-section-button').attr('href', path);
};

var globalMenu = new GlobalMenu();