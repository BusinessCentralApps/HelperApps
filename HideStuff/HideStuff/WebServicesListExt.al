// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 78801 WebServicesListExt extends "Web Services"
{
    layout
    {
        modify(ODataUrl)
        {
            Visible = false;
        }
        modify(ODataV4Url)
        {
            Visible = false;
        }
        modify(SOAPUrl)
        {
            Visible = false;
        }

    }
}