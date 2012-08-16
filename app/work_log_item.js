// Generated by CoffeeScript 1.3.3
var Item,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Item = (function(_super) {

  __extends(Item, _super);

  Item.prototype.events = {
    "click .destroy": "remove"
  };

  function Item() {
    this.remove = __bind(this.remove, this);

    this.render = __bind(this.render, this);
    Item.__super__.constructor.apply(this, arguments);
    this.instance.bind("destroy", this.release);
  }

  Item.prototype.render = function() {
    return this.replace($("#itemTemplate").tmpl(this.instance));
  };

  Item.prototype.remove = function() {
    return this.instance.destroy();
  };

  return Item;

})(Spine.Controller);
