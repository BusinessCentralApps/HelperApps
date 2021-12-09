page 50000 AzureAdAppSetup
{
    PageType = API;
    Caption = 'AzureAdAppSetup';
    APIPublisher = 'Microsoft';
    APIGroup = 'Setup';
    APIVersion = 'beta', 'v1.0';
    EntityName = 'aadApp';
    EntitySetName = 'aadApps';
    SourceTable = "Name/Value Buffer";
    DelayedInsert = true;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; "ID")
                {
                    Caption = 'ID';
                }
                field(name; "Name")
                {
                    Caption = 'Name';
                }
                field(value; "Value")
                {
                    Caption = 'Value';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        case Name of
            'SetupAzureAdApp':
                begin
                    SetupAzureAdApp(Value);
                end;
            'SetupEMailAdApp':
                begin
                    SetupEMailAdApp(Value);
                end;
        end;
    end;

    local procedure SetupAzureAdApp(argument: Text)
    var
        AzureAdAppSetup: Record "Azure AD App Setup";
        AzureADMgt: Codeunit "Azure AD Mgt.";
    begin
        if not AzureAdAppSetup.FindFirst then
            AzureAdAppSetup.Init;

        AzureAdAppSetup."Redirect URL" := AzureADMgt.GetRedirectUrl;
        AzureAdAppSetup."App ID" := SelectStr(1, argument);
        AzureAdAppSetup.SetSecretKeyToIsolatedStorage(SelectStr(2, argument));

        if not AzureAdAppSetup.Modify(true) then
            AzureAdAppSetup.Insert(true);
    end;

    local procedure SetupEMailAdApp(argument: Text)
    var
        Setup: Record "Email - Outlook API Setup";
        OAuth2: Codeunit "OAuth2";
        RedirectURLTxt: Text;
        EMailAccount: Record "Email - Outlook Account";
        EMailConnector: Enum "EMail Connector";
    begin
        If not Setup.FindFirst() then begin
            Setup.Init();
            Setup.ClientId := CreateGuid();
            Setup.ClientSecret := CreateGuid();
            OAuth2.GetDefaultRedirectUrl(RedirectURLTxt);
            Setup.RedirectURL := RedirectURLTxt;
            IsolatedStorage.Set(Setup.ClientId, SelectStr(1, argument), DataScope::Module);
            IsolatedStorage.Set(Setup.ClientSecret, SelectStr(2, argument), DataScope::Module);
            Setup.Insert(true);
        end;

        if not EMailAccount.FindFirst() then begin
            EMailAccount."Email Address" := SelectStr(3, argument);
            EMailAccount.Name := UserId();
            EMailAccount."Outlook API Email Connector" := EMailConnector::"Microsoft 365";
            EMailAccount.Insert(true);
        end;
    end;

}