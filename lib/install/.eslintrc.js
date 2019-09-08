// Documentation on http://eslint.org/docs/rules/

module.exports = {
  "extends": ["airbnb-base", "prettier"],
  "plugins": ["prettier"],
  "env": {
    "browser": true,
    "node": true,
    "jquery": true
  },
  "rules": {
    "no-unused-expressions": ["error", { "allowShortCircuit": true }],
    "max-len": ["error", { "code": 113, "tabWidth": 2 }],
    "prettier/prettier": ["error"]
  },
};
