
class CoffeeModalClass

    constructor: ->
        @defaults()

    set: (key, value) ->
        Session.set("_coffeeModal_#{key}", value)
        #@[key] = value

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
        Meteor.defer ->
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
        console.log("form", templateName)
        @_setData('', title, templateName, data)
        @type = "form"
        @callback = callback
        @set("closeLabel", "Cancel")
        @set("submitLabel", okText)
        @_show()

    fromForm: (form) ->
        result = {}
        form = $(form)
        for key in form.serializeArray()
            result[key.name] = key.value
        # Override the result with the boolean values of checkboxes, if any
        for check in form.find "input:checkbox"
            result[$(check).prop 'name'] = $(check).prop 'checked'
        result

    doCallback: (yesNo, event = null) ->
        switch @type
            when 'prompt'
                returnVal = $('#promptInput').val()
            when 'select'
                returnVal = $('select option:selected')
            when 'form'
                returnVal = @fromForm(event.target)
            else
                returnVal = null

        if @callback?
            @callback(yesNo, returnVal, event)

    


CoffeeModal = new CoffeeModalClass()


cmGet = (key) ->
    Session.get("_coffeeModal_#{key}")
    #CoffeeModal[key]

#Template.coffeeModal.created = ->
#    console.log("coffeeModal created")

#Template.coffeeModal.rendered = ->
#    console.log("coffeeModal rendered")
#    Meteor.defer ->
#        $('#promptInput')?.focus()

Template.coffeeModal.helpers
    title: ->
        cmGet("title")

    body: ->
        if cmGet("body_template")? and Template[cmGet("body_template")]?
            Template[cmGet("body_template")](cmGet("body_template_data"))
        else
            cmGet("message")

    closeLabel: ->
        cmGet("closeLabel")

    submitLabel: ->
        cmGet("submitLabel")

    isForm: ->
        CoffeeModal.type is 'form'


Template.coffeeModal.events
    "click #closeButton": (e, tmpl) ->
        CoffeeModal.doCallback(false, e)

    'submit #modalDialogForm': (e, tmpl) ->
        e.preventDefault()
        CoffeeModal.doCallback(true, e)
        $('#coffeeModal').modal('hide')





