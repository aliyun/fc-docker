var OSS = require('ali-oss');
var fs = require('fs');
var childProcess = require('child_process');

function uploadFile(path, dest, context, cb) {
    console.log('bucket name: ', process.env['Bucket']);
    const oss = OSS.Wrapper({
        accessKeyId: context.credentials.accessKeyId,
        accessKeySecret: context.credentials.accessKeySecret,
        stsToken: context.credentials.securityToken,
        bucket: process.env['Bucket'],
        region: process.env['OSSRegion']
    });

    const stream = fs.createReadStream(path);

    oss.putStream(dest, stream).then(function (result) {
        cb(null, result);
    }).catch(function(err) {
        cb(err);
    });
}

exports.handler = function(event, context, cb) {
    const filename = process.env['FileName'];
    const source = `/tmp/${filename}`;
    const dest = `${filename}`;

    const cmd = `tar -cpzPf /tmp/${filename} --numeric-owner --ignore-failed-read /var/fc/runtime`;

    const child = childProcess.spawn('sh', ['-c', event.cmd || cmd]);
    child.stdout.setEncoding('utf8');
    child.stderr.setEncoding('utf8');
    child.stdout.on('data', console.log.bind(console));
    child.stderr.on('data', console.error.bind(console));
    child.on('error', cb);

    child.on('close', () => {
        if (event.cmd) return cb();
        console.log('Zipping done! Uploading...');
        uploadFile(source, dest, context, cb);
    });
};
