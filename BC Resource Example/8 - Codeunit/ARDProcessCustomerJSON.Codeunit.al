codeunit 50000 ARD_ProcessCustomerJSON
{
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

    local procedure ProcessCompany(CompanyJT: JsonToken)
    var
        CustomerRec: Record Customer;
        JObject: JsonObject;
        Name: Text;
        tmpText: Text;
    begin
        JObject := CompanyJT.AsObject();
        if GetText(JObject, 'name', Name) then begin
            CustomerRec.SetFilter(Name, '%1', Name);
            if CustomerRec.IsEmpty() then begin
                CustomerRec.Init();
                CustomerRec.Name := CopyStr(Name, 1, 100);

                if GetText(JObject, 'city', tmpText) then
                    CustomerRec.City := CopyStr(tmpText, 1, 30);

                if GetText(JObject, 'state', tmpText) then
                    CustomerRec."Country/Region Code" := CopyStr(tmpText, 1, 10);

                CustomerRec.Insert(true);
            end;
        end;
    end;

    [TryFunction]
    local procedure GetText(JsonObject: JsonObject; ObjKey: Text; var Val: Text)
    var
        Token: JsonToken;
        Value: JsonValue;
    begin
        JsonObject.Get(ObjKey, Token);
        Value := Token.AsValue();
        Val := Value.AsText();
    end;
}
