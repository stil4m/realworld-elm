'use strict';

const Elm = require('./Main.elm');
const node = document.getElementById('main');
const app = Elm.Main.embed(node);
