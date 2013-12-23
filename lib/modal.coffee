
class CoffeeModalClass

    constructor: ->
        @defaults()

    set: (key, value) ->
        Session.set("_coffeeModal_#{key}", value)

    defaults: ->
        @set("body_template", null)
        @set("title", 'Message')
        @set("message", '')
        @set("closeLabel", null)
        @set("body_template_data", {})
        @callback = null
        @type = "alert"

    _setData: (message, title = "Message", bodyTemplate = null, bodyTemplateData = {}) ->
        @defaults()
        @set("body_template", bodyTemplate)
        @set("body_template_data", bodyTemplateData)
        @set("title", title)
        @set("message", message)
        @set("submitLabel", "OK")

    _show: ->
        $('#coffeeModal').modal('show') 

    message: (message, title = "Message", bodyTemplate = null, bodyTemplateData = {}) ->
        @_setData(message, title)
        @_show()        

    alert: (message, alert = "Alert", title = "Alert") ->
        @_setData message, title, "coffeeModalAlert",
            label: alert
            message: message
        @_show()

    error: (message, alert = "Error", title = "Error") ->
        @_setData message, title, "coffeeModalError",
            label: alert
            message: message
        @_show()

    confirm: (message, callback, title = "Confirm") ->
        @_setData(message, title)
        @type = "confirm"
        @callback = callback
        @set("closeLabel", "Cancel")
        @set("submitLabel", "Yes")
        @_show()

    prompt: (message, callback, title = 'Prompt', okText = 'Submit', placeholder = "Enter something ...") ->
        @_setData message, title, "coffeeModalPrompt",
            message: message
            placeholder: placeholder
        @type = "prompt"
        @callback = callback
        @set("closeLabel", "Cancel")
        @set("submitLabel", okText)
        $('#promptInput').val('')
        @_show()


    form: (templateName, data, callback, title = "Edit Record", okText = 'Submit') ->
        @_setData(message, title, templateName, data)
        @type = "form"
        @callback = callback
        @set("closeLabel", "Cancel")
        @set("submitLabel", okText)
        @_show()

    doCallback: (yesNo, event = null) ->

        switch @type
            when 'prompt'
                returnVal = $('#promptInput').val()
            when 'select'
                returnVal = $('select option:selected')
            when 'form'
                returnVal = @fromForm(e.target)
            else
                returnVal = null

        if @callback?
            @callback(yesNo, returnVal, event)



CoffeeModal = new CoffeeModalClass()

#Template.coffeeModal.rendered = ->
#    Meteor.defer ->
#        $('#promptInput')?.focus()

Template.coffeeModal.helpers
    title: ->
        Session.get("_coffeeModal_title")

    body: ->
        if Session.get("_coffeeModal_body_template")? and Template[Session.get("_coffeeModal_body_template")]
            Template[Session.get("_coffeeModal_body_template")](Session.get("_coffeeModal_body_template_data"))
        else
            Session.get("_coffeeModal_message")

    closeLabel: ->
        Session.get("_coffeeModal_closeLabel")

    submitLabel: ->
        Session.get("_coffeeModal_submitLabel")


Template.coffeeModal.events
    "click #closeButton": (e, tmpl) ->
        CoffeeModal.doCallback(false, e)

    "click #submitButton": (e, tmpl) =>
        CoffeeModal.doCallback(true, e)
        $('#coffeeModal').modal('hide')





