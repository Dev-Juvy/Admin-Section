function Getarea() {
    $.ajax({
        type: "POST",
        url: "Webpages/CorpMenu.aspx/Getarea",
        data: "{area}", //{ playerId: $("#drpregion:selected").val() },
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (area) {
            //change second drop down here according to the returned countryId using javascript
            $("#drpregion").val(area);
        }
    });
}
