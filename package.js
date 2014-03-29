Package.describe({
    summary: "Display a modal via bootstrap written in coffeescript"
});

Package.on_use(function(api, where) {
  
    api.use([
        'minimongo', 
        'mongo-livedata', 
        'templating',
        'session',
        'jquery',
        'handlebars',
        'iron-router', 
        'coffeescript',
        'less'
    ], 'client');
  
    api.add_files([
        'lib/modal.less',
        'lib/modal.html',
        'lib/modal.coffee'
    ], 'client');

    if (api.export) {
        api.export('CoffeeModal')
    }

});


Package.on_test(function(api) {
    api.use('coffee-modal', 'client'); 
    api.use(['tinytest', 'test-helpers', 'coffeescript'], 'client');
    api.add_files('modal_tests.coffee', 'client'); 
});