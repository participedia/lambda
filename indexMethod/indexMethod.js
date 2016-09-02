var AWS = require('aws-sdk');
var path = require('path');
var dyno = require('dyno');
var elasticsearch = require('elasticsearch')
var async = require('async')

var esDomain = {
    region: 'us-east-1',
    endpoint: 'search-pp-stage-37xn6cdq7tj7ehv5rjrgxgrjhq.us-east-1.es.amazonaws.com',
    index: 'pp',
    doctype: 'method'
};

var client = new elasticsearch.Client({
  host: esDomain.endpoint
});


var endpoint = new AWS.Endpoint(esDomain.endpoint);
/*
 * The AWS credentials are picked up from the environment.
 * They belong to the IAM role assigned to the Lambda function.
 * Since the ES requests are signed using these credentials,
 * make sure to apply a policy that allows ES domain operations
 * to the role.
 */
var creds = new AWS.EnvironmentCredentials('AWS');

/* Lambda "main": Execution begins here */
exports.handler = function(event, context, callback) {
    async.forEach(event.Records, function(record, cb) {
        var NewImage = record.dynamodb.NewImage
        if (NewImage) {
            var data = dyno.deserialize(JSON.stringify(NewImage))
            client.index({
                index: esDomain.index,
                type: esDomain.doctype,
                id: data.id,
                body: data
            }, function(err) {
                if (err) {
                    console.log("ERROR indexing", esDomain.doctype + ": " + data.id);
                    callback(err)
                } else {
                    console.log("SUCCESS indexing", esDomain.doctype + ": " +  data.id);
                }
                cb()
            })
        } else {
            var OldImage = record.dynamodb.OldImage
            var data = dyno.deserialize(JSON.stringify(OldImage))
            client.delete({
                index: esDomain.index,
                type: esDomain.doctype,
                id: data.id
            }, function(err) {
                if (err) {
                    console.log("ERROR deleting", esDomain.doctype + ": " + data.id);
                    callback(err)
                } else {
                    console.log("SUCCESS deleting", esDomain.doctype + ": " +  data.id);
                }
                cb()
            })
        }
    }, function () {
        callback()
    })
}


