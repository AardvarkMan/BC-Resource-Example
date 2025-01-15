pageextension 50000 ARD_CustomerList extends "Customer List"
{
    actions
    {
        addafter(ApplyTemplate)
        {
            action(ard_ProcessCustomerJSON)
            {
                ApplicationArea = All;
                Caption = 'Process Customer JSON';
                Image = Customer;
                ToolTip = 'Process Customer JSON';
                trigger OnAction()
                var
                    CustomerProcessor: CodeUnit ARD_ProcessCustomerJSON;
                begin
                    CustomerProcessor.ProcessCustomerJSON();
                end;
            }
        }
    }
}
