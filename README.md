Meteor-Coffee-Modal
====================

WARNING:  Work in progress

A pattern to display application modal dialogs via a bootstrap, written in coffeescript.


##Install

Install via atmosphere.

```bash
mrt add pfafman:coffee-modal
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

There are more undocumented options that need to be documented.  For now I am using this to test how the new packaging system works.



