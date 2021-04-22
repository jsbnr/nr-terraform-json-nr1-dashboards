#!/usr/bin/env node
const $http = require("request");  

  /*
  * genericJSONServiceCall()
  * Generic service call helper for commonly repeated tasks - needs a bit of work!!
  *
  * @param {number} responseCodes  - The response code (or array of codes) expected from the api call (e.g. 200 or [200,201])
  * @param {Object} options       - The standard http request options object
  * @param {function} success     - Call back function to run on successfule request
  */
  const  genericJSONServiceCall = function(responseCodes,options,success) {
    options.gzip=true //support gzip
    let possibleResponseCodes=responseCodes
    if(typeof(responseCodes) == 'number') { //convert to array if not supplied as array
      possibleResponseCodes=[responseCodes]
    }
    return new Promise((resolve, reject) => {
        $http(options, function callback(error, response, body) {
          if(error) {
            console.log('Connection error',error,options);
          } else {
            if(!possibleResponseCodes.includes(response.statusCode)) {
              let errmsg=`Expected one of [${possibleResponseCodes}] response code but got ${response.statusCode} in call to ${options.url} \nResponse body:\n${body}`
              reject(errmsg)
            } else {
              try {
                let bodyObj=JSON.parse(body)
                resolve(success(bodyObj,response,error))
              } catch (e) {
                console.log('Failed assertion',e);
              }
            }
  
          }
        });
    })
  }



  const updateDashboard = function(GUID,data) {


    let buff = Buffer.from(data, 'base64');     
    let decoded = buff.toString('utf-8');
    jsonDecoded=JSON.parse(decoded)

    let dashData =null
    //raw object as exported from UI
    if(jsonDecoded.name ) {
      dashData=jsonDecoded
    }
    //raw object as exported from graphQL
    if(!dashData && jsonDecoded.data && jsonDecoded.data.actor && jsonDecoded.data.actor.entity) {
      dashData=jsonDecoded.data.actor.entity
    }
  
     let variables = { dashboard: dashData}
     
      let options = {
        url: `https://api.newrelic.com/graphql`,
        method: 'POST',
        headers : {
            "X-Api-Key":process.env.NEW_RELIC_API_KEY,
            "Content-Type": "application/json"

        },
        body: JSON.stringify({
          query: `mutation update($dashboard: Input!) {dashboardUpdate(dashboard: $dashboard, guid: "${GUID}") { entityResult { guid name } errors { description }}}`,
          variables: variables
        })

      }

      return genericJSONServiceCall(200,options,async (body,response,error) => {
  
        if(body){
            console.log(JSON.stringify(body))
        } else { 
          console.log("Unexpected data returned from api");
          process.exit(1)
        }
      })
  }  

  async function run() {

    let myArgs = process.argv.slice(2);
    try { 
      await updateDashboard( myArgs[0], myArgs[1])
    } catch(e) {
      console.log(e)
      process.exit(1)
    }
}

run()