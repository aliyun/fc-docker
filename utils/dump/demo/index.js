exports.handler = function (event, context, callback) {
    console.log("just log");
    callback(null, 'hello world');
};