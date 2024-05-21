const path = require('path');

module.exports = {
  mode: 'production',
  entry: './app/javascript/channels/index.js',  // Entry point as per your project structure
  output: {
    filename: 'bundle.js',                    // Output file
    path: path.resolve(__dirname, 'public'),  // Output directory
  },
  module: {
    rules: [
      {
        test: /\.js$/,                        // Transformation rule for JavaScript files
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',             // Using babel-loader for transpiling
          options: {
            presets: ['@babel/preset-env']    // Preset used for transpiling ES6 and above
          }
        }
      }
    ]
  }
};
