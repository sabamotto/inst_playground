// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.styl"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import Vue from 'vue'
import ConfirmationModal from './modals/ConfirmationModal.vue'
Vue.component('confirm', ConfirmationModal)

import Playground from './Playground.vue'

let app = null

let container = document.getElementById('PlaygroundRoot')
if (container) {
  const title = container.getAttribute('title')
  app = new Vue(Playground).$mount(container)
  app.title = title
}
