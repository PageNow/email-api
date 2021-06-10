const AWS = require('aws-sdk');

// Set the region 
AWS.config.update({region: 'us-east-1'});

const ddb = new AWS.DynamoDB({apiVersion: '2012-08-10'});

exports.handler = async (event) => {
    try {
        console.log(JSON.stringify(event, null, 2));
	    const params = {
		    TableName:'pagenow-email-subscription',
		    Item: {
			    email : {S: JSON.parse(event.body).email}
		    }
	    };
        let msg;
	    try{
		    const data = await ddb.putItem(params).promise();
		    console.log("Item entered successfully:", data);
		    msg = 'Item entered successfully';
	    } catch(err){
		    console.log("Error: ", err);
		    msg = err;
	    }
	    var response = {
		    'statusCode': 200,
            'headers': { 'Content-Type': 'application/json' },
		    'body': JSON.stringify({
			    message: msg
		    })
	    };
    } catch (err) {
	    console.log(err);
	    return err;
    }
	
    return response;
};