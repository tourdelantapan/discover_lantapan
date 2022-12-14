const Handlebars = require('handlebars');

const helper = function() {
    Handlebars.registerHelper('equal', function(lvalue, rvalue, options) {
        if (arguments.length < 3)
            throw new Error("Handlebars Helper equal needs 2 parameters");
        if( lvalue==rvalue ) {
            return options.inverse(this);
        } else {
            return options.fn(this);
        }
    });
}

module.exports = helper;