
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
        @set("size", null)
        @set("btnSize", null)
        @set("body_template_data", {})
        @callback = null
        @type = "alert"

    close: ->
        $('#coffeeModal').modal('hide')
        @defaults()

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

    smallMessage: (message, title = "Message", bodyTemplate = null, bodyTemplateData = {}) ->
        @_setData(message, title)
        @set("size", 'modal-sm')
        @set("btnSize", 'btn-sm')
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


    status: (message, callback, title = 'Status', cancelText = 'Cancel') ->
        @_setData message, title, "coffeeModalstatus",
            message: message
        @callback = callback
        @set("submitLabel", cancelText)
        @_show()

    updateProgressMessage: (message) ->
        console.log("updateProgressMessage", $("#progressMessage").html(), message)
        if $("#progressMessage").html()?
            $("#progressMessage").fadeOut 400, ->
                $("#progressMessage").html(message)
                $("#progressMessage").fadeIn(400)
        else
            @set("message", message)

    form: (templateName, data, callback, title = "Edit Record", okText = 'Submit') ->
        #console.log("form", templateName, data)
        @_setData('', title, templateName, data)
        @type = "form"
        @callback = callback
        @set("closeLabel", "Cancel")
        @set("submitLabel", okText)
        @_show()

    fromForm: (form) ->
        result = {}
        form = $(form)
        for key in form.serializeArray() # This Works do not change!!!
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

    template: ->
        if cmGet("body_template")? and Template[cmGet("body_template")]?
            Template[cmGet("body_template")]

    templateData: ->
        cmGet("body_template_data")

    body: ->
        cmGet("message")

    closeLabel: ->
        cmGet("closeLabel")

    submitLabel: ->
        cmGet("submitLabel")

    isForm: ->
        CoffeeModal.type is 'form'

    size: ->
        cmGet("size")

    btnSize: ->
        cmGet("btnSize")


Template.coffeeModal.events
    "click #closeButton": (e, tmpl) ->
        CoffeeModal.doCallback(false, e)

    'submit #modalDialogForm': (e, tmpl) ->
        e.preventDefault()
        CoffeeModal.doCallback(true, e)
        CoffeeModal.close()

Template.coffeeModalstatus.helpers
    progressMessage: ->
        cmGet("message")




