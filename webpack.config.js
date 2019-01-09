const path = require('path');

module.exports = {
  target: 'node',
  // Generate sourcemaps for proper error messages
  devtool: 'source-map',
  output: {
    // libraryExport: 'default',
    libraryTarget: 'commonjs2',
    path: path.resolve(__dirname, 'dist/LAYER_NAME'),
    filename: 'index.js',
  },
  mode: 'production',
  optimization: {
    // We do not want to minimize our code.
    minimize: false,
  },
  performance: {
    // Turn off size warnings for entry points
    hints: false,
  },
  // Run babel on all .js files and skip those in node_modules
  module: {
    rules: [
      {
        test: /\.js$/,
        loader: 'babel-loader',
        include: __dirname,
        exclude: /node_modules/,
      },
    ],
  },
};
