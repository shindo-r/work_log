
Spine = require('spine')

Spine.Model::validate = ->
  @errors = []
  for message, validator of @validations
    _validator = validator.bind(this)
    @errors.push message if _validator()
  !Spine.isBlank(@errors)

module.exports = Spine