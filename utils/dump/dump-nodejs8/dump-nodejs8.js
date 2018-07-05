const OSS = require('ali-oss');
const fs = require('fs');
const childProcess = require('child_process');

async function uploadFile(path, dest, context) {
    const oss = OSS.Wrapper({
        accessKeyId: context.credentials.accessKeyId,
        accessKeySecret: context.credentials.accessKeySecret,
        stsToken: context.credentials.securityToken,       
        bucket: process.env['BucketName'],
        region: process.env['OSSRegion']
    });

    const stream = fs.createReadStream(path);
    const result = await oss.putStream(dest, stream);

    return result;
}

exports.handler = function(event, context, cb) {
    (async () => {
        const filename = 'nodejs8.tgz';
        const source = `/tmp/${filename}`;
        const dest = `/tmp/${filename}`;

        const cmd = `tar -cpzf /tmp/${filename} --numeric-owner --ignore-failed-read /var/fc/runtime`;

        const child = childProcess.spawn('sh', ['-c', event.cmd || cmd]);
        child.stdout.setEncoding('utf8')
        child.stderr.setEncoding('utf8')
        child.stdout.on('data', console.log.bind(console))
        child.stderr.on('data', console.error.bind(console))
        child.on('error', cb)

        child.on('close', async () => {
            if (event.cmd) return cb();
            
            console.log('Zipping done! Uploading...')

            const result = await uploadFile(source, dest, context);

            console.log(result);

            cb(null, result);
        });
    })();
};

