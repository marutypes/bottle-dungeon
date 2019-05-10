const typography = require('postcss-typography');
const tailwind = require("tailwindcss");
const postcssPresetEnv = require('postcss-preset-env');


module.exports = {
  plugins: [
    tailwind("./tailwind.js"),
    postcssPresetEnv({
      stage: 0,
    }),
    typography({
      baseFontSize: '18px',
      baseLineHeight: 1.45,
      headerFontFamily: ['Avenir Next', 'Helvetica Neue', 'Segoe UI', 'Helvetica', 'Arial', 'sans-serif'],
      bodyFontFamily: ['Georgia', 'sans-serif'],
    }),
  ]
};
