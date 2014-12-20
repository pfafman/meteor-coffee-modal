Package.describe({
    summary: "Display a modal via bootstrap written in coffeescript",
  version: "0.4.0",
  git: "https://github.com/pfafman/meteor-coffee-modal.git"
});

Package.on_use(function(api, where) {
  api.versionsFrom("METEOR@1.0");

    api.use([
        'minimongo',
        'mongo-livedata',
        'templating',
        'session',
        'jquery',
        'handlebars',
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
    api.use("pfafman:coffee-modal", 'client');
    api.use(['tinytest', 'test-helpers', 'coffeescript'], 'client');
    api.add_files('modal_tests.coffee', 'client');
});
