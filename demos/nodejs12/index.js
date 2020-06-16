var counter = 0;
exports.initializer = function(context, callback) {
    counter += 1;
    callback(null, "");
};

exports.handler = function(event, context, callback) {
    // var eventObj = JSON.parse(event.toString());
    console.log("event: " + event);
    console.log('context: ', JSON.stringify(context));

    const object = { x: 42, y: 50 };
    const entries = Object.entries(object);
    console.log(Object.fromEntries(entries)); // New grammar for nodejs 12

    counter += 2;
    callback(null, String(counter));
};