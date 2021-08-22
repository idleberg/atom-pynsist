import { babel } from '@rollup/plugin-babel';
import { nodeResolve } from '@rollup/plugin-node-resolve';
import { terser } from "rollup-plugin-terser";
import coffeescript from 'rollup-plugin-coffee-script';
import commonjs from '@rollup/plugin-commonjs';
import json from '@rollup/plugin-json';

const production = !process.env.ROLLUP_WATCH;
const extensions = ['.cjs', '.js', '.jsx', '.mjs', '.coffee'];

const plugins = [
  coffeescript(),
  babel({
    extensions: extensions,
    babelHelpers: 'bundled',
  }),
  commonjs({
    extensions: extensions
  }),
  json(),
  nodeResolve({
    extensions: extensions,
    preferBuiltins: true
  }),
  production && terser()
];

export default [
  {
    input: 'src/main.coffee',
    output: {
      dir: 'lib',
      exports: 'default',
      format: 'cjs',
      sourcemap: production ? false : true
    },
    external: [
      // Atom
      'atom',
      'electron'
    ],
    plugins: plugins
  }
];
