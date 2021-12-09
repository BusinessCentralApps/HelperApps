codeunit 50000 EnableEncryption
{
    Subtype = Install;

    trigger OnInstallAppPerDatabase()
    var
        CryptoMgmt: Codeunit "Cryptography Management";
        OK: Boolean;
    begin
        OK := CreateEncryptionKey();
        if not CryptoMgmt.IsEncryptionEnabled() then begin
            CryptoMgmt.EnableEncryption(True);
        end;
    end;
}