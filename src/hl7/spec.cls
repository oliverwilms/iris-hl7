Class hl7.spec Extends %REST.Spec [ ProcedureBlock ]
{

XData OpenAPI [ MimeType = application/json ]
{
{
  "info":{
    "title":"HL7",
    "description":"REST API for HL7 Documents interface",
    "version":"1.0"
  },
  "basePath":"/hl7/api",
  "paths":{
    "/test":{
      "get":{
        "summary":"Do a simple test",
        "operationId":"test",
        "responses":{
          "200":{
            "description":"Test if the system is working"
          },
          "default":{
            "description":"Returns a document object"
          }
        }
      }
    },
    "/document":{
      "get":{
        "summary":"Returns all the documents in the database",
        "operationId":"getDocuments",
        "responses":{
          "200":{
            "description":"The list of document objects in the database"
          },
          "default":{
            "description":"(Unexpected Error)"
          }
        }
      }
    },
    "/document/{id}":{
      "get":{
        "summary":"Retrieve the Document object with id = {id}",
        "operationId":"getDocument",
        "parameters":[
          {
            "name":"id",
            "in":"path",
            "required":true,
            "type":"string"
          }
        ],
        "responses":{
          "200":{
            "description":"(Expected Result)"
          },
          "default":{
            "description":"(Unexpected Error)"
          }
        }
      },
      "put":{
        "summary":"Update the Document object with id = {id}",
        "operationId":"putDocument",
        "parameters":[
          {
            "name":"id",
            "in":"path",
            "required":true,
            "type":"string"
          }
        ],
        "responses":{
          "200":{
            "description":"(Expected Result)"
          },
          "default":{
            "description":"(Unexpected Error)"
          }
        }
      },
      "delete":{
        "summary":"Delete the Document object with id = {id}",
        "operationId":"deleteDocument",
        "parameters":[
          {
            "name":"id",
            "in":"path",
            "required":true,
            "type":"string"
          }
        ],
        "responses":{
          "200":{
            "description":"(Expected Result)"
          },
          "default":{
            "description":"(Unexpected Error)"
          }
        }
      }
    },
    "/document/new":{
      "post":{
        "summary":"Creates a new Document object",
        "operationId":"postDocument",
        "responses":{
          "200":{
            "description":"(Expected Result)"
          },
          "default":{
            "description":"(Unexpected Error)"
          }
        }
      }
    }
  },
  "swagger":"2.0"
}
}

}
