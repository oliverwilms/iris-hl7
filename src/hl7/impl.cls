/// REST API for HL7 Documents interface<br/>
/// Business logic class defined by OpenAPI in hl7.spec<br/>
/// Created Feb 21, 2024 00:21:15
Class hl7.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// Do a simple test
ClassMethod test() As %Stream.Object
{
    //(Place business logic here)
    Do ..%SetStatusCode(200)
    //Do ..%SetHeader(<name>,<value>)
    Quit {} ; response may be a string, stream or dynamic object
}

/// Returns all the documents in the database
ClassMethod getDocuments() As %Stream.Object
{
    //(Place business logic here)
    //Do ..%SetStatusCode(<HTTP_status_code>)
    //Do ..%SetHeader(<name>,<value>)
    //Quit (Place response here) ; response may be a string, stream or dynamic object
}

/// Retrieve the Document object with id = {id}<br/>
/// The method arguments hold values for:<br/>
///     id<br/>
ClassMethod getDocument(id As %String) As %Stream.Object
{
    //(Place business logic here)
    //Do ..%SetStatusCode(<HTTP_status_code>)
    //Do ..%SetHeader(<name>,<value>)
    //Quit (Place response here) ; response may be a string, stream or dynamic object
}

/// Update the Document object with id = {id}<br/>
/// The method arguments hold values for:<br/>
///     id<br/>
ClassMethod putDocument(id As %String) As %Stream.Object
{
    //(Place business logic here)
    //Do ..%SetStatusCode(<HTTP_status_code>)
    //Do ..%SetHeader(<name>,<value>)
    //Quit (Place response here) ; response may be a string, stream or dynamic object
}

/// Delete the Document object with id = {id}<br/>
/// The method arguments hold values for:<br/>
///     id<br/>
ClassMethod deleteDocument(id As %String) As %Stream.Object
{
    //(Place business logic here)
    //Do ..%SetStatusCode(<HTTP_status_code>)
    //Do ..%SetHeader(<name>,<value>)
    //Quit (Place response here) ; response may be a string, stream or dynamic object
}

/// Creates a new Document object
ClassMethod postDocument() As %Stream.Object
{
    IF '$isobject(%request.Content) {
        SET tContent = %request.Content
    } ELSE {
        SET tContent = ""
        WHILE '%request.Content.AtEnd {
            SET tContent = tContent_%request.Content.Read()
        }
    }
    //(Place business logic here)
    Set tSC = ##class(HS.Local.VA.eSCM.HL7.Util).StoreStream(.tContent)
    If $$$ISOK(tSC) {
        Do ..%SetStatusCode(200)
    } Else {
        Do ..%SetStatusCode(500)
    }
    //Do ..%SetHeader(<name>,<value>)
    Quit tContent ; response may be a string, stream or dynamic object
}

}
