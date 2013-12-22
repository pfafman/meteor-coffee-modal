
class CoffeeModalClass

    constructor: ->
        @defaults()


    defaults: ->
        console.log("CoffeeModal defaults")
        Session.set("_coffeeModal_body_template", null)
        Session.set("_coffeeModal_title", 'Message')
        Session.set("_coffeeModal_message", '')
        Session.set("_coffeeModal_closeLabel", null)
        Session.set("_coffeeModal_body_template_data", {})
        @callback = null

    _setData: (message, title="Message", bodyTemplate=null, bodyTemplateData= {}) ->
        @defaults()
        Session.set("_coffeeModal_body_template", bodyTemplate)
        Session.set("_coffeeModal_body_template_data", bodyTemplateData)
        Session.set("_coffeeModal_title", title)
        Session.set("_coffeeModal_message", message)
        Session.set("_coffeeModal_submitLabel", "OK")

    _show: ->
        $('#coffeeModal').modal('show') 

    message: (message, title="Message", bodyTemplate=null, bodyTemplateData= {}) ->
        @_setData(message, title)
        @_show()        

    alert: (message, alert="Alert", title="Alert") ->
        @_setData message, title, "coffeeModalAlert",
            label: alert
            message: message
        @_show()

    error: (message, alert="Alert", title="Alert") ->
        @_setData message, title, "coffeeModalError",
            label: alert
            message: message
        @_show()

    confirm: (message, callback, title="Confirm") ->
        @_setData(message, title)
        @callback = callback
        Session.set("_coffeeModal_closeLabel", "Cancel")
        Session.set("_coffeeModal_submitLabel", "Yes")
        @_show()

CoffeeModal = new CoffeeModalClass()

Template.coffeeModal.helpers
    title: ->
        Session.get("_coffeeModal_title")

    body: ->
        if Session.get("_coffeeModal_body_template")? and Template[Session.get("_coffeeModal_body_template")]
            console.log("alert body")
            Template[Session.get("_coffeeModal_body_template")](Session.get("_coffeeModal_body_template_data"))
        else
            Session.get("_coffeeModal_message")

    closeLabel: ->
        Session.get("_coffeeModal_closeLabel")

    submitLabel: ->
        Session.get("_coffeeModal_submitLabel")


Template.coffeeModal.events
    "click #closeButton": (e, tmpl) ->
        console.log('close modal')

    "click #submitButton": (e, tmpl) =>
        console.log("submit callback", CoffeeModal.callback)
        if CoffeeModal.callback?  # Check that is is a functin
            console.log("have callback")
            CoffeeModal.callback()
        $('#coffeeModal').modal('hide')





