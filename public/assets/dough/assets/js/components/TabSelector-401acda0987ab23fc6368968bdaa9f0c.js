define(["jquery","DoughBaseComponent","eventsWithPromises","mediaQueries"],function(t,e,s,i){"use strict";var r,a={collapseInSmallViewport:!1,uiEvents:{"click [data-dough-tab-selector-trigger]":"_handleClickEvent"}},o={triggersOuter:"[data-dough-tab-selector-triggers-outer]",triggersInner:"[data-dough-tab-selector-triggers-inner]",triggerContainer:"data-dough-tab-selector-trigger-container",trigger:"data-dough-tab-selector-trigger",target:"data-dough-tab-selector-target",activeClass:"is-active",inactiveClass:"is-inactive",collapsedClass:"is-collapsed"},n={selected:"selected",show:"click to show"};return r=function(e,s){var i;r.baseConstructor.call(this,e,s,a),this.i18nStrings=s&&s.i18nStrings?s.i18nStrings:n,this.selectors=t.extend(this.selectors||{},o),this._checkComponentMarkup(),this._setupAccessibility(),this.$firstTrigger.length&&(i=this.$firstTrigger.attr(o.trigger),this._updateTriggers(i)),this.config.collapseInSmallViewport===!0&&this._updateCollapsedState(),this._subscribeHubEvents()},e.extend(r),r.prototype.init=function(t){return this.isComponentMarkupValid===!0?this._initialisedSuccess(t):this._initialisedFailure(t),this},r.prototype._checkComponentMarkup=function(){this.$triggersWrapperOuter=this.$el.find(o.triggersOuter),this.$triggersWrapperInner=this.$el.find(o.triggersInner).addClass(this.selectors.inactiveClass),this.$triggerContainers=this.$el.find("["+o.triggerContainer+"]"),this.$firstTrigger=this.$triggersWrapperInner.find("["+o.trigger+"]").first(),this.isComponentMarkupValid=!!(this.$triggersWrapperOuter.length&&this.$triggersWrapperInner.length&&this.$firstTrigger.length)},r.prototype._setupAccessibility=function(){this.$el.find("["+o.target+"]").attr({"aria-hidden":"true",tabindex:"-1"}),this._convertLinksToButtons()},r.prototype._setTriggerWrapperHeight=function(){this.$triggersWrapperOuter.height(this.$triggersWrapperInner.outerHeight())},r.prototype._subscribeHubEvents=function(){this.config.collapseInSmallViewport===!0&&s.subscribe("mediaquery:resize",t.proxy(this._updateCollapsedState,this))},r.prototype._updateCollapsedState=function(){this.$el.removeClass(this.selectors.collapsedClass),this._haveTriggersWrapped()&&(this.$triggersWrapperInner.removeClass(this.selectors.activeClass).addClass(this.selectors.inactiveClass),this.$el.addClass(this.selectors.collapsedClass),this._setTriggerWrapperHeight())},r.prototype._haveTriggersWrapped=function(){var e,s=!1;return this.$triggerContainers.each(function(i){0===i?e=t(this).position().top:t(this).position().top>e+t(this).height()&&(s=!0)}),s},r.prototype._convertLinksToButtons=function(){var e=this;this.$el.find("["+this.selectors.trigger+"]").each(function(){var s=t(this).html(),i=t(this).attr(o.trigger);t(this).replaceWith('<button class="tab-selector__trigger unstyled-button" type="button" '+o.trigger+'="'+i+'">'+s+' <span class="visually-hidden" data-dough-tab-selector-show> '+e.i18nStrings.show+'</span><span class="tab-selector__icon icon"></span></button>')})},r.prototype._handleClickEvent=function(e){var s,i=t(e.currentTarget);return this._deSelectItem(this.$triggerContainers.filter(".is-active")),s=i.attr(o.trigger),this._updateTriggers(s),this._positionMenu(i),this._updateTargets(s),this._toggleMenu(i),e.preventDefault(),this},r.prototype._deSelectItem=function(t){return t.removeClass(this.selectors.activeClass).addClass(this.selectors.inactiveClass).attr("aria-selected",!1),this},r.prototype._toggleMenu=function(t){return t.closest(this.$triggersWrapperInner).length||this.$triggersWrapperInner.hasClass(this.selectors.activeClass)?(this.$triggersWrapperInner.toggleClass(this.selectors.activeClass).toggleClass(this.selectors.inactiveClass),this._positionMenu(t),this):void 0},r.prototype._positionMenu=function(t){var e;return t&&(e=this.$triggersWrapperInner.hasClass(this.selectors.activeClass)?-1*t.position().top+1:0,t.length&&this.$triggersWrapperInner.css("top",e)),this},r.prototype._updateTriggers=function(t){var e=this.$el.find("["+o.trigger+'="'+t+'"]'),s=this.$el.find("["+o.trigger+"]").not(e);return e.removeClass(this.selectors.inactiveClass).addClass(this.selectors.activeClass).hide().show().attr({"aria-selected":"true"}).find("[data-dough-tab-selector-show]").text(this.i18nStrings.selected),e.closest("["+o.triggerContainer+"]").removeClass(this.selectors.inactiveClass).addClass(this.selectors.activeClass),s.removeClass(this.selectors.activeClass).addClass(this.selectors.inactiveClass).attr("aria-selected","false").find("[data-dough-tab-selector-show]").text(this.i18nStrings.show),s.closest("["+o.triggerContainer+"]").removeClass(this.selectors.activeClass).addClass(this.selectors.inactiveClass),this},r.prototype._updateTargets=function(t){var e=this.$el.find("["+o.target+'="'+t+'"]'),s=this.$el.find("["+o.target+"]").not("["+o.target+'="'+t+'"]');return e.removeClass(this.selectors.inactiveClass).addClass(this.selectors.activeClass).attr({"aria-hidden":"false",tabindex:-1}),this._focusTarget(e),s.removeClass(this.selectors.activeClass).addClass(this.selectors.inactiveClass).attr({"aria-hidden":"true"}).removeAttr("tabindex"),this},r.prototype._focusTarget=function(e){var s;i.atSmallViewport()||(s=t(window).scrollTop(),e.focus(),t("html,body").scrollTop(s))},r});