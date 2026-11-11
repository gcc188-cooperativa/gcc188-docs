// Conventional Commits com a pasta como escopo, ex.: docs(requisitos): atualizar levantamento (RF-USR-01)
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'scope-enum': [2, 'always', ['requisitos', 'prototipo', 'design', 'padroes', 'ci', 'deps', 'docs']],
    'header-max-length': [2, 'always', 100],
  },
};
