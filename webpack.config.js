'use strict';

const path = require('path');
const webpack = require('webpack');


function path_gen(file_path) {
  return path.resolve(__dirname, file_path);
}

const source_path = path_gen('src');
const public_path = path_gen('public');

const loader_options = new webpack.LoaderOptionsPlugin({
  test: /\.elm/,
  options: {
    cwd: source_path,
    pathToMake: 'node_modules/.bin/elm-make',
    verbose: true,
    debug: true,
    help: true,
    warn: true
  }
});

const elm_module = {
  test: /\.elm/,
  include: [source_path],
  loader: 'elm-webpack-loader',
};

const main_config = {
  entry: './src/index.js',
  output: {
    path: public_path,
    filename: 'app.js'
  },

  module: {
    rules: [elm_module]
  },

  plugins: [
    loader_options,
  ],
};

module.exports = main_config;
