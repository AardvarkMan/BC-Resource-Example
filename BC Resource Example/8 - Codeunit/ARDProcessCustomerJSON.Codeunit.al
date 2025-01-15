codeunit 50000 ARD_ProcessCustomerJSON
{
    /// <summary>
    /// Processes the customer JSON data by retrieving the 'companies' JSON array from the resource file
    /// and iterating through each company JSON token to process it.
    /// </summary>
    /// <remarks>
    /// This procedure uses the NavApp.GetResourceasJson method to load the JSON data from the resource file
    /// named 'data/Companies.JSON'. It then extracts the 'companies' JSON array and processes each company
    /// JSON token by calling the ProcessCompany method.
    /// </remarks>
    /// <seealso cref="NavApp.GetResourceasJson"/>
    /// <seealso cref="ProcessCompany"/>
    internal procedure ProcessCustomerJSON()
    var
        CompaniesJSON: JsonObject;
        CompaniesAryJT: JsonToken;
        CompanyJT: JsonToken;
    begin
        CompaniesJSON := NavApp.GetResourceasJson('data/Companies.JSON');

        if CompaniesJSON.Get('companies', CompaniesAryJT) then
            foreach CompanyJT in CompaniesAryJT.AsArray() do
                ProcessCompany(CompanyJT);

    end;

    /// <summary>
    /// Processes a single company JSON token and inserts it into the Customer table if it does not already exist.
    /// </summary>
    /// <param name="CompanyJT">The JSON token representing a company.</param>
    local procedure ProcessCompany(CompanyJT: JsonToken)
    var
        CustomerRec: Record Customer;
        JObject: JsonObject;
        Name: Text;
        tmpText: Text;
    begin
        // Convert the JSON token to a JSON object
        JObject := CompanyJT.AsObject();
        
        // Retrieve the 'name' field from the JSON object
        if GetText(JObject, 'name', Name) then begin
            // Set a filter on the Customer record to check if the customer already exists
            CustomerRec.SetFilter(Name, '%1', Name);
            
            // If the customer does not exist, initialize and insert a new record
            if CustomerRec.IsEmpty() then begin
                CustomerRec.Init();
                CustomerRec.Name := CopyStr(Name, 1, 100);

                // Retrieve and set the 'city' field if it exists
                if GetText(JObject, 'city', tmpText) then
                    CustomerRec.City := CopyStr(tmpText, 1, 30);

                // Retrieve and set the 'state' field if it exists
                if GetText(JObject, 'state', tmpText) then
                    CustomerRec."Country/Region Code" := CopyStr(tmpText, 1, 10);

                // Insert the new customer record
                CustomerRec.Insert(true);
            end;
        end;
    end;

    [TryFunction]
    /// <summary>
    /// Retrieves the text value associated with a specified key from a JSON object.
    /// </summary>
    /// <param name="JsonObject">The JSON object containing the key-value pair.</param>
    /// <param name="ObjKey">The key whose associated value is to be retrieved.</param>
    /// <param name="Val">The variable to store the retrieved text value.</param>
    local procedure GetText(JsonObject: JsonObject; ObjKey: Text; var Val: Text)
    var
        Token: JsonToken;
        Value: JsonValue;
    begin
        // Retrieve the JSON token associated with the specified key
        JsonObject.Get(ObjKey, Token);
        
        // Convert the JSON token to a JSON value
        Value := Token.AsValue();
        
        // Convert the JSON value to text and store it in the output variable
        Val := Value.AsText();
    end;
}
