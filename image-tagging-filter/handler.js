const rekognitionService = require("./services/rekognitionService");
const sqsService = require("./services/sqsService");

module.exports.tag = async (event) => {
    const s3Info = JSON.parse(event.Records[0].Sns.Message);
    const bucket = s3Info.Records[0].s3.bucket.name;
    const key = s3Info.Records[0].s3.object.key;
    const labels = await rekognitionService.data(bucket, key);
    
    const item = {};
    item.key = key;
    item.labels = labels;
    item.eventType = 'TAG_EVENT';

    await sqsService.putMessage(item);

    return {event};
};
