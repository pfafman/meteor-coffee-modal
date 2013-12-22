Meteor-Coffee-Modal
====================

A pattern to display application modal dialogs via a bootstrap, written in coffeescript.


##Install

Install via atmosphere.

```bash
mrt add coffee-modal
```

##Usage

Include the following in your template:

	{{> coffeeModal}}


To display an alert

```coffeescript
CoffeeModal.message(message, title)
CoffeeModal.alert(message)
CoffeeModal.error(message)
CoffeeModal.confirm(message, title, callback)
```	


##Notes



