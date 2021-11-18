const AWS = require('aws-sdk');
const SES = new AWS.SES();

const successResponse = {
    "isBase64Encoded": false,
    "headers": { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
    "statusCode": 200,
    "body": "{\"result\": \"Success.\"}"
};

const errorResponse = {
    "isBase64Encoded": false,
    "headers": { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
    "statusCode": 200,
    "body": "{\"result\": \"Failed.\"}"
};

exports.handler = async function(event) {
    // console.log(event);
    const body = JSON.parse(event.body);
    // const body = event.body;
    console.log(body);

    const senderFirstName = body.senderFirstName;
    const senderLastName = body.senderLastName;
    const recipientEmail = body.recipientEmail;

    const destination = {
        ToAddresses: [
            recipientEmail
        ]
    };
    const emailBodyData = `
    <p>
    ${senderFirstName} ${senderLastName} has invited you to join <a href="https://pagenow.io">PageNow</a> to engage in 
    natural and contextual social interaction.
    You can view ${senderFirstName}'s real-time activities and share yours as well.
    </p>
    
    <p>
    Below are links to access PageNow.
    <ul>
        <li>Official Website: <a href="https://pagenow.io">https://www.pagenow.io</a></li>
        <li>Chrome Store Downlaod: <a href="https://chrome.google.com/webstore/detail/pagenow/lplobiaakhgkjcldopgkbcibeilddbmc">https://chrome.google.com/webstore/detail/pagenow/lplobiaakhgkjcldopgkbcibeilddbmc</a></li>
        <li>Source Code: <a href="https://www.github.com/PageNow">https://www.github.com/PageNow</a></li>
    </ul>
    
    <p>
    Best,<br/>
    PageNow Team
    </p>`;
    const message = {
        Body: {
            Html: {
                Data: emailBodyData,
                Charset: 'UTF-8'
            }
        },
        Subject: {
            Data: `${senderFirstName} ${senderLastName} invites you to PageNow`,
            Charset: 'UTF-8'
        }
    };
    
    const emailParams = {
        Destination: destination,
        Message: message,
        Source: 'PageNow <support@pagenow.io>'
    };
    console.log(emailParams);
    
    try {
        await SES.sendEmail(emailParams).promise();
    } catch (err) {
        console.error(err, err.stack);
        return errorResponse;
    }
    return successResponse;
};
