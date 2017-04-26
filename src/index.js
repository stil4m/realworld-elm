'use strict';

require('./index.html');

const Elm = require('./Main.elm');
const node = document.getElementById('main');
const app = Elm.Main.embed(node);
