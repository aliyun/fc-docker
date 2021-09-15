import os
import sys
import subprocess
import oss2


def handler(event, context):
    package_dir = os.environ['PackageDir']
    filename = os.environ['FileName']
    source = '/tmp/{}'.format(filename)
    dest = filename

    cmd = 'tar -cpzf {} --numeric-owner --ignore-failed-read {}'.format(
        source, package_dir)

    subprocess.call(['sh', '-c', cmd])

    print('Zipping done! Uploading...')

    creds = context.credentials
    auth = oss2.StsAuth(creds.access_key_id,
                        creds.access_key_secret,
                        creds.security_token)

    endpoint = os.environ['OSSEndpoint']
    bucket = os.environ['Bucket']

    print('endpoint: ' + endpoint)
    print('bucket: ' + bucket)

    bucket = oss2.Bucket(auth, endpoint, bucket)

    bucket.put_object_from_file(dest, source)

    return 'Zipping done and uploading done!'
