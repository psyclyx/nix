#!/usr/bin/env node

const fs = require('fs');
const https = require('https');

if (process.argv.length !== 4) {
    console.error(`Usage: '${process.argv[0]} <input_image> <output_image>`);
    process.exit(1);
}

const [inputFile, outputFile] = process.argv.slice(2);

if (!fs.existsSync(inputFile)) {
    console.error(`Error: File '${inputFile}' does not exist`);
    process.exit(1);
}

const imageBuffer = fs.readFileSync(inputFile);
const base64Data = imageBuffer.toString('base64');
const dataUri = `data:application/octet-stream;base64,${base64Data}`;

const payload = JSON.stringify({
    input: {
        sync: true,
        image: dataUri,
        preserve_alpha: true,
        desired_increase: 4,
        content_moderation: false
    }
});

const options = {
    hostname: 'api.replicate.com',
    port: 443,
    path: '/v1/models/bria/increase-resolution/predictions',
    method: 'POST',
    headers: {
        'Authorization': `Bearer ${process.env.REPLICATE_API_TOKEN}`,
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(payload),
        'Prefer': 'wait'
    }
};

const req = https.request(options, (res) => {
    let data = '';
    res.on('data', (chunk) => data += chunk);
    res.on('end', () => {
        const response = JSON.parse(data);
        const imageUri = response.output;
        const base64Match = imageUri.match(/^data:.*?;base64,(.+)$/);
        if (base64Match) {
            const imageData = Buffer.from(base64Match[1], 'base64');
            fs.writeFileSync(outputFile, imageData);
        }
    });
});

req.on('error', (error) => {
    console.error('Request error:', error.message);
    process.exit(1);
});

req.write(payload);
req.end();
