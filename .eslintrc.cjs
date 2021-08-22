/* eslint-disable */
module.exports = {
  root: true,
  env: {
    browser: true,
    es6: true,
    node: true
  },
  extends: [
    'eslint:recommended',
    'plugin:coffee/eslint-recommended',
    'plugin:json/recommended'
  ],
  globals: {
    atom: "readonly"
  },
  parser: 'eslint-plugin-coffee',
  plugins: ['coffee'],
  rules: {
    'coffee/no-useless-escape': 'off'
  }
};
